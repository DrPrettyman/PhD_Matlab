%% get the variables from the netcdf file

if exist('firstscorep', 'var')==0
    disp('fetching data')
    
    % get the data - comment out as needed
    
    %getKatrinaVarsFullTime; caseid = 'K';
    
    getIsabelVars; caseid = 'I';
    
    % reshape the data
    mslp = reshape(msl,size(msl,1)*size(msl,2),[])';
    
    % perform pca on the reshaped data
    [coeffp,scorep,latentp,tsquaredp,explainedp,mup] = pca(mslp);
    firstscorep = scorep(:,1);
end


%% Do the sliding ACF technique

% smooth and filter the firstscore data
bandwidth = 1;
smoothscore = gauss_smoother([time firstscorep], bandwidth);
filteredscore = firstscorep - smoothscore(:,2);
clear bandwidth

% use ACF on the firstscore and on the filtered firstscore
lag = 1;
windowSize = 100;
slidingACF = ACF_sliding(firstscorep, lag, windowSize, false);
filtered_slidingACF = ACF_sliding(filteredscore, lag, windowSize, false);


%% plot the figures
if caseid == 'K'
    skip = 200;
    endskip = 200;
    plot_title = 'Hurricane Katrina';
elseif caseid== 'I'
    skip = 300;
    endskip = 100;
    plot_title = 'Hurricane Isabel';
end

stringdates = datestr(time, 'dd-mmm');

ax1 = subplot(2,1,1);

title(plot_title)
hold on
plot(ax1, time(1+skip:end-endskip),...
    firstscorep(1+skip:end-endskip), 'color', 'b');
plot(ax1, time(1+skip:end-endskip),...
    smoothscore(1+skip:end-endskip,2), 'color', 'r');
ax1.XTick = time(1+skip:25:end-endskip);
ax1.XTickLabel = stringdates(1+skip:25:end-endskip,:);
ax1.XTickLabelRotation = 90;
ax1.Box  = 'on';
ax1.XLim = [time(1+skip) time(end-endskip)];
%ax1.YLim = [-120000, 25000];
ax1.XGrid = 'on';
%ax1.XTickLabel = [];
ax1.YLabel.String = 'msl pressure';

ax2 = subplot(2,1,2);
hold on
plot(ax2, time(1+skip:end-endskip),...
    slidingACF(1+skip:end-endskip), 'color', 'b');
plot(ax2, time(1+skip:end-endskip),...
    filtered_slidingACF(1+skip:end-endskip), 'color', 'r');
ax2.XTick = time(1+skip:25:end-endskip);
ax2.XTickLabel = [];
ax2.Box = 'on';
ax2.XLim = [time(1+skip) time(end-endskip)];
ax2.XGrid = 'on';
ax2.XLabel.String = 'time';
ax2.YLabel.String = 'ACF propagator';

hold off


