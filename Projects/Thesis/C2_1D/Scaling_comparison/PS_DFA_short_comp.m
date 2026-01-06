
%%
N = 10^4;
numTrials = 200;
exponentsShort = linspace(0,1,numTrials)';

dfaValuesShort = zeros(numTrials,1);
pseValuesShort = zeros(numTrials,1);

for k = 1:numTrials
    exp = exponentsShort(k)
    
    
    noise = zeros(N,1);
    for i = 2:N
        noise(i) = exp*noise(i-1)+0.2*randn();
    end
    noise = noise-mean(noise);
    sample = noise./var(noise);
    
    [points, alpha] = DFA_estimation(sample,3,false);
    
    dfaValuesShort(k) = alpha;
    pseValuesShort(k) = PSE_new(sample,false);
end
clear points alpha exp i k noise 

save('ps_dfa_compShort_data.mat','exponentsShort','dfaValuesShort','pseValuesShort')

%%
% scatter
load('ps_dfa_compShort_data.mat')

figure
hold on
scatter(pseValuesShort,dfaValuesShort)
plot([0,2] ,[0.5,1.5] ,'LineWidth', 3.5, 'Color', 'r')
%xlim([0,2.1])
%ylim([0.4,1.6])
xlabel('PS exponent')
ylabel('DFA(3) exponent')