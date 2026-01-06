function X = run_system(N,B,S,noise_type)

P = size(S,1);
if size(B,1)==1 || size(B,2)==1
    B = diag(B);
end

if nargin<5
    eta = randn(P,N);
    % eta = cumsum(eta,2);
    % eta = eta./(var(eta,0,2)*ones(1,N));
end

figure
plot(eta(2,:))

X = zeros(P,N);
X(:,1) = [2;2];
for n = 2:N
    X(:,n) = B*X(:,n-1)+S*eta(:,n);
end

figure
hold on
plot(X(1,:))
plot(X(2,:))
hold off
return