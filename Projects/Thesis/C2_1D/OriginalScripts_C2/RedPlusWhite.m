function X = RedPlusWhite(T, mu)

N = size(T,1);

Red = cumsum(randn(N,1));
White = randn(N,1);
White = White.*mu(T);

X = Red+White;

X = X/std(X);

