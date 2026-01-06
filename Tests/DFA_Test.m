
N = 10^4;
X = cumsum(randn(N,1));

% [F, plotableF, plotableB] = DFA(X, 30, 2);
[DFApoints, alpha] = DFA_estimation(X,  3, false, true);

