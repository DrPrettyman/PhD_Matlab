load('../../../Data/MAT_files/PSEcomp.mat')

%% create the xaxis
event_index = 2641;
xlims = (event_index-400):(event_index+100);
xaxis = xlims - event_index;

%% read in and write to file: slp_data
data_H = zeros(size(xlims,2),15);
data_H(:,1) = xaxis';
for i = 1:14
    data_H(:,i+1) = PSEcomp(i).slp_data(xlims);
end
save('../Data/data_H_fig3a.dat','data_H','-ascii')

%% plot
figure
hold on
for i = 1:14
    plot(xaxis, data_H(:,i+1))
end
hold off
