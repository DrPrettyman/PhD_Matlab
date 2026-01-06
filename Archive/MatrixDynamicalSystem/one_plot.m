



S = 0.01*[[0.4,0.1];[0.2,0.7]];

B = @(t)([[0.99+0.01*t/1000,0];[0,0.995]]); % diagonal - eval increasing 
%B = @(t)([[0.3,0.9];[-0.5,0.3]]); % cmplx evects
%B = @(t)((0.99+0.01*t/1000)*[[1,0];[0.5, 1]]); % defective

[W,V] = eig(B(0))

X = run_system_Bfun(2000,B,S);

windowSize = 200;
SlidingArg = Cov( X', windowSize );


figure
hold on
plot(X(1,:))
plot(X(2,:))
plot(SlidingArg)

hold off

figure 
plot(X(1,:),X(2,:))

