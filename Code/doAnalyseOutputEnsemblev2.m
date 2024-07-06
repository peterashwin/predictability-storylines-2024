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
labtext='A';
run('make_all_figures_ensemblev2.m');

%%
name = 'runB';
labtext='B';
run('make_all_figures_ensemblev2.m');

%%
name = 'runC';
labtext='C';
run('make_all_figures_ensemblev2.m');

%%
name = 'runD';
labtext='D';
run('make_all_figures_ensemblev2.m');

%%
name = 'runE';
labtext='E';
run('make_all_figures_ensemblev2.m');

%%
name = 'runF';
labtext='F';
run('make_all_figures_ensemblev2.m');
