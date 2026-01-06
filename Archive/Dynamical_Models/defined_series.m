% creates a times series and saves it.
% Time series goes from t=1 to t=20 000 and takes time steps of size 0.1.

function [t, z] = defined_series(system_name)

if strcmp(system_name, 'increasing_noise')
    % Uses the function time_series.m with parameters defineds here:
    % T = 20000, delta_t = 0.1, potential = @(z) z^4 - 2*z^2,  initial_z = 0, sigma = @(t) 2*(0.00007*t), F = @(t) 0
    
    [t, z] = time_series(20000, 0.1, @(z) z^4 - 2*z^2, 0, @(t) 2*(0.00007*t), @(t) 0);
    save('data/increasing_noise_series.mat', 't', 'z');
    
elseif strcmp(system_name, 'decreasing_noise')
    % Uses the function time_series.m with parameters defineds here:
    % T = 20000, delta_t = 0.1, potential = @(z) z^4 - 2*z^2,  initial_z = 0, sigma = @(t) 2*(-0.00007*t + 1.50045), F = @(t) 0
    
    [t, z] = time_series(20000, 0.1, @(z) z^4 - 2*z^2, 0, @(t) 2*(-0.00007*t + 1.50045), @(t) 0);
    save('data/increasing_noise_series.mat', 't', 'z');
    
elseif strcmp(system_name,'deterministic_forcing')
    % Uses the function time_series.m with parameters defineds here:
    % T = 20000, delta_t = 0.1, initial_z = 0, sigma = @(t) 2, F = @(t) (5E-9)*(t^2), potential = @(z) z^4 - 2*z^2
    
    [t, z] = time_series(20000, 0.1, @(z) z^4 - 2*z^2, 0, @(t) 2, @(t) (5E-9)*(t^2));
    save('data/deterministic_forcing_series.mat', 't', 'z');
    
end


return