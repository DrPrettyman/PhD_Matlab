% Either load('exp_fit_abvalues.mat') or run ab_values.m

N = 400; 

xaxis = -N:0;
ab = mvnrnd(mu, Sigma, 1);
BaseCurve = ab(1)*exp(ab(2)*xaxis);
% figure 
% plot(xaxis, BaseCurve)
% xlabel('Time'); ylabel('exponential curve');

alpha = 0.96;
sigma = 0.2;
noise = zeros(1,3*N);
noise(1)=1;
for i = 1:(3*N-1)
    noise(i+1) = alpha*noise(i)+sigma*randn(1,1);  
end

CurveNoise = BaseCurve + noise(end-N:end);
figure 
plot(xaxis, CurveNoise)
xlabel('Time'); ylabel('curve with noise');

WindowSize = 120;
slidingACF = ACF_sliding(CurveNoise', 1, WindowSize);
figure
plot(xaxis(WindowSize+1:end), slidingACF(WindowSize+1:end))
xlabel('Time'); ylabel('ACF - 48 point window');
