A = 10*rand(2);
A(2,1)=A(1,2);

[V,L] = eig(A);

%A*V == V*L



if find(L==max(max(L)))==1
    maxValue = L(1);
    maxVector = V(:,1);
else
    maxValue = L(4);
    maxVector = V(:,2);
end

f = @(a,b,c,sign)0.5*(a+c + sign*sqrt((a-c)^2+4*b^2));

f(A(1,1),A(1,2),A(2,2),1)-maxValue


maxVector = maxVector/maxVector(2);

g = @(a,b,c,sign)(a-c + sign*sqrt((a-c)^2+4*b^2))/(2*b);

[g(A(1,1),A(1,2),A(2,2),1);1] - maxVector