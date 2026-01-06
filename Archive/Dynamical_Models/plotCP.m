function output = plotCP(cp, T)

figure
hold on

z = (-1.5:0.01:1.5)';
for t = 0:T/10:T
    f = cp(t);
    P = zeros(size(z));
    
    for i = 1:size(z,1)
        P(i) = f(z(i));
    end
    
    plot(z,P);
    clear P
end

return