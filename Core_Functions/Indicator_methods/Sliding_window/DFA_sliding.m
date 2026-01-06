function [slidingDFA, indices] = DFA_sliding(data, order, windowSize, showPlot)
%% DFA_SLIDING Compute DFA scaling exponent in a sliding window
%
% Computes the DFA scaling exponent (alpha) for each position in a
% sliding window across the time series.
%
% Syntax:
%     slidingDFA = DFA_sliding(data, order, windowSize)
%     [slidingDFA, indices] = DFA_sliding(data, order, windowSize, showPlot)
%
% Inputs:
%     data       - Time series data, column vector [N x 1]
%     order      - Polynomial order for detrending (typically 1 or 2)
%     windowSize - Size of the sliding window
%     showPlot   - If true, display plot (default: false)
%
% Outputs:
%     slidingDFA - DFA exponent values at each window position
%     indices    - Indices corresponding to each DFA value
%
% Notes:
%     - Alpha ~ 0.5 for uncorrelated noise
%     - Alpha > 0.5 indicates long-range positive correlations
%     - Alpha < 0.5 indicates anti-correlations
%
% See also: DFA, DFA_estimation, ACF_sliding, PSE_sliding

    if nargin < 4 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    indices = (windowSize:n)';
    slidingDFA = zeros(size(indices, 1), 1);

    for i = 1:size(indices, 1)
        window = data((indices(i) - windowSize + 1):indices(i));
        [~, alpha] = DFA_estimation(window, order, false);
        slidingDFA(i) = alpha;
    end

    if showPlot
        figure

        subplot(2, 1, 1)
        plot(indices, slidingDFA, 'r-')
        ylabel('DFA exponent \alpha')
        xlabel('Index')

        subplot(2, 1, 2)
        plot(1:n, data)
        ylabel('Data')
        xlabel('Index')
    end
end