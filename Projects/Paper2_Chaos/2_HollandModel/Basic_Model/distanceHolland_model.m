
v_0 = 18;           % average forward movement velocity of cyclone

d_c = 10;  % distance at closest approach
d_0 = 8000;         % Initial distance of cyclone
%d_0 = sqrt(l_0^2+d_c^2); % Alternative formulation if l_0 is given

l_0 = sqrt(d_0^2 - d_c^2);

T_total = 700;      % total time to run the model
Del_t = 1;          % time step

sigma_2 = 5;        % std of rednoise added to velocity array


%% Create some useful arrays
% Define the time array
time = (0:Del_t:T_total)';

% create a velocity array (v_0 + rednoise)
rednoise2 = cumsum(randn(size(time)));
velocity = v_0 + sigma_2*(rednoise2 / std(rednoise2));

distance = zeros(size(time));
d_trav = zeros(size(time));
delarry = zeros(size(time));
distance(1) = d_0;
d_trav(1) = 0;


%% Run the model
for i = 2:size(time,1)
    % set time t
    t = time(i);
    
    % calculate the distance at time t
    Del_l = 0.5*(velocity(i)+velocity(i-1))*Del_t;
    delarry(i) = Del_l;
    d_trav(i) = d_trav(i-1) + Del_l;
    
    d_fromxc = l_0 - d_trav(i);
    
    distance(i) = sqrt(d_c^2 + d_fromxc^2);
   
    
end

figure
plot(time, distance);
% figure
% plot(time, cumsum(delarry));
