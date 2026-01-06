function out = EOF_sliding_upto(X, windowSize, indicator, weights)
%% EOF_SLIDING_UPTO Compute indicator on cumulative EOF projection
%
% Projects multivariate data onto first EOF computed from all data up to
% current time, then applies a scaling indicator to a trailing window.
%
% Syntax:
%     out = EOF_sliding_upto(X, windowSize)
%     out = EOF_sliding_upto(X, windowSize, indicator)
%     out = EOF_sliding_upto(X, windowSize, indicator, weights)
%
% Inputs:
%     X          - Multivariate time series [N x p]
%     windowSize - Size of the trailing window for indicator computation
%     indicator  - Scaling indicator: 'PS', 'ACF1', or 'DFA' (default: 'PS')
%     weights    - Optional weights for EOF. If provided, non-dimensionalises
%
% Outputs:
%     out - Indicator values at each position [N x 1]
%
% Notes:
%     - EOF is recomputed at each step using all data from start to current
%     - Indicator is computed on trailing windowSize points of projection
%
% See also: EOF1, EOF_sliding, PSE_new, ACF, DFA_estimation

    if nargin < 4
        nondimensionalise = false;
        weights = [];
    else
        nondimensionalise = true;
    end

    if nargin < 3
        indicator = 'PS';
    end

    n = size(X, 1);
    out = zeros(n, 1);

    for i = (1 + windowSize):n
        window_eigen = X(1:i, :);
        [T, ~] = EOF1(window_eigen, nondimensionalise, weights);

        window = T((end - windowSize):end);
        if strcmp(indicator, 'PS')
            out(i) = PSE_new(window);
        elseif strcmp(indicator, 'ACF1')
            out(i) = ACF(window, 1);
        elseif strcmp(indicator, 'DFA')
            [~, alpha] = DFA_estimation(window, 2, false);
            out(i) = alpha;
        end
    end
end