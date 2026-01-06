function X = run_system_Bfun(N,B,S,noise_type)

P = size(S,1);


if nargin<5
    eta = randn(P,N);
    % eta = cumsum(eta,2);
    % eta = eta./(var(eta,0,2)*ones(1,N));
end



X = zeros(P,N);
X(:,1) = [1;1];
for n = 2:N
    X(:,n) = B(n)*X(:,n-1)+S*eta(:,n);
end


return