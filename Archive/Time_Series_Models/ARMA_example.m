length = 100;
p = 2;
q = 2;

c = 0.5;
%phi = 0.8 .* rand(1,p);
phi = [0.8, 0.1];
white_noise = 0.1 .* randn(1,length);
mu = 0;
%theta = rand(1,q);
theta = [-0.8,0.2];

% An MA(q) model

Y = zeros(1,length);

for t = (q+1):length
    Y(t) = mu + white_noise(t) + sum( theta .* white_noise((t-q):(t-1)) );
end

figure 
plot(Y)
title('An MA(2) process')

pause(2)



% An AR(p) process

X = zeros(1,length);

for t = (p+1):length
    X(t) = c + white_noise(t) + sum( phi .* X((t-p):(t-1)) );
end

figure 
plot(X)
title('An AR(2) process')



pause(2)



% An ARMA model

Z = zeros(1,length);
Z(1:max(p,q)) = 0.2 .* rand(1,max(p,q));

for t = (max(p,q)+1):length
    Z(t) = c + white_noise(t) + sum( theta .* white_noise((t-q):(t-1)) ) + sum( phi .* Z((t-p):(t-1)) );
end

figure 
plot(Z)
title('An ARMA(p,q) process')
