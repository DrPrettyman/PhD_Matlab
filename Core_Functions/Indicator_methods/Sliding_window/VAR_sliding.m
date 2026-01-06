function slidingVAR = VAR_sliding(data, windowSize, showPlot)
%% VAR_SLIDING Compute variance in a sliding window
%
% Computes the variance for each position in a sliding window
% across the time series. Rising variance is a common early warning
% signal for critical transitions.
%
% Syntax:
%     slidingVAR = VAR_sliding(data, windowSize)
%     slidingVAR = VAR_sliding(data, windowSize, showPlot)
%
% Inputs:
%     data       - Time series data, column vector [N x 1]
%     windowSize - Size of the sliding window
%     showPlot   - If true, display plot (default: false)
%
% Outputs:
%     slidingVAR - Variance values at each position [N x 1]
%                  First windowSize entries are zero (insufficient data)
%
% See also: ACF_sliding, DFA_sliding, PSE_sliding

    if nargin < 3 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    slidingVAR = zeros(n, 1);

    for i = (windowSize + 1):n
        window = data((i - windowSize):i);
        slidingVAR(i) = var(window);
    end

    if showPlot
        figure
        yyaxis left
        plot(1:n, data)
        ylabel('Data')

        yyaxis right
        plot((windowSize+1):n, slidingVAR((windowSize+1):n))
        ylabel('Variance')

        xlabel('Index')
    end
end