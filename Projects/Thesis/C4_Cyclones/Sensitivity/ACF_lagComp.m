%% Load data

load('fourteen2D')

windowSize_acf1 = 100;

indicators1D = struct; %do we want to create a new structure?
%load('indicators1D') %or add to one?

desasonalise = true;


indicators1D(1).variable = 'slp';
indicators1D(1).var_label = 'SLP (hPa)';
%% The the values themselves
slp_values = zeros(501,14);
for cy = 1:14
    disp(fourteen2D(cy).h_name)
    X1 = fourteen2D(cy).slp(700:1200);
    if desasonalise
        psize = 12; %partition size
        Dwave1 = zeros(psize,1);
        newX1 = zeros(numel(X1),1);
        for k = 1:psize
            Dwave1(k) = mean(X1(k:psize:end));
            newX1(k:psize:end) = X1(k:psize:end) - Dwave1(k);
        end
        clear k psize
        slp_values(:,cy) = newX1 - mean(newX1);
    else
        slp_values(:,cy) = X1;
    end
end
indicators1D(1).values = slp_values;
indicators1D(1).mean_value = mean(slp_values,2);

%% For slp, ws and eof calculate the ACF1, DFA and PS indicators:

Cy_20lags = struct;
N = size(indicators1D(1).values,1);

for k = 1:20
    Cy_20lags(k).lag = k;
    disp(['lag-',num2str(Cy_20lags(k).lag)])
    ACF1slp_holding = zeros(N,1);
    for cy = 1:14
        data = indicators1D(1).values(:,cy);
        ACF1slp = ACF_sliding(data,Cy_20lags(k).lag,windowSize_acf1,false);
        ACF1slp_holding(:,cy) = ACF1slp(end-N+1:end);
    end
    Cy_20lags(k).ACF1_mean = mean(ACF1slp_holding,2);
    Cy_20lags(k).ACF1_std = std(ACF1slp_holding,0,2);
end

