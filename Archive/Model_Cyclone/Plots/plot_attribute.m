function [attrMean, attrStd] = plot_attribute(in_CycloneStruct, attrName, indices)
    if nargin < 3 || isempty(indices)
        indices = 1:size(in_CycloneStruct, 2);
    end

%% windowchoice: 1 - 24point. 2 - 48point. 3 - 120point. %%
%%               4 - 240point. 5 - 360point. 6 - 480point.

CycloneStruct = in_CycloneStruct;
NumCyclones = size(indices,2);

allAttr = zeros(NumCyclones, size(CycloneStruct(1).(attrName),1));
for i = indices
    allAttr(i,:) = CycloneStruct(indices(i)).(attrName);
end
attrMean = mean(allAttr);
attrStd = std(allAttr);

event_index = CycloneStruct(1).event_index;
xlims = (event_index-400):event_index;
xaxis = xlims - event_index;

figure
ax1 = subplot(1,1,1);
hold on


upp = attrMean(xlims) + attrStd(xlims);
low = attrMean(xlims) - attrStd(xlims);

plot(ax1, xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
plot(ax1, xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])

plot(ax1, xaxis, attrMean(xlims), 'LineWidth',1.5, 'Color','k')
%plot(ax1, xaxis, CycloneStruct(6).ACF240(xlims), 'LineWidth',0.5, 'Color','r')

ylabel(ax1, attrName);
xlabel(ax1, 'Time before event');
hold off
end

