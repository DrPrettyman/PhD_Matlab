
%% load the structure
load('SLP_and_WINDSPEED.mat')

%% make an array of all the windspeed time series and the slp series

N = size(twoStruct,2);
time_axis = (1:size(twoStruct(1).slp,1))' - 1201;
windspeed = zeros(size(twoStruct(1).slp,1), N+1);
slpressure = zeros(size(twoStruct(1).slp,1), N+1);

windspeed(:,1) = time_axis;
slpressure(:,1) = time_axis;

for i = 1:size(twoStruct,2)
    windspeed(:,i+1) = twoStruct(i).windspeed; 
    slpressure(:,i+1) = twoStruct(i).slp; 
end

time_axis = (1:size(twoStruct(1).slp,1))' - 1201;

%%
plot(time_axis, windspeed(:,6))

%% Save for plotting with Grace etc.

save('slp_allcyclones.dat', 'slpressure', '-ascii')
save('ws_allcyclones.dat', 'windspeed', '-ascii')

%% do the same for the ACF(1) indicators, then find the mean and std

slp_ACF1 = zeros(size(twoStruct(1).time,1), size(twoStruct,2));
windspeed_ACF1 = zeros(size(slp_ACF1));
for cyclone_no = 1:size(twoStruct,2)
    slp_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_slp;
    windspeed_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_windspeed;
end
%
slp_ACF1_mean = mean(slp_ACF1,2);
ws_ACF1_mean = mean(windspeed_ACF1,2);
slp_ACF1_std = std(slp_ACF1')';
ws_ACF1_std = std(windspeed_ACF1')';

slp_ACF1plot = [time_axis, slp_ACF1_mean, slp_ACF1_std];
ws_ACF1plot = [time_axis, ws_ACF1_mean, ws_ACF1_std];

save('slp_ACF1plot.dat', 'slp_ACF1plot', '-ascii')
save('ws_ACF1plot.dat', 'ws_ACF1plot', '-ascii')

%% Do the same for the PS indicator 
slp_PS = zeros(size(twoStruct(1).time,1), size(twoStruct,2));
ws_PS = zeros(size(slp_PS));
eof1_PS = zeros(size(slp_PS));

for cyclone_no = 1:size(twoStruct,2)
    slp_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_slp;
    ws_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_windspeed;
    eof1_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_eof1;
end

slp_PS_mean = mean(slp_PS,2);
ws_PS_mean = mean(ws_PS,2);
eof1_PS_mean = mean(eof1_PS,2);

slp_PS_std = std(slp_PS')';
ws_PS_std = std(ws_PS')';
eof1_PS_std = std(eof1_PS')';

slp_PSplot = [time_axis, slp_PS_mean, slp_PS_std];
ws_PSplot = [time_axis, ws_PS_mean, slp_PS_std];
eof1_PSplot = [time_axis, eof1_PS_mean, slp_PS_std];

save('slp_PSplot.dat', 'slp_PSplot', '-ascii')
save('ws_PSplot.dat', 'ws_PSplot', '-ascii')
save('eof1_PSplot.dat', 'eof1_PSplot', '-ascii')


