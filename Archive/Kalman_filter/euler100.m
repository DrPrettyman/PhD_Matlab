function [ z ] = euler100( z_0, lambda, N, Del_t)

z = z_0;


for i = 1:N
    z = z - (Del_t/N)*(lambda(1) + 2*lambda(2)*z +...
        3*lambda(3)*z^2 + 4*lambda(4)*z^3 );   
end


end

