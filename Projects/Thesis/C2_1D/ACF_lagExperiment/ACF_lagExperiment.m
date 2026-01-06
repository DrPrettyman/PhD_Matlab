% create AR1 process

N = 100000;
mu = 0.7;

t = linspace(0,1,N)';
a1 = zeros(N,1);

for i = 2:N
    a1(i) = mu*a1(i-1)+randn();
end

a2 = a1(1:3:end);
