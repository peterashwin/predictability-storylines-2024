function ff=make_time_series_figures_ensemblev2(var,par)
%make_time_series_figures makes time series figures for the variables

N=par.EnsembleSize;
%% Temperature
for j=1:N
    DTs(:,j) = var(j).T - par.Teq;
end
t=var.t;

%% create figure
figure();
clf;
f=gcf();
f.Position(3:4)=[330 330];


DTup=DTs(end,:)>par.Threshold;
hold on
for i=1:par.EnsembleSize
    if DTup(i) 
       plot(t,DTs(:,i), '-', 'Color', [1 0 0],'linewidth', 0.1);
    else
        plot(t,DTs(:,i), '-', 'Color', [0 0 1], 'linewidth', 0.1);
    end
end

xlabel('$t$ [year]', 'Interpreter', 'latex')
ylabel('$\Delta T$ [K]', 'Interpreter', 'latex')
%plot(t, mean(DTs,2), 'r-', 'linewidth', 2.0)
xlim([par.ShowStartTime t(end)]);
title(sprintf("P=%f",sum(DTup)/par.EnsembleSize), 'Interpreter', 'latex');



cur_fig = gcf();
ff = cur_fig.Number;

end

