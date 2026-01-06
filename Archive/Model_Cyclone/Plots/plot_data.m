function output = plot_data(in_CycloneStruct, custom_ylabel, indices)
%% PLOT_DATA Plot cyclone SLP data centered on event

    if nargin < 3 || isempty(indices)
        indices = 1:size(in_CycloneStruct, 2);
    end

timebefore = 400;
timeafter = 100;

CycloneStruct = in_CycloneStruct;
event_index = CycloneStruct(1).event_index;
xlims = (event_index-timebefore):(event_index+timeafter);
xaxis = xlims - event_index;

NumCyclones = size(indices,2);

figure
ax1 = subplot(1,1,1);
hold on

for i = 1:NumCyclones
    dummy = CycloneStruct(indices(i)).slp_data_RO12;
    
    plot(ax1, xaxis, dummy(xlims), 'LineStyle','-', 'Color',0.6*[1,1,1])
end
ylabel(ax1, custom_ylabel)
xlabel(ax1, 'Time before event')

yl = ylim;

if timeafter>0
    plot(ax1, [0,0], yl, 'LineStyle','--', 'Color', 'k');
end

hold off
