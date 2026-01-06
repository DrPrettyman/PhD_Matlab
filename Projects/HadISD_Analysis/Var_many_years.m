%% Looking at all the years


%%
% Year to look at
%years = (1990:2005)';
years = [1992, 1999, 2004, 2005]';

% window size of ACF-1 sliding window
ws=240;

[slp, acf] = plot_many_years(years, ws);

%% Calculate the mean variance of all the acf series in a sliding window

% ACF mean variance
AMV = zeros(size(acf,1),1);

%ACF mean
%AM = mean(acf,2);
AM = zeros(size(acf,1),1);

ws = 28*24;
for i = ws:size(AMV,1)
    section = acf( i-ws+1:i ,:);
        
    v = var(section);
    AMV(i) = mean(v);
    
    m = mean(section);
    AM(i) = mean(m);
end

ax1 = subplot(4,1,1);
hold on
for i = 1:size(years,1);
    plot(ax1, slp(:,i))
end
    
ax2 = subplot(4,1,2);
hold on
for i = 1:size(years,1);
    plot(ax2, acf(:,i))
end

ax3 = subplot(4,1,3);
plot(ax3, AMV)

ax4 = subplot(4,1,4);
plot(ax4, AM)
ylim([0.93,1])