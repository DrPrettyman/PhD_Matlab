%% Plot PSEcomp

% PSEcomp is a structure created by applying AddPSE repeatedly to a data
% structure with increasing windowsize from 40 to 250. It therefore has the
% attributes "data", "PSE40", "PSE50", ... "PSE250".
% Here we plot all the PSE propogators together as a big mess of lines. It
% is better to plot as a contour plot with windowsize on the y axis.

event_index = PSEcomp(15).event_index;

figure
hold on
for i = [70,130,190]
    mean_i = PSEcomp(15).(['PSE',num2str(i)]);
    plot( (-400:0), mean_i(event_index - 400 : event_index) );
end
xlabel('time from event')
ylabel('PSE indicator')