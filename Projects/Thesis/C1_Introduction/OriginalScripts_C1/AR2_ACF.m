N=10000;
phi = [0.8, -0.2];


M = 100000;
acf = zeros(M,1);
for j = 1:M
    noise = randn(N,1);
    P = zeros(N,1);
    for i = 3:N
        P(i) = phi(1)*P(i-1)+phi(2)*P(i-2)+noise(i);
    end
    acf(j) = ACF(P(end-floor(N/3):end),1);
end

histogram(acf,20)

%%
mean(acf)