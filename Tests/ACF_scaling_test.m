

% N = 10000;
% alpha = 0.5;
% 
% x = zeros(N,1);
% for i = 2:N
%     x(i) = alpha*x(i-1)+randn();
% end
% 
% x = x - mean(x);
% x = x./var(x);
% 
% %%
% x = red08';
% plot(x)

%%
noise = dsp.ColoredNoise(0.8, N, 1);
x = noise();
    
pse = PSE_new(x,1)
[points, alpha] = DFA_estimation(x,2,false);
dfa = alpha


%%
lags = [1:100]';
nlags = size(lags,1);
coefs = zeros(nlags,1);
for k = 1:nlags
    coefs(k) = ACF(x, lags(k));
    if coefs(k)<0.01
        coefs(k)=0.01;
    end
end

%figure 
%loglog(lags, coefs)

loglags = log10(lags);
logcoefs = log10(coefs);

window = lags>=10;
%window = 1:find(coefs==0.1,1);
%window = 1:10;

pfit = polyfit(loglags(window), logcoefs(window), 1);
v = polyval(pfit, logcoefs(window));
acf = -pfit(1)


figure 
hold on
plot(loglags, logcoefs)
v = polyval(pfit,[1,2]);
plot([1,2],v,'LineWidth', 3.5, 'Color', 'r')


