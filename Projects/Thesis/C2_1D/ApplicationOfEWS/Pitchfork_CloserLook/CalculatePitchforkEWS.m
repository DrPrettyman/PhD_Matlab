%% CalculatePitchforkEWS
%
% Gives a closer look at the pitchfork bifurcation (see
% Typesoftipping.m) including the DFA EWS and a mean over 100 trials
% (with error) rather than a single EWS per indicator.

%% Initialise
clear all
% User defined variables
no_trials = 100; %the number of trials toi average over 
T = 1000; delta_t = 0.01; sample_f = 100; initial_z = 0; sigma = @(t)0.1;
N = 1001;
cp = @(t)@(z)(z^4+(3-t/200)*z^2);
ws = 100; % window size for indicators

% derived varaibles
TimeSeries = zeros(N,no_trials);
ps_ews     = zeros(N,no_trials);
acf1_ews   = zeros(N,no_trials);
dfa_ews    = zeros(N,no_trials);

%% Integrate the system
disp(['Integrating the system',num2str(no_trials),' times'])
for k = 1:no_trials  
    [t, z] = time_series_cp(T,delta_t,cp,initial_z,sigma);
    zp = z(1:sample_f:end);
    TimeSeries(:,k) = zp;
    disp([num2str(k),'/',num2str(no_trials)])
end
clear k t z zp

%% Calculate the EWS
disp(['Calculating the ',num2str(no_trials),' EWSs'])
for k = 1:no_trials  
    zp = TimeSeries(:,k);
    ps_ews(:,k)   = PSE_sliding(zp,ws);
    acf1_ews(:,k) = ACF_sliding(zp,1,ws);
    dfatmp = DFA_sliding(zp,2,ws);
    dfa_ews(:,k)  = [zeros(ws-1,1);dfatmp];
    disp([num2str(k),'/',num2str(no_trials)])
end
clear k dfatmp zp

%% Calculate means 
ps_mean   = mean(ps_ews,2);
acf1_mean = mean(acf1_ews,2);
dfa_mean  = mean(dfa_ews,2);

ps_std   = std(ps_ews,0,2);
acf1_std = std(acf1_ews,0,2);
dfa_std  = std(dfa_ews,0,2);

%% Structure for indicators
% it may be useful for plotting purposes to have the indicators saved
% also in a structure like this

IndicatorStruct = struct;

IndicatorStruct(1).indicatorName = 'ACF1';
IndicatorStruct(2).indicatorName = 'PS';
IndicatorStruct(3).indicatorName = 'DFA';

IndicatorStruct(1).mean = acf1_mean;
IndicatorStruct(2).mean = ps_mean;
IndicatorStruct(3).mean = dfa_mean;

IndicatorStruct(1).std = acf1_std;
IndicatorStruct(2).std = ps_std;
IndicatorStruct(3).std = dfa_std;
