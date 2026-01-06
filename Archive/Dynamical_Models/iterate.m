function y = iterate(f, x, n)

y=x;

for t = 1:n
    y = f(y);
end

return