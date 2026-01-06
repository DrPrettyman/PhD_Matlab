function out = twotoone2(t)

% In the range t = (0:10000)

% for z>=0 out = @(t)@(z) z.^4 - z.^2;
% for z<0  out = @(t)@(z) z.^4 - (1-2/10000*t)*z.^2;

T = 1000;

X = (-1.5:0.01:1.5)';
x = [-1.5,-1,0,0.5,1,1.5];

s = 10*t/T;

a = s/2 - 0.5;
b = s/3 - 1;
y = [a,b, 0, -0.5,-1,-0.5];
    
p = polyfit(x,y,4);

out = @(z) polyval(p,z);

return

