%% make_all_figures_ensemblev2
% This script analyses the output of the numerical simulations made with
% the script doGEBMsimulationbatch.m.

%% Close figures
close all

%% make filename to read
file_name = [path name];
load([file_name '.mat'])

%% Make time series figures
f1=make_time_series_figures_ensemblev2(var,par);
savefigure(name,f1,printfigs);

