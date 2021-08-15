%% addto100 DFA ONLY!!!

%%
wsMin = 40;
wsMax = 160;
wsStep = 1;

tMin = -144;
tMax = 0;

%%
% If the structure cyclones100 does not have the variables required to
% plot the sensitivity analysis contour maps, this will add them.

% For each indicator, we use window sizes from 40 to 160 and save all
% the indicators in a an array 121x145. 121 windowsizes by 145 time
% points from -144 to 0, the timeseries fed into the sliding-window
% indicator function is therefore from -144-windowsize to 0, and the
% output cropped.


%% load

load('cyclones100')
windows = (wsMin:wsStep:wsMax)';
timeAxis = (tMin:1:tMax)';

%% 
warning('off','MATLAB:polyfit:PolyNotUnique'); % disable warning common with DFA methdo
warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
for cy = 1:size(cyclones100,2)
    disp(cyclones100(cy).h_name)
    contourArrayDFA   = zeros(size(windows,1),size(timeAxis,1));
    ei = cyclones100(cy).event_index;
    for i = 1:size(windows,1)
        ws = windows(i); 
        if mod(ws,10)==0; disp(num2str(ws)); end
        data = cyclones100(cy).slp_data(ei+tMin-ws:ei+tMax);
        sDFA  = DFA_sliding(data,2,ws,false);
        contourArrayDFA(i,:)   = sDFA(2:end)';  
    end 
    cyclones100(cy).DFA_sensitivity = contourArrayDFA; 
end
warning('on','MATLAB:polyfit:PolyNotUnique');
warning('on','MATLAB:polyfit:RepeatedPointsOrRescale');