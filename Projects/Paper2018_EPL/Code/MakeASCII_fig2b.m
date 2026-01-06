load('branching_basic.mat')

%% create the xaxis
xaxis = 0:1000;

%% Find the mean
All_PSE100 = zeros(1001,100);
for i = 1:100
    All_PSE100(:,i) = branching(i).PSE100;
end
mean100 = mean(All_PSE100');
std100 = std(All_PSE100');
clear All_PSE100

data = [xaxis', mean100', std100'];
save('dataPSE100_fig2b.dat','data','-ascii');

figure
hold on
plot(xaxis, mean100)
plot(xaxis, mean100-std100)
plot(xaxis, mean100+std100)
hold off
