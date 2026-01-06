function slidingACF = ACF_sliding(data, lag, windowSize, showPlot)
%% ACF_SLIDING Compute autocorrelation in a sliding window
%
% Computes the autocorrelation coefficient at a given lag for each
% position in a sliding window across the time series.
%
% Syntax:
%     slidingACF = ACF_sliding(data, lag, windowSize)
%     slidingACF = ACF_sliding(data, lag, windowSize, showPlot)
%
% Inputs:
%     data       - Time series data, column vector [N x 1]
%     lag        - Lag at which to compute ACF (scalar)
%     windowSize - Size of the sliding window
%     showPlot   - If true, display plot of data and ACF (default: false)
%
% Outputs:
%     slidingACF - ACF values at each position [N x 1]
%                  First windowSize entries are zero (insufficient data)
%
% See also: ACF, DFA_sliding, PSE_sliding

    if nargin < 4 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    slidingACF = zeros(n, 1);

    for i = (windowSize + 1):n
        window = data((i - windowSize):i);
        slidingACF(i) = ACF(window, lag);
    end

    if showPlot
        figure
        yyaxis left
        plot(1:n, data)
        ylabel('Data')

        yyaxis right
        plot((windowSize+1):n, slidingACF((windowSize+1):n))
        ylabel(['ACF (lag=' num2str(lag) ')'])

        xlabel('Index')
    end
end