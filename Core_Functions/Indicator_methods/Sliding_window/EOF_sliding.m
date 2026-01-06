function out = EOF_sliding(X, windowSize, indicator, weights)
%% EOF_SLIDING Compute indicator on EOF projection in sliding window
%
% Projects multivariate data onto first EOF within a sliding window and
% computes a scaling indicator (PSE, ACF, or DFA) on the projection.
%
% Syntax:
%     out = EOF_sliding(X, windowSize)
%     out = EOF_sliding(X, windowSize, indicator)
%     out = EOF_sliding(X, windowSize, indicator, weights)
%
% Inputs:
%     X          - Multivariate time series [N x p]
%     windowSize - Size of the sliding window
%     indicator  - Scaling indicator: 'PS', 'ACF1', or 'DFA' (default: 'PS')
%     weights    - Optional weights for EOF. If provided, non-dimensionalises
%
% Outputs:
%     out - Indicator values at each position [N x 1]
%
% See also: EOF1, EOF_sliding_upto, PSE_new, ACF, DFA_estimation

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
        window = X((i - windowSize):i, :);
        [T, ~] = EOF1(window, nondimensionalise, weights);

        if strcmp(indicator, 'PS')
            out(i) = PSE_new(T);
        elseif strcmp(indicator, 'ACF1')
            out(i) = ACF(T, 1);
        elseif strcmp(indicator, 'DFA')
            [~, alpha] = DFA_estimation(T, 2, false);
            out(i) = alpha;
        end
    end
end