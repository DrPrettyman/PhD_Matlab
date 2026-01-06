function [tout, xout] = VanDerPol_fun(T_0, T_1, x_0, tau, alpha, beta, gamma, P1, phiP1)
%% VANDERPOL_FUN Integrate a forced Van der Pol oscillator
%
% Integrates a periodically forced Van der Pol oscillator:
%     dx/dt = -(1/tau)*(F(t) + beta + y)
%     dy/dt = (alpha/tau)*(y - y^3/3 + x)
% where F(t) = gamma*sin(2*pi*t/P1 + phiP1)
%
% Syntax:
%     [tout, xout] = VanDerPol_fun(T_0, T_1, x_0, tau, alpha, beta, gamma, P1, phiP1)
%
% Inputs:
%     T_0   - Start time
%     T_1   - End time
%     x_0   - Initial condition [x; y], size [2 x 1]
%     tau   - Time scale parameter
%     alpha - Nonlinearity parameter
%     beta  - Offset parameter
%     gamma - Forcing amplitude
%     P1    - Forcing period
%     phiP1 - Forcing phase
%
% Outputs:
%     tout - Time vector [N x 1]
%     xout - Solution [N x 2], columns are [x, y]
%
% See also: VanDerPol, hopf_fun, homoclinic_fun

    options = odeset('AbsTol', 1e-5);
    [tout, xout] = ode45(@(t,x) f_system(t, x, tau, alpha, beta, gamma, P1, phiP1), ...
        (T_0:0.01:T_1), x_0, options);
end

function f = f_system(t, x, tau, alpha, beta, gamma, P1, phiP1)
    f = zeros(size(x));
    Forcing = gamma * sin(2*pi/P1*t + phiP1);
    f(1) = -(1/tau) * (Forcing + beta + x(2));
    f(2) = (alpha/tau) * (x(2) - x(2)^3/3 + x(1));
end



    
