function mu = reconstruct_mu_func(beta)
%RECONSTRUCT_MU_FUNC 

if beta < 0.01
    mu = 0;
    return
end
if beta > 1.98
    mu = 1;
    return
end
        
b = 2*(cos(0.2*pi)-(10^beta)*cos(0.02*pi))/(1-(10^beta));
mu = (b/2)-sqrt(b^2-4)/2;
end

