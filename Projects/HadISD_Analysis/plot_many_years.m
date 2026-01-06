function [slp, acf, dfa] = plot_many_years(years, ws, doDFA)

if nargin < 3
    doDFA = false;
end

%%
slp = zeros(365*24, size(years,1));
acf = zeros(size(slp));
dfa = zeros(size(slp));

for i = 1:size(years,1)
    
    % Set the start and end dates, that is, the start of the year 
    % and the end of the year for each year you want to inspect.
    strdate_start = ['01-01-' num2str(years(i))];
    strdate_start = datestr(datenum(strdate_start) - ws/24);
    strdate_end = ['01-01-' num2str(years(i)+1)];
    
    % Retrive the interpolated pressure data from the hadISD, station 2.
    [lat, lon, time, slp_i] = ...
        get_hadISD_data_interpolated(2, strdate_start, strdate_end);
    
    % Remove the last data point of the slp_i
    % this is the first hour of January for the next year
    % It is easier to specify the date as midnight 01-Jan 
    % and then chop it off than to try to specify 23:00 31-Dec
    % as the end date.
    slp_i = slp_i(1:end-1);
    acf_i = ACF_sliding(slp_i,1,ws,false);
    
    if doDFA;
        dfa_i = DFA_sliding(slp_i,2,ws,false);
        dfa_indices = (ws:floor(ws/6):size(slp_i,1))';
        dfa_i = interp1(dfa_indices, dfa_i, (1:size(slp_i,1))');
        size(slp_i)
        size(acf_i)
        size(dfa_i)
    end
    
    % take off the first bit of length "window size" (ws)
    slp_i = slp_i(ws+1:end);
    acf_i = acf_i(ws+1:end);
    dfa_i = dfa_i(ws+1:end);
    % Remove the 29th of Feb for leap years. this makes it easier
    % to store all the signals together in one array.
    % I don't think it would effect the seasonality too much
    % since it is just one day.
    if mod(years(i), 4) == 0
        if mod(years(i), 100) == 0 && mod(years(i),1000) ~= 0
            
        else
            slp_i = [slp_i(1:59*24); slp_i(60*24+1:end)];
            acf_i = [acf_i(1:59*24); acf_i(60*24+1:end)];
            dfa_i = [dfa_i(1:59*24); dfa_i(60*24+1:end)];
        end
    end
    
    disp([num2str(years(i)), ' ', num2str(size(slp_i,1))])
       
    % Store all the slp and acf data in one array each
    slp(:,i) = slp_i;
    acf(:,i) = acf_i;
    dfa(:,i) = dfa_i;
    
    clear slp_i acf_i dfa_i strdate_start strdate_end 
    
end


%%

ax1 = subplot(2,1,1);
hold on
for i = 1:size(years,1);
    plot(ax1, slp(:,i))
end
    
ax2 = subplot(2,1,2);
hold on
for i = 1:size(years,1);
    plot(ax2, acf(:,i))
end