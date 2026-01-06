function [t,Y] = EM_method(f, sigma, x0, tBounds, delta_t)
%% EM_METHOD Euler-Maruyama method for SDE integration
%
% Integrates SDEs of the form:
%     dX = f(X,t)dt + sigma*dW
% where W is a Brownian motion process.
%
% Syntax:
%     [t, Y] = EM_method(f, sigma, x0, tBounds, delta_t)
%
% Inputs:
%     f        - Drift function, takes (X, t) and returns array same size as X
%     sigma    - Noise amplitude, same size as x0 (element-wise multiplication)
%     x0       - Initial condition, column vector [m x 1]
%     tBounds  - Time interval [t_start, t_end]
%     delta_t  - Time step for integration
%
% Outputs:
%     t - Time vector [1 x N]
%     Y - Solution matrix [m x N], each column is state at time t(i)
%
% See also: milstein, milstein_potential

    N  = floor((tBounds(2) - tBounds(1))/delta_t);
    dt = (tBounds(2) - tBounds(1)) / N;
    t  = linspace(tBounds(1), tBounds(2), N);
    Y  = zeros(size(x0,1), N);

    Y(:,1) = x0;
    for i = 2:numel(t)
        dW = sqrt(dt) * randn(size(x0));
        Y(:,i) = Y(:,i-1) + f(Y(:,i-1), t(i-1))*dt + sigma.*dW;
    end
end