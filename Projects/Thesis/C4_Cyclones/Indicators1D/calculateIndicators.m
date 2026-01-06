%% script to plot the sea-level pressure variable
%  of all fourteen cyclones, plus the ACF1, DFA and PS indicators



%% Load data

load('fourteen2D')

% 
windowSize_acf1 = 90;
windowSize_dfa = 90;
windowSize_ps = 102;

indicators1D = struct; %do we want to create a new structure?
%load('indicators1D') %or add to one?

desasonalise = true;


indicators1D(1).variable = 'slp';
indicators1D(2).variable = 'wind speed';
indicators1D(3).variable = 'eof';

indicators1D(1).var_label = 'SLP (hPa)';
indicators1D(2).var_label = 'Wind speed (kmph)';
indicators1D(3).var_label = 'EOF score';

%% The the values themselves

slp_values = zeros(501,14);
ws_values = zeros(501,14);
eof_values = zeros(501,14);

for cy = 1:14
    disp(fourteen2D(cy).h_name)
    
    X1 = fourteen2D(cy).slp(700:1200);
    X2 = fourteen2D(cy).windspeed(700:1200);
    X3 = fourteen2D(cy).eof(700:1200);
    
    if desasonalise
        psize = 12; %partition size
        Dwave1 = zeros(psize,1);
        Dwave2 = zeros(psize,1);
        Dwave3 = zeros(psize,1);
        newX1 = zeros(numel(X1),1);
        newX2 = zeros(numel(X2),1);
        newX3 = zeros(numel(X3),1);
        for k = 1:psize
            Dwave1(k) = mean(X1(k:psize:end));
            newX1(k:psize:end) = X1(k:psize:end) - Dwave1(k);
            Dwave2(k) = mean(X2(k:psize:end));
            newX2(k:psize:end) = X2(k:psize:end) - Dwave2(k);
            Dwave3(k) = mean(X3(k:psize:end));
            newX3(k:psize:end) = X3(k:psize:end) - Dwave3(k);
        end
        clear k psize
        slp_values(:,cy) = newX1 - mean(newX1);
        ws_values(:,cy) = newX2 - mean(newX2);
    else
        slp_values(:,cy) = X1;
        ws_values(:,cy)  = X2;
        eof_values(:,cy) = X3;
    end
end

indicators1D(1).values = slp_values;
indicators1D(1).mean_value = mean(slp_values,2);
indicators1D(2).values = ws_values;
indicators1D(2).mean_value = mean(ws_values,2);
indicators1D(3).values = eof_values;
indicators1D(3).mean_value = mean(eof_values,2);

%% For slp, ws and eof calculate the ACF1, DFA and PS indicators:
for k = 1:3
    disp([indicators1D(k).var_label,':'])
    N = size(indicators1D(k).values,1);
    ACF1slp_holding = zeros(N,1);
    PSslp_holding = zeros(N,1);
    DFAslp_holding = zeros(N,1);
    for cy = 1:14
        disp(['    ',fourteen2D(cy).h_name])
        data = indicators1D(k).values(:,cy);

        ACF1slp = ACF_sliding(data,1,windowSize_acf1,false);
        PSslp   = PSE_sliding(data,windowSize_ps,false);
        DFAslp  = DFA_sliding(data,2,windowSize_dfa,false);
        DFAslp  = [zeros(windowSize_dfa-1,1);DFAslp];

        ACF1slp_holding(:,cy) = ACF1slp(end-N+1:end);
        PSslp_holding(:,cy) = PSslp(end-N+1:end);
        DFAslp_holding(:,cy) = DFAslp(end-N+1:end);

    end

    indicators1D(k).ACF1_mean = mean(ACF1slp_holding,2);
    indicators1D(k).ACF1_std = std(ACF1slp_holding,0,2);
    indicators1D(k).PS_mean = mean(PSslp_holding,2);
    indicators1D(k).PS_std = std(PSslp_holding,0,2);
    indicators1D(k).DFA_mean = mean(DFAslp_holding,2);
    indicators1D(k).DFA_std = std(DFAslp_holding,0,2);
end

