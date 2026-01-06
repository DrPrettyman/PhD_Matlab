function out = twotoone1(t)

% In the range t = (0:10000)

% for z>=0 out = @(t)@(z) z.^4 - z.^2;
% for z<0  out = @(t)@(z) z.^4 - (1-2/10000*t)*z.^2;

T = 10000;

out = @(z) combine(z,t,T);

return


function out = combine(z,t,T)

if z >= 0
    out = z.^4-6*z.^2;
else
    out = z.^4 - 6*(1-3/T*t)*z.^2;
end

return