
rednoise = cumsum(randn(10000,1));
W = @(t)(rednoise(1-t));
p_n = @(t)(1016 + 1.6*sin((2*pi*(t))/12))+0.2*W(t); %ambiant pressure

time = (-2400:1:-1)';
presure = zeros(size(time));
for i = 1:size(time,1)
    presure(i) = p_n(time(i));
end


figure
plot(time, presure)
var(presure)