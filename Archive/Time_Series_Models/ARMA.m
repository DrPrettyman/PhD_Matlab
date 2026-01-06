function z = ARMA(Phi, Theta, N)

% An ARMA process of the form
% z_t = Phi_1 z_{t-1}+ Phi_2 z_{t-1} +...+ Theta_0 a_t + Theta_1 a_{t-1} +
% ...

p = size(Phi,1);
q = size(Theta,1)-1;
s = max(p,q);

a = randn(N,1);
z = zeros(N,1);
z(1:s) = ones(1:s);

for t = s+1:size(z,1)
    z(t) = dot(  Phi , flip(z(t-p:t-1) ) ) + ...
        dot( Theta , a(t-q:t) );
end

return