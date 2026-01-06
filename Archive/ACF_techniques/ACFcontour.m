 function [out] = ACFcontour(H, H_Number, Thing, fixed)

% H_number is the number of the hurricane (6 for Katrina)
% Thing is either WindowSize or Agregate
% fixed is the value of the thing that is fixed


data = H(H_Number).slp_data_RO12(1:481);


switch Thing
    case 'WindowSize'
        findWS = true;
        % range of Window sizes
        range = (72:1:240)';
        ylab = 'ACF-propagator window size';
        
        %agregate the data now
        if fixed ~= 1
            x = data( (mod(size(data,1),fixed) +1) :end);
            xx = reshape(x, fixed, size(x,1)/fixed);
            dataA = sum(data,1);
            clear x xx
        else
            dataA = data;
        end
        
    case 'Agregate' 
        findWS = false;
        % range of Agregation sizes
        range = (1:1:12)';
        ylab = 'Agregation size';
end




Z = zeros(size(range,1), size(data,1));



for i = 1:size(range,1)
    if findWS
        A = fixed;
        WS = floor(range(i)/A);
    else
        A = range(i);

        x = data( (mod(size(data,1),A) + 1) :end);

        xx = reshape(x, A, size(x,1)/A);

        
        dataA = sum(xx,1)';

        clear x xx
        
        
        WS = floor(fixed/A);
    end
    
    sacf = ACF_sliding(dataA, 1, WS, false);

    if findWS
        Z(i, :) = sacf;
    else
        x = (mod(size(data,1),A)+1:A:size(data,1))';
        %disp(size(x))
        v = sacf;
        %disp(size(v))
        xq = (1:size(data,1))';
        %disp(size(xq))
        Z(i, :) = interp1(x,v,xq);
    end
    
end



Z = Z(:, (A*WS+1):end)';

X = range;
Y = (1:size(data,1)-A*WS)';
Y = Y - Y(end);

figure
contourf(Y, X, Z', 12)
title(['ACF-propagator - ', H(H_Number).h_name]);
ylabel(ylab)
xlabel('Time (hours) - event at zero')

out = 'done';


