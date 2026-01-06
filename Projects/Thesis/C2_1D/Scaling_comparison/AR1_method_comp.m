N = 1000;
exponents = linspace(0,1,20);
numColours = size(exponents,2);

numTrials = 20;


means = zeros(numColours,4);
errors = zeros(numColours,4);

for k = 1:numColours
    exponent = exponents(k)
    
    acf = zeros(numTrials,1);
    acf1 = zeros(numTrials,1);
    dfa = zeros(numTrials,1);
    pse = zeros(numTrials,1);
    
    
    
    
    for trial = 1:numTrials
        
        noise = zeros(N,1);
        for i = 2:N
            noise(i) = exponent*noise(i-1)+0.1*randn();
        end
        noise = noise-mean(noise);
        noise = noise./var(noise);
        
        trial
        
        x = noise;
        
        pse(trial) = PSE_new(x,false);
        [points, alpha] = DFA_estimation(x,2,false);
        dfa(trial) = alpha;
        acf(trial) = ACF_scaling(x,false);
        acf1(trial) = ACF(x,1);
    end
    
    means(k,1) = mean(acf);
    errors(k,1) = std(acf);
    
    means(k,2) = mean(acf1);
    errors(k,2) = std(acf1);
    
    means(k,3) = mean(dfa);
    errors(k,3) = std(dfa);
    
    means(k,4) = mean(pse);
    errors(k,4) = std(pse);
    
    clear acf acf1 dfa pse
end


