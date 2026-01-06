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
for cy = 1:size(cyclones100,2)-1
    disp(cyclones100(cy).h_name)
    
    contourArrayACF2 = zeros(size(windows,1),size(timeAxis,1));
    contourArrayACF3   = zeros(size(windows,1),size(timeAxis,1));
    contourArrayACF4   = zeros(size(windows,1),size(timeAxis,1));
    contourArrayACF6   = zeros(size(windows,1),size(timeAxis,1));
    contourArrayACF12   = zeros(size(windows,1),size(timeAxis,1));
    
    ei = cyclones100(cy).event_index;
    
    for i = 1:size(windows,1)
        ws = windows(i); 
        if mod(ws,10)==0; disp(num2str(ws)); end
        data = cyclones100(cy).slp_data(ei+tMin-ws:ei+tMax);
        
        sACF2  = ACF_sliding(data,2,ws,false);
        sACF3  = ACF_sliding(data,3,ws,false);
        sACF4  = ACF_sliding(data,4,ws,false);
        sACF6  = ACF_sliding(data,6,ws,false);
        sACF12  = ACF_sliding(data,12,ws,false);
        
        contourArrayACF2(i,:)   = sACF2(ws+1:end)';
        contourArrayACF3(i,:)   = sACF3(ws+1:end)'; 
        contourArrayACF4(i,:)   = sACF4(ws+1:end)';  
        contourArrayACF6(i,:)   = sACF6(ws+1:end)'; 
        contourArrayACF12(i,:)   = sACF12(ws+1:end)'; 
    end
    
    cyclones100(cy).ACF2_sensitivity = contourArrayACF2;
    cyclones100(cy).ACF3_sensitivity = contourArrayACF3; 
    cyclones100(cy).ACF4_sensitivity = contourArrayACF4; 
    cyclones100(cy).ACF6_sensitivity = contourArrayACF6; 
    cyclones100(cy).ACF12_sensitivity = contourArrayACF12; 
end