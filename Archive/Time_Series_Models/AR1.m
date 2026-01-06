function data = AR1(len, kappa)

data = zeros(len,1);

dt = 1;
c = exp(-kappa*dt);

for i = 2:len
    data(i) = c*data(i-1) + randn(1,1);
end

return

