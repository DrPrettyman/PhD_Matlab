%% Init

N = 20;
noiseLen = 1000;

%% White noise

ACFval  = zeros(N,1);
ACF1val = zeros(N,1);
DFAval  = zeros(N,1);
PSval   = zeros(N,1);

for i = 1:N
    noise = randn(noiseLen,1);
    
    ACFval(i)  = ACF_scaling(noise);
    ACF1val(i) = ACF(noise,1);
    [a, alpha] = DFA_estimation(noise,2,false);
    DFAval(i)  = alpha;
    PSval(i)   = PSE_new(noise);
end

ACFwhite  = mean(ACFval);
ACF1white = mean(ACF1val);
DFAwhite  = mean(DFAval);
PSwhite   = mean(PSval);

%% Red noise

ACFval  = zeros(N,1);
ACF1val = zeros(N,1);
DFAval  = zeros(N,1);
PSval   = zeros(N,1);

for i = 1:N
    noise = randn(noiseLen,1);
    noise = cumsum(noise);
    
    ACFval(i)  = ACF_scaling(noise);
    ACF1val(i) = ACF(noise,1);
    [a, alpha] = DFA_estimation(noise,2,false);
    DFAval(i)  = alpha;
    PSval(i)   = PSE_new(noise);
end

ACFred  = mean(ACFval);
ACF1red = mean(ACF1val);
DFAred  = mean(DFAval);
PSred   = mean(PSval);

%% Red noise 63

alpha = 2;
coloredNoise = dsp.ColoredNoise(alpha, noiseLen, 1);

ACFval  = zeros(N,1);
ACF1val = zeros(N,1);
DFAval  = zeros(N,1);
PSval   = zeros(N,1);

for i = 1:N
    noise = coloredNoise();
    
    ACFval(i)  = ACF_scaling(noise);
    ACF1val(i) = ACF(noise,1);
    [a, alpha] = DFA_estimation(noise,2,false);
    DFAval(i)  = alpha;
    PSval(i)   = PSE_new(noise);
end

ACFred63  = mean(ACFval);
ACF1red63 = mean(ACF1val);
DFAred63  = mean(DFAval);
PSred63   = mean(PSval);

%% Create Table

T = table([DFAwhite;DFAred;DFAred63], [PSwhite;PSred;PSred63],...
    [ACFwhite;ACFred;ACFred63], [ACF1white;ACF1red;ACF1red63]);
T.Properties.VariableNames = {'DFA', 'PS','ACF', 'ACF1'};
T.Properties.RowNames = {'White','Red', 'red63'};
T
