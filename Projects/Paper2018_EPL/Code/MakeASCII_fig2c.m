load('branching_basic.mat')

%% create the xaxis
xaxis = 0:1000;

%% Find the mean
All_ACF100 = zeros(1001,100);
for i = 1:100
    All_ACF100(:,i) = branching(i).ACF100;
end
mean100 = mean(All_ACF100');
std100 = std(All_ACF100');
clear All_PSE100

data = [xaxis', mean100', std100'];
save('dataACF100_fig2c.dat','data','-ascii');

figure
hold on
plot(xaxis, mean100)
plot(xaxis, mean100-std100)
plot(xaxis, mean100+std100)
hold off
