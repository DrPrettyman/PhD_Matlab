function f = prettyman_4(T_0,T_1,T_mid,epsilon,x_0,a,c,b_0,b_1,n)
b=linspace(b_0, b_1, n);
options=odeset('AbsTol',10^(-9));
hold on
for i=1:n
     tout2=[];
     xout2=[];
     local_maxima=[];
     [tout,xout]=ode45(@(T_0,x_0)f_rossler(x_0,a,b(i),c),[T_0 T_1],x_0,options);
    for  j = 1:size(tout)
        if tout(j)>=T_mid
            tout2=[tout2;tout(j)];
            xout2=[xout2;xout(j,:)];
        end
    end
    x=[0;xout2(:,1);0];
    for m=2:(size(x)-1)
       if x(m)>(x(m+1)+x(m-1))/2 && abs(x(m+1)-x(m-1))<epsilon
        local_maxima=[local_maxima;x(m)];
       end
        plot(b(i)*ones(size(local_maxima)),local_maxima,'m.','markersize',5)
    end
   pause(0.1)
end

function f = f_rossler(x,a,b,c)
  %x should be a 3 by 1 vector
  f=zeros(size(x));
  f(1)=-x(2)-x(3);
  f(2)=x(1)+a*x(2);
  f(3)=b+x(3)*(x(1)-c);

