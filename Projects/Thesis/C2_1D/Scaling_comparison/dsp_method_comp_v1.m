

numTrials = 20;
dspCompStruct = struct;

dspCompStruct(1).test = 'ACF';
dspCompStruct(2).test = 'ACF(1)';
dspCompStruct(3).test = 'DFA';
dspCompStruct(4).test = 'PS';

acf = zeros(numTrials,1);
acf1 = zeros(numTrials,1);
dfa = zeros(numTrials,1);
pse = zeros(numTrials,1);

noise = dsp.ColoredNoise(0.8, N, 1);

for trial = 1:numTrials
    
    x = noise();
    
    pse(trial) = PSE_new(x,false);
    [points, alpha] = DFA_estimation(x,2,false);
    dfa(trial) = alpha;
    acf(trial) = ACF_scaling(x,false);
    acf1(trial) = ACF(x,1);
end

dspCompStruct(1).value = acf;
dspCompStruct(1).mean = mean(acf);
dspCompStruct(1).std = std(acf);

dspCompStruct(2).value = acf1;
dspCompStruct(2).mean = mean(acf1);
dspCompStruct(2).std = std(acf1);

dspCompStruct(3).value = dfa;
dspCompStruct(3).mean = mean(dfa);
dspCompStruct(3).std = std(dfa);

dspCompStruct(4).value = pse;
dspCompStruct(4).mean = mean(pse);
dspCompStruct(4).std = std(pse);

clear acf acf1 dfa pse
