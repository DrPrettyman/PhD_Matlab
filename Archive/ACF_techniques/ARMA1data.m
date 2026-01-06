% Create some data

function x = ARMA1data(a,c,s,length)

if isnumeric(a)
    a = @(i)a;
end
if isnumeric(c)
    c = @(i)c;
end
if isnumeric(s)
    s = @(i)s;
end

% data x is produced by x_{n+1} = a*x_{n} + c + s*epsilon

x = zeros(length,1);
x(1) = c(1);

for i = 2:length
    x(i) = a(i)*x(i-1) + c(i) + s(i)*randn(1,1);
end

end