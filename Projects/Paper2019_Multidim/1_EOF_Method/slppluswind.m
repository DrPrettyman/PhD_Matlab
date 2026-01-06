
%% Calculate the first EOF score of the slp and windspeed variables
%  for each cyclone
load('SLP_and_WINDSPEED.mat')

%%
X = [twoStruct(cyclone_no).slp, twoStruct(cyclone_no).windspeed];
for cyclone_no = 1:size(twoStruct,2)
    twoStruct(cyclone_no).eof1 = EOF1(X);
    twoStruct(cyclone_no).eof1NORM = EOF1(X,true);
    twoStruct(cyclone_no).eofALT = Alt_EOF(X, true);     
end
clear X   

%% Calcualte the ACF(1) and PS indicators 
% for the slp, windspeed and the combined first EOF score, for each cyclone
windowSize = 100;
for cyclone_no = 1:size(twoStruct,2)
    twoStruct(cyclone_no).ACF1_slp = ...
        ACF_sliding(twoStruct(cyclone_no).slp,1, windowSize);
    twoStruct(cyclone_no).PS_slp = ...
        PSE_sliding(twoStruct(cyclone_no).slp, windowSize);
    
    twoStruct(cyclone_no).ACF1_windspeed = ...
        ACF_sliding(twoStruct(cyclone_no).windspeed,1, windowSize);
    twoStruct(cyclone_no).PS_windspeed = ...
        PSE_sliding(twoStruct(cyclone_no).windspeed, windowSize);
    
    twoStruct(cyclone_no).ACF1_eof1 = ...
        ACF_sliding(twoStruct(cyclone_no).eof1,1, windowSize);
    twoStruct(cyclone_no).PS_eof1 = ...
        PSE_sliding(twoStruct(cyclone_no).eof1, windowSize);

    twoStruct(cyclone_no).ACF1_eof1NORM = ...
        ACF_sliding(twoStruct(cyclone_no).eof1NORM,1, windowSize);
    twoStruct(cyclone_no).PS_eof1NORM = ...
        PSE_sliding(twoStruct(cyclone_no).eof1NORM, windowSize);

    twoStruct(cyclone_no).ACF1_eofALT = ...
        ACF_sliding(twoStruct(cyclone_no).eofALT,1, windowSize);
    twoStruct(cyclone_no).PS_eofALT = ...
        PSE_sliding(twoStruct(cyclone_no).eofALT, windowSize);
end

%% Calculate the mean PS indicator 
%  for all "3" variables: slp, windspeed, eof score
slp_PS = zeros(size(twoStruct(1).time,1), size(twoStruct,2));
windspeed_PS = zeros(size(slp_PS));
eof1_PS = zeros(size(slp_PS));
eof1NORM_PS = zeros(size(slp_PS));
eofALT_PS = zeros(size(slp_PS));
for cyclone_no = 1:size(twoStruct,2)
    slp_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_slp;
    windspeed_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_windspeed;
    eof1_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_eof1;
    eof1NORM_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_eof1NORM;
    eofALT_PS(:, cyclone_no) = twoStruct(cyclone_no).PS_eofALT;
end
slp_PS_mean = mean(slp_PS,2);
windspeed_PS_mean = mean(windspeed_PS,2);
eof1_PS_mean = mean(eof1_PS,2);
eof1NORM_PS_mean = mean(eof1NORM_PS,2);
eofALT_PS_mean = mean(eofALT_PS,2);

%% Plot them together
x_axis = (1:size(eof1_PS_mean,1))'-1201;
figure
hold on
plot(x_axis, slp_PS_mean);
plot(x_axis, windspeed_PS_mean)
plot(x_axis, eof1_PS_mean)
plot(x_axis, eof1NORM_PS_mean)
plot(x_axis, eofALT_PS_mean)
hold off

%% Calculate the mean ACF(1) indicator 
% and the std for the EOF1 "variable".
%  for all "3" variables: slp, windspeed, eof score
slp_ACF1 = zeros(size(twoStruct(1).time,1), size(twoStruct,2));
windspeed_ACF1 = zeros(size(slp_ACF1));
eof1_ACF1 = zeros(size(slp_ACF1));
eof1NORM_ACF1 = zeros(size(slp_ACF1));
for cyclone_no = 1:size(twoStruct,2)
    slp_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_slp;
    windspeed_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_windspeed;
    eof1_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_eof1;
    eof1NORM_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_eof1NORM;
    eofALT_ACF1(:, cyclone_no) = twoStruct(cyclone_no).ACF1_eofALT;
end
%%
slp_ACF1_mean = mean(slp_ACF1,2);
windspeed_ACF1_mean = mean(windspeed_ACF1,2);
eof1_ACF1_mean = mean(eof1_ACF1,2);
eof1_ACF1_std = std(eof1_ACF1')';
eof1NORM_ACF1_mean = mean(eof1NORM_ACF1,2);
eof1NORM_ACF1_std = std(eof1NORM_ACF1')';
eofALT_ACF1_mean = mean(eofALT_ACF1,2);
eofALT_ACF1_std = std(eofALT_ACF1')';

%% Plot them together
x_axis = (1:size(eof1_PS_mean,1))'-1201;

% save data for grace plot
EOF1_wsslp_ACF1 = [x_axis, eof1_ACF1_mean, eof1_ACF1_std];
save('EOF1_wsslp_ACF1.dat', 'EOF1_wsslp_ACF1', '-ascii')

EOF1NORM_wsslp_ACF1 = [x_axis, eof1NORM_ACF1_mean, eof1NORM_ACF1_std];
save('EOF1NORM_wsslp_ACF1.dat', 'EOF1NORM_wsslp_ACF1', '-ascii')


% plot in matlab
figure
hold on
plot(x_axis, slp_ACF1_mean);
plot(x_axis, windspeed_ACF1_mean)
plot(x_axis, eof1_ACF1_mean)
plot(x_axis, eof1NORM_ACF1_mean)
plot(x_axis, eofALT_ACF1_mean)
hold off
