function [var] = GEBMsimulatorv2(par,options)
%GEBMsimulator. Performs numerical time integration of energy balance
%model.

y0 = par.y0(1);
y0 = [y0; par.y0_L];
tspan = par.StartTime:2:par.EndTime;

[t,y] = ode45(@(t,y) balance_model(t,y,par), tspan, y0, options.ode_opts);

%% Obtain the desired outputs

% Obtain the (instantaneous) time derivatives via the ODE function
dydt = nan(size(y));
for i=1:length(t)
    dydt(i,:) = balance_model( t(i), y(i,:), par);
end
% Then obtain the separate variables

T = y(:,1);
dTdt = dydt(:,1);

alpha = par.alpha_0(T,par);
dalphadt = nan(size(T));
% If nu_NV = 0 then we do not have the Lorenz system part
x_L = y(:,end-2);
y_L = y(:,end-1);
z_L = y(:,end);


%% Put everything together
var.t = t;
var.T = T;
var.dTdt = dTdt;
var.alpha = alpha;
var.dalphadt = dalphadt;
var.x_L = x_L;
var.y_L = y_L;
var.z_L = z_L;

end


%% Create the right-hand side of the equation
% Here there are a few scenarios
% If tau_alpha = 0 then we need to set alpha = alpha_0(T) manually and need
% to eliminate alpha as dynamic system component
% If nu_NV then we do not need the Lorenz-63 model as it does not influence
% the temperature evolution
function dydt = balance_model(t, y, par)

% Temperature evolution and albedo evolution
%dTdt = @(T,alpha,mu) par.Q0 * (1-alpha) - ...
%    par.eps .* par.sigma .* T.^4 + mu;
%dydt = par.S * dTdt(T,par.alpha_0(T,par),par.mu(t,par)) / par.C_T;

T = y(1);
dydt = (par.Q0 * (1-par.alpha_0(T,par)) - ...
    par.eps .* par.sigma .* T.^4 + par.mu(t,par))*(par.S/par.C_T);

% The evolution of the Lorenz system:
z = y(end-2:end); % obtain lorenz variables
dzdt = [ par.sigma_L * ( z(2) - z(1) ); ...
    z(1) .* ( par.rho_L - z(3) ) - z(2) ; ...
    z(1) .* z(2) - par.beta_L * z(3) ] * par.S / par.tau_NV;

% Coupling to the energy balance model
mu_NV = par.mu_NV(z(1),par);

% add this to dydt's first component
dydt(1) = dydt(1) + mu_NV * par.S/par.C_T;

% Combine everything into one vector for dydt
dydt = [ dydt; dzdt];

end
