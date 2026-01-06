%% addto100

%%
wsMin = 40;
wsMax = 160;
wsStep = 1;

tMin = -144;
tMax = 0;

%%
% WARNING: The DFA indicator takes a long time to calculate. Uncomment
% the appropriate lines of code at your own risk.

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

for cy = 1:size(cyclones100,2)
    cyclones100(cy).windows = windows;
end

%% 
for cy = 1:size(cyclones100,2)
    disp(cyclones100(cy).h_name)
    
    contourArrayACF1 = zeros(size(windows,1),size(timeAxis,1));
    contourArrayPS   = zeros(size(windows,1),size(timeAxis,1));
    %contourArrayDFA   = zeros(size(windows,1),size(timeAxis,1));
    
    ei = cyclones100(cy).event_index;
    
    for i = 1:size(windows,1)
        ws = windows(i); 
        if mod(ws,10)==0; disp(num2str(ws)); end
        data = cyclones100(cy).slp_data(ei+tMin-ws:ei+tMax);
        
        sACF = ACF_sliding(data,1,ws,false);
        sPS  = PSE_sliding(data,ws,false);
        %sDFA  = DFA_sliding(data,2,ws,false);
        
        contourArrayACF1(i,:) = sACF(ws+1:end)';
        contourArrayPS(i,:)   = sPS(ws+1:end)'; 
        %contourArrayDFA(i,:)   = sDFA(2:end)';  
    end
    
    cyclones100(cy).ACF1_sensitivity = contourArrayACF1;
    cyclones100(cy).PS_sensitivity = contourArrayPS; 
    %cyclones100(cy).DFA_sensitivity = contourArrayDFA; 
end