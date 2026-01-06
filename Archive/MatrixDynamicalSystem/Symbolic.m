syms s11 s12 s21 s22 real
S = [[s11,s12];[s21,s22]]

syms b11 b12 b21 b22 real
B = [[b11,b12];[b21,b22]];

syms d11 d12 d21 d22  real
D = [[d11,d12];[d21,d22]]

%B = [[0,0.9];[-0.9,0]]

system = S*S' + B*D*B' - D

solution = solve([system(1),system(2),system(3),system(4)],[d11 d12 d21 d22]);

D = [[solution.d11, solution.d12];[solution.d21, solution.d22]];

D_bdiag = subs(D, [b12 b21], [0 0]);

D_non_bdiag = subs(D, [b11 b22], [0 0]);