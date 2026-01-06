function data = quadratic_nth_state(x0, n)

a = (1:0.001:4)';
x = zeros(size(a));

for i = 1:size(a,1)
    y=x0;

    for t = 1:n
        y = a(i)*y*(1-y);
    end
    
    x(i) = y;
    
    clear y
end

data = cat(2, a, x);

return