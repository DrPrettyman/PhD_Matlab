load('cyclones100.mat')
indices = [1:8,12,13,14,16,17,19];
NumCyclones = size(indices,2);
event_index = cyclones100(1).event_index;

%% Set the length of the series to examine (ending at point 0)
length = 100;
xaxis = (-length:0)';

%% Fit an exponential curve to all cyclones individually and 
%  record the a and b parameters [fit = a*exp(b*x)]
all_ab_values = zeros(NumCyclones,2);
%AllCyclones48 = zeros(NumCyclones, length+1); % array of all data - in case
for i = 1:NumCyclones
    exp_fit_to_slp_data = fit(xaxis,...
        cyclones100(indices(i)).slp_data_RO12((event_index-length):event_index)...
        ,'exp1');
    all_ab_values(i,1) = exp_fit_to_slp_data.a;
    all_ab_values(i,2) = exp_fit_to_slp_data.b;
    
    %AllCyclones48(i,:) = slp_data;
end
%MeanCyclone48 = mean(AllCyclones48)'; % use the array of all data to find the mean cyclone
clear i exp_fit_to_slp_data xaxis indices

%% Find the mean and covarience of the a,b parameters
mu = mean(all_ab_values);
Sigma = cov(all_ab_values);

%% Scatter plot the a,b values with a coutour of their multivariate normal pdf 
figure
hold on
scatter(all_ab_values(:,1),all_ab_values(:,2))
x1 = -50:0.1:0; 
x2 = 0:0.001:0.4;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,size(x2,2),size(x1,2));
%mvncdf([0 0],[1 1],mu,Sigma);
contour(x1,x2,F,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999]);
xlabel('value of a'); ylabel('value of b');
clear x1 x2 X1 X2 F

%% Clear everything except the useful

clear NumCyclones event_index length 
