function local_maxima = prettyman_3(epsilon,xout2)
x=[0;xout2(:,1);0];
local_maxima=[];
for m=2:(size(x)-1)
    if x(m)>(x(m+1)+x(m-1))/2 && abs(x(m+1)-x(m-1))<epsilon
        local_maxima=[local_maxima;x(m)];
    end
end