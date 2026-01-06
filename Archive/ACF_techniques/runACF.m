% Create some data and perform sliding ACF

a = @(i)0.5*(1+exp(0.05*(i-500))).^(-1);

x = ARMA1data(a,0.8,0.05,1000);

slidingACF = ACF_sliding(x, 1, 50);

figure
hold on
plot(x)
plot(slidingACF)
