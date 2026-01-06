load('branching_basic.mat')

%% create the xaxis

xaxis = 0:1000;

%% read in and write to file: slp_data
data_B = zeros(size(xaxis,2),101);
data_B(:,1) = xaxis';
for i = 1:100
    data_B(:,i+1) = branching(i).slp_data_RO12;
end
save('data_B_fig2a.dat','data_B','-ascii')

%% plot
figure
hold on
for i = 1:100
    plot(xaxis, data_B(:,i+1))
end
hold off
