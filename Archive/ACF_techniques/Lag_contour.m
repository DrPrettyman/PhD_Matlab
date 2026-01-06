 function [out] =   Lag_contour(H, H_Number, Thing, fixed)

% H_number is the number of the hurricane (6 for Katrina)
% Thing is either WindowSize or Agregate
% fixed is the value of the thing that is fixed


data = H(H_Number).slp_data_RO12(1:481);


switch Thing
    case 'WindowSize'
        range = (72:1:240)';
        ylab = 'ACF-propagator window size';
        
    case 'Lag' 

        range = (1:1:6)';
        ylab = 'Lag size';
end




Z = zeros(size(range,1), size(data,1));



for i = 1:size(range,1)
    
    switch Thing
        case 'WindowSize'
            WS = range(i);
            LAG = fixed;
        case 'Lag'
            WS = fixed;
            LAG = range(i);
    end
    
    sacf = ACF_sliding(data, LAG, WS, false);

    Z(i, :) = sacf;

    
end



Z = Z(:, (WS+1):end)';

X = range;
Y = (1:size(data,1)-WS)';
Y = Y - Y(end);

figure
contourf(Y, X, Z', 12)
title(['ACF-propagator - ', H(H_Number).h_name]);
ylabel(ylab)
xlabel('Time (hours) - event at zero')

out = 'done';


