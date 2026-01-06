%% Compare the effect of using the alternative EOF method in differant systems
% Either using the crude altEOF function, or the altEOF_precise

numberOfSystems = 3;  % adjust if adding or removing systems
AltEOF_comp = struct; % Initialising structure to hold the data
N = 100;              % number of trials per system


%% For the Homoclinic system
AltEOF_comp(1).notes = 'Homoclinic system';

T_end = 100; delT = 0.5; length = 201; 
AltEOF_comp(1).T_end = T_end;
AltEOF_comp(1).N = N;
AltEOF_comp(1).delT = delT;
AltEOF_comp(1).length = length;

AltEOF_comp(1).all_EOF_series = zeros(length, N);
AltEOF_comp(1).all_altEOF_series = zeros(length, N);
AltEOF_comp(1).EOF_eigenvectors = zeros(2,N);
AltEOF_comp(1).altEOF_eigenvectors = zeros(2,N);
for trial = 1:N
    % start with x near the center
    x_0 = [sqrt(0.2);0.1]; %+0.05*randn(2,1);
    
    % Integrate the system in hopf_fun.m with mu a function
    %  of t which increses from -2.8 to 0.2 as t goes from 0 to 6.
    %  Standard deviation of the noise is 0.01
    exitwhile = 0; 
    while ~exitwhile
        disp(num2str(trial))
        % this while loop is to catch the warnings because sometimes the
        % system goes to infinity before t=100 and that messes things
        % up. Thankfully, when that happens there is a warning from ode45
        % so we can catch it and simply integrate again until we get a
        % "full length" timeseries.
        warning('');
        [tout, xout]=homoclinic_fun(0,T_end,x_0,@(t)(0.2-0.002*t),0.01);
        [warnMsg, warnId] = lastwarn;
        if isempty(warnMsg) 
            exitwhile = 1;
        end
    end
    tout = tout(1:50:end,:);
    xout = xout(1:50:end,:);
   
    if size(xout,1) < length
        t_new = zeros(length, 1);
        x_new = zeros(length, 2);   
        t_new(1:size(tout,1)) = tout;
        x_new(1:size(xout,1),:) = xout; 
        tout = t_new;
        xout = x_new;
    end
        
    % Apply the EOF method to the data and then the ACF1 and DFA
    % indicators
    [EOF1score, eigenvector] = EOF1(xout, true);
    %[altEOFscore, altEOF_vector] = Alt_EOF(xout, true);
    [altEOFscore, altEOF_vector] = Alt_EOF_Precise(xout, true);
    
    AltEOF_comp(1).all_EOF_series(:,trial) = EOF1score;
    AltEOF_comp(1).all_altEOF_series(:,trial) = altEOFscore;
    AltEOF_comp(1).EOF_eigenvectors(:,trial) = eigenvector;
    AltEOF_comp(1).altEOF_eigenvectors(:,trial) = altEOF_vector;
end

AltEOF_comp(1).time = tout;

%% For the Hopf system
AltEOF_comp(2).notes = 'Hopf system';

T_end = 60; delT = 0.2; length = 301;
AltEOF_comp(2).T_end = T_end;
AltEOF_comp(2).N = N;
AltEOF_comp(2).delT = delT;
AltEOF_comp(2).length = length;

AltEOF_comp(2).all_EOF_series = zeros(301, N);
AltEOF_comp(2).all_altEOF_series = zeros(301, N);
AltEOF_comp(2).EOF_eigenvectors = zeros(2,N);
AltEOF_comp(2).altEOF_eigenvectors = zeros(2,N);
for trial = 1:N
    disp(num2str(trial))
    x_0 = 0.001*randn(2,1);
    [tout, rout]=hopf_fun(0,T_end,x_0,@(t)(-2.9+0.05*t),0.01);
    xout = zeros(size(rout));
    xout(:,1) = rout(:,1).*cos(rout(:,2));
    xout(:,2) = rout(:,1).*sin(rout(:,2));
    tout = tout(1:20:end,:);
    xout = xout(1:20:end,:);
   
    [EOF1score, eigenvector] = EOF1(xout, true);
    %[altEOFscore, altEOF_vector] = Alt_EOF(xout, true);
    [altEOFscore, altEOF_vector] = Alt_EOF_Precise(xout, true);
    
    AltEOF_comp(2).all_EOF_series(:,trial) = EOF1score;
    AltEOF_comp(2).all_altEOF_series(:,trial) = altEOFscore;
    AltEOF_comp(2).EOF_eigenvectors(:,trial) = eigenvector;
    AltEOF_comp(2).altEOF_eigenvectors(:,trial) = altEOF_vector;
