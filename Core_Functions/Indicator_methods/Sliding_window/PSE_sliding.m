function slidingPSE = PSE_sliding(data, windowSize, showPlot)
%% PSE_SLIDING Compute power spectrum scaling exponent in a sliding window
%
% Computes the scaling exponent from the power spectrum slope for each
% position in a sliding window across the time series.
%
% Syntax:
%     slidingPSE = PSE_sliding(data, windowSize)
%     slidingPSE = PSE_sliding(data, windowSize, showPlot)
%
% Inputs:
%     data       - Time series data, column vector [N x 1]
%     windowSize - Size of the sliding window
%     showPlot   - If true, display plot of data and PSE (default: false)
%
% Outputs:
%     slidingPSE - Scaling exponent values at each position [N x 1]
%                  First windowSize entries are zero (insufficient data)
%
% See also: PSE, PSE_new, ACF_sliding, DFA_sliding

    if nargin < 3 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    slidingPSE = zeros(n, 1);

    for i = (windowSize + 1):n
        window = data((i - windowSize):i);
        slidingPSE(i) = PSE_new(window);
    end

    if showPlot
        figure
        yyaxis left
        plot(1:n, data)
        ylabel('Data')

        yyaxis right
        plot((windowSize+1):n, slidingPSE((windowSize+1):n))
        ylabel('Scaling exponent')

        xlabel('Index')
    end
end