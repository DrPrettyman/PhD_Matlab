%% script to plot the sea-level pressure variable
%  of all fourteen cyclones, plus the PS indicator usimng a variety of
%  window sizes



%% Load data

load('fourteen2D')
load('indicators1D') %or add to one?

%% For slp:
PS150slp_holding = zeros(301,14);
for cy = 1:14
    disp(cyclones100(cy).h_name)
    
    data = fourteen2D(cy).slp(700:1200);
    
    PS150slp  = PSE_sliding(data,54,false);
    
    PS150slp_holding(:,cy) = PS150slp(end-300:end);
end

indicators1D(1).PS150_mean = mean(PS150slp_holding,2);
indicators1D(1).PS150_std = std(PS150slp_holding,0,2);














