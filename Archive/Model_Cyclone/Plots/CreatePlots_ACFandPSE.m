
%% Plot the cyclone ACF and PSE mean

load('cyclones100.mat')
indices = [1:8,12,13,14,16,17,19];
plot_ACFandPSE(cyclones100, 3)

%% Plot the Branching model ACF and PSE mean

load('branching_basic.mat')
plot_ACFandPSE(branching, 5)

