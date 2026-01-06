function output = plot_ACFandPSE(in_CycloneStruct, windowchoice, indices)
    if nargin < 3 || isempty(indices)
        indices = 1:size(in_CycloneStruct, 2);
    end

%% windowchoice: 1 - 24point. 2 - 48point. 3 - 120point. %%
%%               4 - 240point. 5 - 360point. 6 - 480point.

CycloneStruct = in_CycloneStruct;

stats = stats_ACFandPSE(CycloneStruct, indices);

event_index = CycloneStruct(1).event_index;
xlims = (event_index-400):(event_index);
xaxis = xlims - event_index;

figure
ax1 = subplot(1,2,1);
hold on

for i = windowchoice
    upp = stats(i).mACF(xlims) + stats(i).sACF(xlims);
    low = stats(i).mACF(xlims) - stats(i).sACF(xlims);
    
    plot(ax1, xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    plot(ax1, xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    
    plot(ax1, xaxis, stats(i).mACF(xlims), 'LineWidth',1.5, 'Color','k')
    %plot(ax1, xaxis, CycloneStruct(6).ACF240(xlims), 'LineWidth',0.5, 'Color','r')
end
ylabel(ax1, 'ACF Propogator value');
xlabel(ax1, 'Time before event');
hold off

ax2 = subplot(1,2,2);
hold on
set(ax2,'yaxislocation','right');
for i = windowchoice
    upp = stats(i).mPSE(xlims) + stats(i).sPSE(xlims);
    low = stats(i).mPSE(xlims) - stats(i).sPSE(xlims);
    
    plot(ax2, xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    plot(ax2, xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    
    plot(ax2, xaxis, stats(i).mPSE(xlims), 'LineWidth',1.5, 'Color','k')
    %plot(ax2, xaxis, CycloneStruct(6).PSE240(xlims), 'LineWidth',0.5, 'Color','r')
end
ylabel(ax2, 'PSE Propogator value');
xlabel(ax2, 'Time before event');
hold off
end

