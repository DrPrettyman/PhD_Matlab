function S = mannkendall(X)
%% MANNKENDALL Compute the Mann-Kendall trend statistic
%
% Computes the normalized Mann-Kendall statistic to test for monotonic
% trends in time series data.
%
% Syntax:
%     S = mannkendall(X)
%
% Inputs:
%     X - Time series data, column vector [N x 1]
%
% Outputs:
%     S - Normalized Mann-Kendall statistic, range [-1, 1]
%         S > 0 indicates increasing trend
%         S < 0 indicates decreasing trend
%         S ~ 0 indicates no trend
%
% Notes:
%     - Non-parametric test, does not assume normal distribution
%     - Robust to outliers
%     - Values close to +1 or -1 indicate strong monotonic trend
%
% Reference:
%     Mann (1945), Kendall (1975)

    N = size(X, 1);
    S = 0;

    % Count concordant minus discordant pairs
    for i = 1:(N-1)
        for j = (i+1):N
            S = S + sign(X(j) - X(i));
        end
    end

    % Normalize by maximum possible value
    S = S / (N * (N-1) / 2);
end

