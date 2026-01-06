%% T
% This script is performed after the script "slppluswind.m". 
% the output from the previous script is analysed in the 30-hour
% window befor the cyclone using Mann-Kendall coefficient

range = 30;

S = struct;

S(1).indicator = 'ACF';
S(2).indicator = 'PS';

%%
S(1).windspeed = mannkendall(...
    windspeed_ACF1_mean(1201 - range: 1201));
S(2).windspeed = mannkendall(...
    windspeed_PS_mean(1201 - range: 1201));


S(1).slp = mannkendall(...
    slp_ACF1_mean(1201 - range: 1201));
S(2).slp = mannkendall(...
    slp_PS_mean(1201 - range: 1201));

S(1).eof = mannkendall(...
    eof1_ACF1_mean(1201 - range: 1201));
S(2).eof = mannkendall(...
    eof1_PS_mean(1201 - range: 1201));