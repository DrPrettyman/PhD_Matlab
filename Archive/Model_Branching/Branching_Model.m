%% Script
%  uses "time_series_cp.m" with specifeied parameters to create
%  a branching "pitchfork bifurcation" model.


%       T:          [Positive] the 'end time' 
%       delta_t:    [Positive] size of time-steps
%       cp:         [Function] cp(t) gives the 
%                   potential function U(z). eg 
%                   cp = @(t)@(z)z^4-(1-0.001*t)*z^2
%       initial_z:  [Real]     starting value for the series
%       sigma:      [Function] noise level, as a function of t
%       F:          [Function] Forcing term, as a function of t 

T = 1000;
delta_t = 0.05;
cp = @(t)@(z)z^4+(3.0-t/200.0)*z^2;
initial_z = 0;
sigma = @(t)0.1;
F = @(t)0;

[t, z] = time_series_cp(T, delta_t, cp, initial_z, sigma);
