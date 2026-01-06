function [t, z] = peturb_time_series(T, delta_t, potential, initial_z, sigma, F)

% gives a stochastic time series
%
% Inputs:
%       T:          [Positive] the 'end time' 
%       delta_t:    [Positive] size of time-steps
%       potential:  [Function] potential function ('U(z)')
%       initial_z:  [Real]     starting value for the series
%       sigma:      [Function] noise level, as a function of t
%       F:          [Function] Forcing term, as a function of t 
%
% Outputs:
%       t = 1:delta_t:T    [Array] time values
%       z                  [Array] time series 
%
%   Plotting z over t will show the behaviour of the series.
%

% define epsilon << 1 to calculate a derivative:
epsilon = 10^(-5);

% create the output array t which contains the time values from 1 to T
t =  (0:delta_t:T)';

% create the array z to store the time series. Set the first value to the
% input initial_z
n = size(t,1);
z = zeros(n,1);
z(1) = initial_z;

% populate the array z with the time series by looping over time
for i = 1:(n-1)
    % Calculate the derivative of the potential at z(t(i))
    dirivative_of_potential = (potential(z(i)+epsilon) ...
        - potential(z(i)-epsilon)) / (2*epsilon);
    
    % Advance the value of z forward in time according to its gradient
    z(i+1) = z(i) - delta_t*dirivative_of_potential + ...
        sigma(t(i))*randn;
end

%t = (0:T)';
%z = z( floor(t/delta_t)+1 );

return