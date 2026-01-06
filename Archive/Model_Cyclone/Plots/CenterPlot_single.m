function output_args = CenterPlot_single(structure11, tbefore, tafter)
    if nargin < 3 || isempty(tafter)
        tafter = 24;
    end

%CENTERPLOT_SINGLE 
% Very simply plots a single slp_data_RO12 series, with the x-axis
% centered at the event date.

data = structure11.slp_data_RO12(structure11.event_index - tbefore:...
    structure11.event_index + tafter);

xaxis = (1:size(data, 1))' - tbefore - 1;

figure
plot(xaxis, data);

end

