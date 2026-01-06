function [out] = colournoise(N, beta)

out = zeros(N,1);

for i = 2:N
    out(i) = beta*out(i-1)+(1-beta)*randn(1);
end

return