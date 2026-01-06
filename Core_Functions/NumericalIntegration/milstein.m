function [t,Y] = milstein(f, sigma, x0, tBounds, delta_t, StopRadius)
%% Function: [t,Y] = milstein(f, sigma, x0, tBounds, delta_t, StopRadius)
%
% Integrates SDEs of the form
%          dX = f(X,t)dt + sigma*dW
% where W is a Brownian motion process. 
%
% Returns:
% t     ---   series of times where t(i)-t(i-1) = delta_t. size [N,1]
% Y     ---   Milstein approximation to X. size [m,N]
%
% Inputs:
% f     ---   function of X and t. 
%             takes a [m,1]-array (x) and a scalar (t) 
%             and returns a [m,1]-array.
% sigma ---   standard deviation of the noise term.
%             either size [m,1] or [m,m]
%             or a function of a single scalar variable (time) which
%             returns either size [m,1] or [m,m] array.
% x0    ---   initial condition for X. size [m,1]
% tBounds -   lower and upper bounds of integration. 2-element array.
% delta_t -   time step for integration. scalar.
%
% Optional input: StopRadius --- Integration stops when Y exits a
%                                radius around the origin. scalar.

if nargin < 6; StopRadius = Inf; end
if numel(tBounds)~=2; error('tBounds must have two elements'); end
if size(x0,2)~=1; error('x0 must be size [m,1] array'); end
if size(f(x0,tBounds(1)))~=size(x0); error('size mismatch: f and x0'); end

N  = floor((tBounds(2) - tBounds(1))/delta_t);
dt = (tBounds(2) - tBounds(1)) / N;
t  = linspace(tBounds(1), tBounds(2), N)'; % From t0->t1 with N points
m  = size(x0,1);   % size of the system
Y  = zeros(m, N);  % mxN Matrix of zeros
Y(:,1) = x0;       % set inital condition
R2 = StopRadius^2; % Square of the radius outside of which we do not go
tp = N;            % the "termination point"

if isnumeric(sigma) % if sigma is numeric, use Euler-Maruyama method
    if all(size(sigma) == [m,1]); S = diag(sigma);
    elseif all(size(sigma) == [m,m]); S = sigma; 
    else
        error('sigma must be size [m,1] or [m,m]');  
    end
    for i = 2:numel(t)
        dW = randn(m,1);
        Y(:,i) = Y(:,i-1) + f(Y(:,i-1), t(i-1))*dt + sqrt(dt)*S*dW;
        if dot(Y(:,i),Y(:,i)) > R2; tp = i; break; end
    end
else % else we assume simga is a function of time and we use Milstein
    if all(size(sigma(t(1))) == [m,1]); S = @(t)(diag(sigma(t)));
    elseif all(size(sigma(t(1))) == [m,m]); S = sigma; 
    else
        error('sigma(t) must return a size [m,1] or [m,m] array');  
    end
    for i = 2:numel(t)
        dW = randn(m,1); s0 = S(t(i-1));
        A1 = dt*f(Y(:,i-1), t(i-1)) + sqrt(dt)*s0*dW;
        Sdash = diag(1./A1)*(S(t(i))-s0);
        Y(:,i) = Y(:,i-1)+A1+0.5*dt*s0*Sdash*((s0*dW).^2-ones(m,1));
        if dot(Y(:,i),Y(:,i)) > R2; tp = i; break; end
    end
end
Y = Y(:,1:tp);
t = t(1:tp);
end