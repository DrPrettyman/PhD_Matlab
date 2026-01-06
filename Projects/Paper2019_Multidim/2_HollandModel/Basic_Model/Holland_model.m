function [time_out, pressure_out] = Holland_model()


%% Fix parameters

A = 40;             % parameter to be fitted
B = 1;              % parameter to be fitted

p_0 = 1016;         % mean normal pressure
p_min = 950;        % minimum central pressure

v_0 = 18;           % average forward movement velocity of cyclone
v_min = 8;          % the minimum allowed velocity

d_c = -(2+3*rand);  % distance at closest approach
d_c = 0;
d_0 = 10000;         % Initial distance of cyclone
l_0 = sqrt(d_0^2 - d_c^2); % Initial distance of cyclone from point of
                    % closest approach.

T_event = 500;      % time that the minimum central pressure is reached
T_start = 1;        % time that the central pressure starts to drop
T_total = 700;      % total time to run the model
Del_t = 1;          % time step

sigma_1 = 3;        % std of rednoise added to ambient pressure array
sigma_2 = 2;        % std of rednoise added to velocity array
sigma_3 = 1.5;      % std of white noise added to final timeseries

timebeforeevent = 300; % -1 the length of the timeseries

%% Model the central and ambient pressure
%p_c = @(t)(centralPressureModel('linear', p_0, p_min, T_event, T_start, t));
p_c = @(t)(p_min);
p_n = @(t)(p_0 + 1.6*sin((2*pi*(t))/12)); %ambiant pressure


%% Create some useful arrays
% Define the time array
time = (0:Del_t:T_total)';

% Create some red noise with mean=0, std = sigma_1, 
% to add to the ambient pressure
rednoise1 = cumsum(randn(size(time)));
rednoise1 = sigma_1*((rednoise1-mean(rednoise1)) / std(rednoise1));

% create a velocity array (rednoise mean=v_0, std=sigma_2 )
velocity = zeros(size(time));
while any(velocity < v_min)
    rednoise2 = cumsum(randn(size(time)));
    velocity = v_0 + sigma_2*((rednoise2 - mean(rednoise2))/ std(rednoise2));
end

pressure = zeros(size(time));
amb_pressure = zeros(size(time));
cen_pressure = zeros(size(time));
d_trav = zeros(size(time));
distance = zeros(size(time));

pressure(1) = p_0;
amb_pressure(1) = p_0;
cen_pressure(1) = p_0;
d_trav(1) = 0;
distance(1) = d_0;


%% Run the model
for i = 2:size(time,1)
    % set time t
    t = time(i);
    
    % calculate ambient and central preassure at time t
    amb_pressure(i) = p_n(t) + rednoise1(i);
    cen_pressure(i) = p_c(t);
    
    % calculate the distance at time t
    Del_l = 0.5*(velocity(i)+velocity(i-1))*Del_t;
    d_trav(i) = d_trav(i-1) + Del_l;
    
    distance(i) = sqrt( (l_0 - d_trav(i))^2 + d_c^2);
     
    % finally, use these to calculate the pressure at point P
    pressure(i) = cen_pressure(i) + ...
        (amb_pressure(i) - cen_pressure(i))*exp(-A/(distance(i).^B));   
end

% add noise to the pressure time series
noise = noise_generator( 2*size(time,1) , 2, false)';
added_noise = noise(1:size(pressure,1)); 
pressure = pressure+sigma_3*added_noise;

%% Filter the final timeseries to end at the time of closest approach

index = find(distance == min(distance));

if index >= timebeforeevent
    pressure_out = pressure(index-timebeforeevent:index);
else
    % this step ensures that the output series will always be the same
    % length. if the event occurs too early in time, we concatenate a
    % constant time series onto the front, so that the event still occurs
    % at time (timebeforeevent+1)
    pressure_out = [p_0*ones(timebeforeevent-index,1);pressure(1:index)];
end
time_out = (-timebeforeevent:0)';

return
