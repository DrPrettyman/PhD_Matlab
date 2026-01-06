function auto_corr = ACF(data, lag)
%% ACF Compute autocorrelation at a given lag
%
% Computes the sample autocorrelation coefficient of a time series
% at a specified lag.
%
% Syntax:
%     auto_corr = ACF(data, lag)
%
% Inputs:
%     data - Time series data, column vector [N x 1]
%     lag  - Lag at which to compute autocorrelation (scalar, lag < N)
%
% Outputs:
%     auto_corr - Autocorrelation coefficient at the specified lag
%
% Formula:
%     ACF(k) = E[(X_t - mu)(X_{t+k} - mu)] / Var(X)
%
% See also: ACF_sliding, ACF_scaling

    m = mean(data);
    n = size(data, 1);

    data1 = data(1:n-lag) - m;
    data2 = data(1+lag:n) - m;

    auto_corr = mean(data1 .* data2) / var(data);
end