%% Fix parameters

A = 40;             % parameter to be fitted
B = 1;              % parameter to be fitted

p_0 = 1016;         % mean normal pressure
p_min = 920;        % minimum central pressure

v_0 = 18;           % average forward movement velocity of cyclone
v_min = 8;          % the minimum allowed velocity

l_0 = 10000;        % Initial distance of cyclone from centre of grid
approach_angle = 0.1; % angle of approach towards centre of grid (from 'north')
m = 1;              % number of rows of points in grid
n = 1;             % number of columns of points in grid
s = 10;             % spacing of grid points (km)

T_total = 700;      % total time to run the model
Del_t = 1;          % time step

sigma_1 = 3;        % std of rednoise added to ambient pressure array
sigma_2 = 5;        % std of rednoise added to velocity array
sigma_3 = 1.5;      % std of white noise added to final timeseries


%% Define reference arrays
%
site_xy = {[0,10]};

%% Model the central and ambient pressure
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

amb_pressure = zeros(size(time));
cen_pressure = zeros(size(time));
d_trav = zeros(size(time));
cyclone_xy = zeros(size(time,1),2);

amb_pressure(1) = p_0;
cen_pressure(1) = p_0;
d_trav(1) = 0;
[cyclone_xy(1,1), cyclone_xy(1,2)] = ...
        pol2cart(approach_angle, l_0);

%% Run the cyclone forward 
for i = 2:size(time,1)
    
    % calculate ambient and central preassure at time t=time(i)
    amb_pressure(i) = p_n(time(i)) + rednoise1(i);
    cen_pressure(i) = p_c(time(i));
    
    % calculate the distance traversed by the cyclone so far since t=0
    Del_l = 0.5*(velocity(i)+velocity(i-1))*Del_t;
    d_trav(i) = d_trav(i-1) + Del_l;
    
    % calculate the current x,y coords of the cyclone
    [cyclone_xy(i,1), cyclone_xy(i,2)] = ...
        pol2cart(approach_angle, l_0-d_trav(i));
end

%% For each site, calculate the pressure at that point
noise = noise_generator( 2*size(time,1) , 2, false)';
added_noise = sigma_3*noise(1:size(time,1)); 

sx = 0; % x coord of site
sy = 10; % y coord of site
site_pressure = zeros(size(time));
site_distance = zeros(size(time));
for t_index = 1:size(time,1)
    cx = cyclone_xy(t_index,1); % x coord of cyclone at time t
    cy = cyclone_xy(t_index,2); % y coord of cyclone at time t
    site_distance(t_index) = sqrt((cx-sx)^2 + (sy-cy)^2);
   
    % finally, use these to calculate the pressure at point P
    site_pressure(t_index) = cen_pressure(t_index) +...
        (amb_pressure(t_index) - cen_pressure(t_index))...
        *exp(-A/(site_distance(t_index).^B))+...
        added_noise(t_index);
end

figure
plot(time, site_pressure)
figure
plot(time, site_distance)
figure
plot(time, amb_pressure)
figure
plot(time, cen_pressure)

