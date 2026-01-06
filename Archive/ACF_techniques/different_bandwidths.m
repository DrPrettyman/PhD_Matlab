%% must run ACF_withsmoothing.m first to get the variables

%% Do the sliding ACF technique

lag = 1;
windowSize = 100;

bandwidths = (1:0.5:5)';
filtered_slidingACF = zeros(size(firstscorep,1), size(bandwidths,1));

for i = 1:size(bandwidths,1)
    
% smooth and filter the firstscore data 
    smoothscore = gauss_smoother([time firstscorep], bandwidths(i));
    filteredscore = firstscorep - smoothscore(:,2);
% use ACF on the filtered data
    filtered_slidingACF(:,i) = ...
        ACF_sliding(filteredscore, lag, windowSize, false);
end

% also do ACF on the firstscore original data
slidingACF = ACF_sliding(firstscorep, lag, windowSize, false);



%% plot the figures

stringdates = datestr(time, 'dd-mmm');

ax1 = subplot(1,1,1);

title(plot_title)
hold on

for i = 1:size(bandwidths,1)
    name = ['b = ' num2str(bandwidths(i))];
    plot(ax1, time(1+skip:end-endskip),...
        filtered_slidingACF(1+skip:end-endskip,i),...
        'DisplayName',name);
end

plot(ax1, time(1+skip:end-endskip),...
    slidingACF(1+skip:end-endskip), 'color', 'black',...
    'DisplayName','unfiltered','LineWidth',1.5);

ax1.XTick = time(1+skip:25:end-endskip);
ax1.XTickLabel = stringdates(1+skip:25:end-endskip,:);
ax1.XTickLabelRotation = 90;
ax1.Box  = 'on';
ax1.XLim = [time(1+skip) time(end-endskip)];
ax1.XGrid = 'on';
ax1.XLabel.String = 'time';
ax1.YLabel.String = 'ACF propagator';

legend(ax1,'Location','northwest')

hold off

