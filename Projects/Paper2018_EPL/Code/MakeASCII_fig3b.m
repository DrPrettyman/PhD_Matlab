load('../../../Data/MAT_files/PSEcomp.mat')

%% create the xaxis
event_index = 2641;
xlims = (event_index-400):(event_index);
xaxis = xlims - event_index;

%% read in and write to NetCDF: 100-window PSE
mean100 = PSEcomp(15).PSE100(xlims);
std100 = PSEcomp(16).PSE100(xlims);
upp100 = mean100+std100;
low100 = mean100-std100;

figure
hold on
plot(xaxis, mean100)
plot(xaxis, upp100)
plot(xaxis, low100)
hold off

dataPSE100_fig3b = [xaxis', mean100', std100'];
save('../Data/dataPSE100_fig3b.dat','dataPSE100_fig3b','-ascii')

%% read in and write to NetCDF: 220-window PSE
mean220 = PSEcomp(15).PSE220(xlims);
std220 = PSEcomp(16).PSE220(xlims);
upp220 = mean220+std220;
low220 = mean220-std220;

figure
hold on
plot(xaxis, mean220)
plot(xaxis, upp220)
plot(xaxis, low220)
hold off

dataPSE220_fig3b = [xaxis', mean220', std220'];
save('../Data/dataPSE220_fig3b.dat','dataPSE220_fig3b','-ascii')



%% Display

