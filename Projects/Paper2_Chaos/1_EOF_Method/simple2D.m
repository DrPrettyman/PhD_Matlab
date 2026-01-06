

N = 1000;
P = 2;

X = zeros(N,P);

B = diag([0.99,0.90]);
S = 0.01*[[ 1 2 ];[ 2 1 ]];

lambda = @(t)(0.91+0.1/N*t);

x0 = 2*ones(P,1);

for i = 1:N
    B = diag([lambda(i),0.90]);
    
    x1 = B*x0 + S*randn(P,1);
    X(i,:) = x1';
    x0 = x1;
    clear x1
end

%%
figure
plot(X(:,1), X(:,2))

[T,W] = EOF1(X);
figure
plot(T)
atan(W(2)/W(1))



