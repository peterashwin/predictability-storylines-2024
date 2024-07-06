%% doAnalyseOutputEnsemblev2
% This script analyses the output of the numerical simulations made with
% the script doGEBMsimulationbatch.m.
% and prints figures using make_all_figures_ensemble.m

%% Start with a clean slate
clear all

%% OPTIONAL: TURN OFF WARNINGS
warning('off','all')
warning
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
%%
printfigs=true;

%% Obtain data from file
path = '../Data/';

%%
name = 'runA';
run('make_all_figures_ensemblev2.m');

%%
name = 'runB';
run('make_all_figures_ensemblev2.m');

%%
name = 'runC';
run('make_all_figures_ensemblev2.m');

%%
name = 'runD';
run('make_all_figures_ensemblev2.m');

%%
name = 'runE';
run('make_all_figures_ensemblev2.m');

%%
name = 'runF';
run('make_all_figures_ensemblev2.m');
