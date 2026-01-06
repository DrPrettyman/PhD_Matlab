load('../../../Data/MAT_files/ACFcomp.mat')

%% create the xaxis
event_index = 2641;
xlims = (event_index-400):(event_index);
xaxis = xlims - event_index;

%% read in and write to NetCDF: 100-window ACF
mean100 = ACFcomp(15).ACF100(xlims);
std100 = ACFcomp(16).ACF100(xlims);
upp100 = mean100+std100;
low100 = mean100-std100;

figure
hold on
plot(xaxis, mean100)
plot(xaxis, upp100)
plot(xaxis, low100)
hold off

dataACF100_fig3c = [xaxis', mean100', std100'];
save('../Data/dataACF100_fig3c.dat','dataACF100_fig3c','-ascii')

%% read in and write to NetCDF: 220-window ACF
mean220 = ACFcomp(15).ACF220(xlims);
std220 = ACFcomp(16).ACF220(xlims);
upp220 = mean220+std220;
low220 = mean220-std220;

figure
hold on
plot(xaxis, mean220)
plot(xaxis, upp220)
plot(xaxis, low220)
hold off

dataACF220_fig3c = [xaxis', mean220', std220'];
save('../Data/dataACF220_fig3c.dat','dataACF220_fig3c','-ascii')



%% Display

