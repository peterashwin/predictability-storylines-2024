%% script with GEBM run parameters for batch
% Jun 2024
% define default parameters and then a number of variants as
% pars(1..n)
%

%% Default parameters
% Incoming solar radiation
par.Q0 = 341.3;

% Temperature-dependent equilibrium values for albedo
par.alpha_1 = 0.6;
par.alpha_2 = 0.52;
par.T_alpha = 280;
par.K_alpha = 1.0;
par.alpha_0 = @(T,p) p.alpha_1 + (p.alpha_2-p.alpha_1) * ...
    (1 + tanh(p.K_alpha*(T-p.T_alpha)))/2;

% Outgoing radiation
par.sigma = 5.67e-8;

%  emissivity
par.eps = 0.43; 

% Heat capacity 
par.C_T = 5e8;

% seconds per year
par.S = 31556926;

%% Lorenz-63 system
% Standard/original values are sigma=10,beta=8/3 and rho=28
par.sigma_L = 10;
par.rho_L = 28;
par.beta_L = 8/3;
% Initial conditions for Lorenz-63; random ICs in range
par.y0_L = [0.0; 0.0; 0.0]; %[par.xs * (rand()-0.5)+par.xm; par.ys * (rand()-0.5)+par.ym;  par.zs * (rand()-0.5)+par.zm];
par.xs=20;
par.ys=20;
par.zs=5;
par.xm=0;
par.ym=0;
par.zm=5;

%% Coupling function, strength and timescale for the Lorenz system
par.mu_NV = @(x,p) p.nu_NV * sin(pi*x/20);
par.nu_NV = 5;
par.tau_NV = 6e7; % 3e8 is a timescale of 10 years

%% Equilibrium temperature and albedo
par.Teq = 274;
%par.alphaeq = par.alpha_0(par.Teq,par);
par.alphaeq = par.alpha_0(par.Teq,par);

%% Initial temp
par.T0 = par.Teq;
par.alpha0=par.alphaeq;

%% Set background CO2 forcing such that Teq is an equilibrium:
par.mu0 = @(p) p.eps.*p.sigma.*p.Teq.^4-p.Q0 .* (1 - p.alphaeq);

%% Forcing scenario
par.A0 = 5.35;
%par.mu = @(t,p) (p.A0 * log(4).*(t>0) + p.mu0(p)); % Instantaneous Quadrupling 
%par.mu = @(t,p) (p.A0 * log(4) .* (t>0).*(t<75) + p.mu0(p)); % Instantaneous Quadrupling for 0<t<75
par.mu = @(t,p) (p.A0 * (log(4) .* (t>0).*(t<75)+log(2).*(t>75)) + p.mu0(p)); % Instantaneous Quadrupling for 0<t<75 then back to doubling

%% Simulation Setup -- Options for time integration
par.StartTime=-100;
par.ShowStartTime=-100;
par.EndTime = 150;
par.Name='default';

%% ensemble size
par.EnsembleSize = 500;
% threshold on T at EndTime
par.Threshold=6.0;

%%%%
% default 
pars(1)=par;
pars(1).Name='RunA';

%
pars(2)=par;
pars(2).Name='RunB';
pars(2).xs=1;
pars(2).ys=1;
pars(2).zs=1;
pars(2).xm=0;
pars(2).ym=0;
pars(2).zm=5;

%
pars(3)=par;
pars(3).Name='RunC';
pars(3).T0 = par.Teq+2;

%
pars(4)=par;
pars(4).Name='RunD';
pars(4).T0 = par.Teq-2;

%
pars(5)=par;
pars(5).Name='RunE';
pars(5).StartTime=-10;

%
pars(6)=par;
pars(6).Name='RunF';
pars(6).T0 = par.Teq+6;
