
%%
N = 5000;
numTrials = 200;
exponents = linspace(0,2,numTrials)';

dfaValues = zeros(numTrials,1);
pseValues = zeros(numTrials,1);

for k = 1:numTrials
    exp = exponents(k)
    noise = dsp.ColoredNoise(exp, N, 1);
    sample = noise();
    
    [points, alpha] = DFA_estimation(sample,3,false);
    
    dfaValues(k) = alpha;
    pseValues(k) = PSE_new(sample,false);
end

save('ps_dfa_comp_data.mat','exponents','dfaValues','pseValues')

%%
% scatter
load('ps_dfa_comp_data.mat')

figure
hold on
scatter(pseValues,dfaValues)
plot([0,2] ,[0.5,1.5] ,'LineWidth', 3.5, 'Color', 'r')
%xlim([0,2.1])
%ylim([0.4,1.6])
xlabel('PS exponent')
ylabel('DFA(3) exponent')