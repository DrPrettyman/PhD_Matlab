function [time_out, pressure_out, distance, cyclone_xy, site_xy] ...
    = Grid_Holland_model(m,n,s,approach_angle)


%% Fix parameters

A = 40;             % parameter to be fitted
B = 1;              % parameter to be fitted

p_0 = 1016;         % mean normal pressure
p_min = 950;        % minimum central pressure

v_0 = 18;           % average forward movement velocity of cyclone
v_min = 8;          % the minimum allowed velocity

l_0 = 10000;        % Initial distance of cyclone from centre of grid
%approach_angle = pi/4; % angle of approach towards centre of grid (from 'north')
%m = 10;            % number of rows of points in grid
%n = 10;            % number of columns of points in grid
%s = 20;            % spacing of grid points (km)

T_total = 700;      % total time to run the model
Del_t = 1;          % time step

sigma_1 = 3;        % std of rednoise added to ambient pressure array
sigma_2 = 2;        % std of rednoise added to velocity array
sigma3 = 1.5;      % std of white noise added to final timeseries


%% Define reference arrays

site_thetaVals = zeros(m,n);
site_rVals     = zeros(m,n);
site_xy        = cell(m,n);
site_initDist  = zeros(m,n);
site_closDist  = zeros(m,n);

for i = 1:m
    for j = 1:n
        x = s*(j-(n+1)/2);
        y = -s*(i - (m+1)/2);
        site_xy{i,j} = [x,y];
%         [theta, r] = cart2pol(x,y);

%         site_thetaVals(i,j) = theta;
%         site_rVals(i,j) = r;
%         site_initDist(i,j) = sqrt(r^2 + l_0^2 +...
%             2*r*l_0*cos(theta-approach_angle));
%         site_closDist(i,j) = r*sin(theta-approach_angle);
    end
end


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

%% Find the time of "event"
% here we find the time at which the cyclone reaches the mid poind of the
% grid of sites. i.e., when l_0 - d_trav is smallest.

dummy = abs(d_trav -  l_0);
T_event = time(dummy == min(dummy));
disp(num2str(T_event))

%% For each site, calculate the pressure at that point


pressure = cell(m,n);
distance = cell(m,n);
flatNoise = dsp.ColoredNoise(0.2,1000);
for i = 1:m
    for j=1:n 

        sx = site_xy{i,j}(1); % x coord of site
        sy = site_xy{i,j}(2); % y coord of site
        site_pressure = zeros(size(time));
        site_distance = zeros(size(time));
        for t_index = 1:size(time,1)
            cx = cyclone_xy(t_index,1); % x coord of cyclone at time t
            cy = cyclone_xy(t_index,2); % y coord of cyclone at time t
            site_distance(t_index) = sqrt((cx-sx)^2 + (sy-cy)^2);
%             d = sqrt( (site_initDist(i,j) -...
%                 d_trav(t_index))^2 + site_closDist(i,j)^2);
            % finally, use these to calculate the pressure at point P
            site_pressure(t_index) = cen_pressure(t_index) +...
                (amb_pressure(t_index) - cen_pressure(t_index))...
                *exp(-A/(site_distance(t_index).^B));
        end
        
        site_min_dist = min(site_distance);
        increase_noise_len = min(10, floor(100-site_min_dist/2));
        site_T_event = find(site_distance == site_min_dist);
        
        noise_flat = flatNoise();
        noise_flat = noise_flat/std(noise_flat);
        
        noise_flat0 = noise_flat(1:site_T_event-increase_noise_len);
        
        noise_flat1 = flatNoise();
        noise_flat1 = noise_flat1/std(noise_flat1);
        
        noise_increase = changingNoise1(0.2,2,100);
        noise_increase = noise_increase(1:increase_noise_len);
        noise_decrease = noise_increase(end:-1:1);
        
        addedNoise = [noise_flat0; noise_increase; noise_decrease; noise_flat1];
        
        pressure{i,j} = site_pressure + sigma3*addedNoise(1:size(site_pressure,1));
        distance{i,j} = site_distance;
    end
end

pressure_out = pressure;
time_out = time - T_event;

return
