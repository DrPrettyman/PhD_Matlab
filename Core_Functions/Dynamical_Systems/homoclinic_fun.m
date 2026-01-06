function [tout, xout] = homoclinic_fun(T_0, T_1, x_0, mu, sigma)
%% HOMOCLINIC_FUN Integrate a saddle-node on invariant circle (SNIC) system
%
% Integrates the 2D system exhibiting homoclinic bifurcation:
%     dx/dt = y + noise
%     dy/dt = mu(t) - x^2 + noise
%
% Syntax:
%     [tout, xout] = homoclinic_fun(T_0, T_1, x_0, mu, sigma)
%
% Inputs:
%     T_0   - Start time
%     T_1   - End time
%     x_0   - Initial condition [x; y], size [2 x 1]
%     mu    - Bifurcation parameter, function handle mu(t)
%     sigma - Standard deviation of additive white noise
%
% Outputs:
%     tout - Time vector [N x 1]
%     xout - Solution [N x 2], columns are [x, y]
%
% See also: homoclinic, hopf_fun, VanDerPol_fun

    options = odeset('AbsTol', 1e-9);
    [tout, xout] = ode45(@(t,x) f_system(t, x, mu, sigma), ...
        (T_0:0.01:T_1), x_0, options);
end

function f = f_system(t, x, mu, sigma)
    f = zeros(size(x));
    f(1) = x(2) + randn(1,1)*sigma;
    f(2) = mu(t) - x(1)^2 + randn(1,1)*sigma;
end



    
