%% doGEBMsimulation
% Based on code by Bastiaansen, Ashwin and von der Heydt (2022)
% see https://github.com/peterashwin/late-tipping-2022
%%
% This script runs a numerical simulation for the following energy balance
% model, which potentially has fast-slow behaviour or a coupling to a
% chaotic Lorenz system.
% C_T dT/dt = Q0 (1 - alpha) - epsilon(T) sigma T^4 + mu + mu_NV
% alpha = alpha_0(T)
% mu_NV = nu_NV *sin(pi x/20), where x is the first component of a
% Lorenz-63 model, i.e.
% tau_NV dx/dt = sigma_L (y-x)
% tau_NV dy/dt = x (rho_L - z) - y
% tau_NV dz/dt = xy - beta_L z
%

%% Start with a clean slate
close all
clear all
%% Start timer
tic

%% Load model run parameters for batches
run('GEBMrunparamsbatchv2.m');


for i=1:length(pars)
    %% run through each of the parameter values
    par=pars(i);
    toc;
    for j=1:par.EnsembleSize
        sprintf('Ensemble %d, run %d of %d',i,j,par.EnsembleSize)

        %% Initial state vector
        par.y0 = [par.T0; par.alpha0];

        %% Setup initial conditions for Lorenz system
        par.y0_L = [par.xs * (rand()-0.5)+par.xm; par.ys * (rand()-0.5)+par.ym;  par.zs * (rand()-0.5)+par.zm];

        %% Simulation Setup
        % Options for ode45
        options.ode_opts = odeset('AbsTol', 1e-6); % for ode45

        %% Call the function that runs the actual numerical simulation
        [vars] = GEBMsimulatorv2(par,options);
        var(j)=vars;
    end

    %% Save data and pars
    path = '../Data/';
    name = par.Name;
    file_name = [path name];

    save( [file_name '.mat'], 'par', 'var', 'options');

end

%% Stop timer
toc
