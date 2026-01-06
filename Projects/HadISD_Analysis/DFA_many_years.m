%% Looking at all the years


%%
% Year to look at4
%years = (1990:2005)';
years = [1992, 1999, 2004, 2005]';

% window size of ACF-1 sliding window
ws=240;

[slp, acf, dfa] = plot_many_years(years, ws, true);

%% Calculate the mean variance of all the acf series in a sliding window

% DFA mean variance
DMV = zeros(size(dfa,1),1);

%DFA mean
%DM = mean(acf,2);
DM = zeros(size(dfa,1),1);

ws = 28*24;
for i = ws:size(DMV,1)
    section = acf( i-ws+1:i ,:);
        
    v = var(section);
    DMV(i) = mean(v);
    
    m = mean(section);
    DM(i) = mean(m);
end

ax1 = subplot(4,1,1);
hold on
for i = 1:size(years,1);
    plot(ax1, slp(:,i))
end
    
ax2 = subplot(4,1,2);
hold on
for i = 1:size(years,1);
    plot(ax2, dfa(:,i))
end

ax3 = subplot(4,1,3);
plot(ax3, DMV)

ax4 = subplot(4,1,4);
plot(ax4, DM)
ylim([0.93,1])