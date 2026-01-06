function [time_out, pressure_out, site_xy, eventIndex1] =...
    simpleGridModel(m, s, sigma1, sigma3)
%% This is a function which runs a simple gridded model.


%% Fix parameters

A = 40;             % parameter to be fitted
B = 1;              % parameter to be fitted

p0 = 1016 + 5*randn();          % mean normal pressure
p_min = 950 + 10*randn();       % minimum central pressure

T_event = 400;     % Time of event
v0 = 18 + randn(); % forward movement velocity of cyclone
l0 = T_event*v0;   % Initial distance of cyclone from centre of grid
% note the hurricane's position at time t will have x-coodinate 0 and
% y-coordinate equal to -v0*t. The distance from the hurricane to
% point (x,y) will therefore be sqrt(x^2 + (y+v0*t)^2). Note also that
% because we define l0 = 500*v0, the event will happen at time = 500,
% if we define the event as being the time that the hurricane reaches
% the centre of the grid.


%s = 20;            % Spacing of grid points
%m = 10;            % Number of grid points on each side of square

T_total = T_event+100; % total time to run the model
Del_t  = 0.1;         % time step
noiseUpDuration = 50;  % Duration of the noiseUp increasing noise part of
                       % the series (ocurring before the event). In hours.
noiseUpLen = floor(noiseUpDuration/Del_t);    
                    % noiseUpLen is the length in times steps, not hours, 
                    % of the colour-increasing part of the noise

%sigma1 = 2;        % std of rednoise added to ambient pressure array
%sigma3 = 1;        % std of noise added to pressure series
bgNoiseCol = 0.4;   % the colour of the background noise
alpha0 = 2.0;         % the colour of noiseUp increases from bgNoiseCol to 
                    % alpha1, where alpha1 = alpha0 for the closest grid-
                    % points and alpha1 = bgNoiseCol for the farthest points
beta0 = 2.0;          % the std of noiseUp increases from sigma3 to beta1*sigma3 
                    % where beta1 = beta0 for the closest grid-ponts and
                    % beta1 = 1 for the farthest gridpoints.


%% Create model inputs 
% Define the time array
time = (0:Del_t:T_total)' - T_event;

% Model the ambient pressure
p_n = p0 + 1.6*sin((2*pi.*(time))/12 + 12*rand()); %ambiant pressure
% Create some red noise with mean=0, std = sigma1, 
% to add to the ambient pressure
redNoise = dsp.ColoredNoise(2,size(time,1));
noise_red = redNoise(); 
p_n = p_n + sigma1*(noise_red-mean(noise_red))/std(noise_red);

%% Define reference arrays
site_xy        = cell(m,m);
% site_xy gives the x and y coordinates of each site. Useful for reference
% as an output to make sure the plots are the right way around (hurricane
% approaching from the 'south'. 

if m == 1
    site_xy{1,1} = [s,0];
else
    for i = 1:m
        for j = 1:m
            x = s*(j-(m+1)/2);
            y = -s*(i - (m+1)/2);
            site_xy{i,j} = [x,y];
        end
    end
end


%% For each site, calculate the pressure at that point
pressure = cell(m,m);

bgNoise = dsp.ColoredNoise(bgNoiseCol,size(time,1));
for i = 1:m
    for j=1:m 
        % Calculate the distance of the hurricane from the current grid 
        % point at each time step  
        site_distance = sqrt(site_xy{i,j}(1)^2 +...
            (site_xy{i,j}(2)-v0.*time).^2);

        % Note site_xy{i,j}(1) is the x-coord of site and 
        % site_xy{i,j}(2) is the y-coord of site
        
        % Calculate the pressure at the current grid point at each
        % time step. The pressure is a function of the distance of the
        % hurricane (site_distance), the ambiant pressure series (p_n)
        % and the central pressure (p_min), besides the parameters A
        % and B.
        site_pressure = p_min +...
            (p_n - p_min).*exp(-A./(site_distance.^B));
        
        % Now we add noise. We have two parts to the noise. Background
        % noise (noise0) which is a white/pink noise series with
        % colour exponent given by bgNoiseCol. Also, noiseUp, a
        % colour-increasing noise series where the maximum
        % colour-value is alpha0 for the gridpoints where the minimum
        % distance to the hurricane is zero. Points further away have
        % a lower maximum noise colour.
        
        % Create the bgNoise with std sigma3 and colour bgNoiseCol
        noise0 = bgNoise();
        noise0 = sigma3*(noise0-mean(noise0))/std(noise0);
        
        % Create the increasing part of the noise. The length of this
        % is noiseUpLen=5000 - i.e. 50hours. alpha1 is a function of the 
        % minimum distance to the hurricane and defines the maximum noise
        % colour value.
        site_min_dist = abs(site_xy{i,j}(1));
        if m==1
            alpha1 = alpha0; 
            beta1 = beta0; 
        else
            alpha1 = alpha0 + site_min_dist*2*(bgNoiseCol-alpha0)/((m-1)*s);
            beta1 = beta0 + site_min_dist*(1-beta0)/((m-1)*s);
        end
        noiseUp = changingNoise1(bgNoiseCol, alpha1, noiseUpLen);
        varUp = linspace(sigma3, beta1*sigma3, noiseUpLen)';
        noiseUp = noiseUp.*varUp;
        
        % Replace part of the noise0 series with the (shorter) noiseUp
        % series. The noiseUp series should start at the event minus
        % noiseUpLen time steps and stop at the time of the event.
        T_index = find(time >= site_xy{i,j}(2)/v0, 1);
        % Note site_xy{i,j}(2)/v0 is the time at which the event
        % happens for this grid point. 
        noise0(T_index-noiseUpLen+1 : T_index) = noiseUp;

        pressure{i,j} = site_pressure + noise0;
    end
end

eventIndex1 = find(time >= (-s*(m-1)/2)/v0, 1);
pressure_out = pressure;
time_out = time;

return