end
AltEOF_comp(2).time = tout;

%% For the Van der Pol system
AltEOF_comp(3).notes = 'Van der Pol system';

T_end = 400; delT = 1; length = 401;
AltEOF_comp(3).T_end = T_end;
AltEOF_comp(3).N = N;
AltEOF_comp(3).delT = delT;
AltEOF_comp(3).length = length;

AltEOF_comp(3).all_EOF_series = zeros(401, N);
AltEOF_comp(3).all_altEOF_series = zeros(401, N);
AltEOF_comp(3).EOF_eigenvectors = zeros(2,N);
AltEOF_comp(3).altEOF_eigenvectors = zeros(2,N);
for trial = 1:N
    disp(num2str(trial))
    x_0 = 0.001*randn(2,1);
    [tout_system,xout_system] = VDPwithnoise_fun(0 ,T_end, x_0,...
        @(t)(-0.38 + 0.001*t), 0.01);
    tout = tout_system(1:100:end);
    xout = xout_system(1:100:end,:);

    [EOF1score, eigenvector] = EOF1(xout, true);
    %[altEOFscore, altEOF_vector] = Alt_EOF(xout, true);
    [altEOFscore, altEOF_vector] = Alt_EOF_Precise(xout, true);
    
    AltEOF_comp(3).all_EOF_series(:,trial) = EOF1score;
    AltEOF_comp(3).all_altEOF_series(:,trial) = altEOFscore;
    AltEOF_comp(3).EOF_eigenvectors(:,trial) = eigenvector;
    AltEOF_comp(3).altEOF_eigenvectors(:,trial) = altEOF_vector;
end
AltEOF_comp(3).time = tout;

%%

for j = 1:numberOfSystems
    AltEOF_comp(j).eigenTheta_reg = zeros(AltEOF_comp(j).N,1);
    AltEOF_comp(j).eigenTheta_alt = zeros(AltEOF_comp(j).N,1);
    for i = 1:AltEOF_comp(j).N
        v_reg = AltEOF_comp(j).EOF_eigenvectors(:,i);
        v_alt = AltEOF_comp(j).altEOF_eigenvectors(:,i);

        AltEOF_comp(j).eigenTheta_reg(i) = atan(v_reg(2)/v_reg(1));
        AltEOF_comp(j).eigenTheta_alt(i) = atan(v_alt(2)/v_alt(1));
    end 
end

%%
for j = 1:numberOfSystems
    AltEOF_comp(j).meanTheta_reg = mean(AltEOF_comp(j).eigenTheta_reg);
    AltEOF_comp(j).meanTheta_alt = mean(AltEOF_comp(j).eigenTheta_alt);
end

%%

for j = 1:numberOfSystems
    AltEOF_comp(j).eigenTheta_differences =...
        zeros(AltEOF_comp(j).N,1);
    for i = 1:AltEOF_comp(j).N
        
        AltEOF_comp(j).eigenTheta_differences(i) =...
            abs(AltEOF_comp(j).eigenTheta_reg(i) -...
            AltEOF_comp(j).eigenTheta_alt(i));
    end
    mean_difference = mean(AltEOF_comp(j).eigenTheta_differences);
    AltEOF_comp(j).eigenTheta_meandifference =...
        mean_difference;
    AltEOF_comp(j).eigenTheta_meandifference_degrees =...
        180*mean_difference/pi;
    
end