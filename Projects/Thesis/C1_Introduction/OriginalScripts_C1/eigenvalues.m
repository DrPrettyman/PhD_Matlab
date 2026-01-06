

N = 10^5;

Mu = linspace(-1,0,N)';

lambda_p = zeros(N,1);
lambda_n = zeros(N,1);

eigfun = @(mu,c)(...
    (mu+1/2+c*sqrt(mu))...
    );

for i = 1:N
    lambda_p(i) = eigfun(Mu(i), 1);
    lambda_n(i) = eigfun(Mu(i),-1);
end

%%
figure
hold on
plot(lambda_p)
%plot(lambda_n)