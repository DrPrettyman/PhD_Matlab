function x = simple_bifurcation(len, coef, x1)

x = zeros(len,1);

x(1) = x1;

for t = 2:len
    x(t) = coef(t)*x(t-1)*(1-x(t-1));
end

return

