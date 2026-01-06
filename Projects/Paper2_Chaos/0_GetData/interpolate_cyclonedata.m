function [ new_time, Y ] = interpolate_cyclonedata( start_date, end_date, time, X )

% interpolate the slp data onto the hourly time vector
% (if there is any left after the filtering above)
if size(X, 1) > 0
    if time(1) ~= datenum(start_date)
        time = [datenum(start_date); time];
        X = [mean(X); X];
    end
    if time(end) ~= datenum(end_date)
        time = [time; datenum(end_date)];
        X = [X; mean(X)];
    end
    
    time_i = (datenum(start_date):(1/24):datenum(end_date))';
    Y = interp1q(time, X, time_i);
    new_time = time_i;
else
    new_time = (datenum(start_date):(1/24):datenum(end_date))';
    Y = zeros(size(new_time));
end

end

