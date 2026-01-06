function [tout, xout] = hopf_fun(T_0, T_1, x_0, mu, sigma)
%% HOPF_FUN Integrate the normal form of a supercritical Hopf bifurcation
%
% Integrates the Hopf normal form system in polar-like coordinates:
%     dr/dt = mu(t)*r - r^3 + noise
%     dtheta/dt = 1 + r^2 + noise
%
% Syntax:
%     [tout, xout] = hopf_fun(T_0, T_1, x_0, mu, sigma)
%
% Inputs:
%     T_0   - Start time
%     T_1   - End time
%     x_0   - Initial condition [r; theta], size [2 x 1]
%     mu    - Bifurcation parameter, function handle mu(t)
%     sigma - Standard deviation of additive white noise
%
% Outputs:
%     tout - Time vector [N x 1]
%     xout - Solution [N x 2], columns are [r, theta]
%
% See also: hopf, VanDerPol_fun, homoclinic_fun

    options = odeset('AbsTol', 1e-5);
    [tout, xout] = ode45(@(t,x) f_system(t, x, mu, sigma), ...
        (T_0:0.01:T_1), x_0, options);
end

function f = f_system(t, x, mu, sigma)
    f = zeros(size(x));
    f(1) = mu(t)*x(1) - x(1)^3 + randn(1,1)*sigma;
    f(2) = 1 + x(1)^2 + randn(1,1)*sigma;
end



    
