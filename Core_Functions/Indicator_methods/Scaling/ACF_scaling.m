function ACFS = ACF_scaling(x, plotFig)
%% ACF_SCALING Estimate ACF decay exponent from log-log slope
%
% Computes autocorrelation at multiple lags and estimates the power-law
% decay exponent from the log-log slope.
%
% Syntax:
%     ACFS = ACF_scaling(x)
%     ACFS = ACF_scaling(x, plotFig)
%
% Inputs:
%     x       - Time series data, column vector [N x 1]
%     plotFig - If true, display log-log plot with fit (default: false)
%
% Outputs:
%     ACFS - ACF scaling exponent (negative of log-log slope)
%
% Notes:
%     - Computes ACF at lags 1 to 100
%     - Fits slope for lags >= 10 to avoid short-lag artifacts
%     - Small ACF values (<0.01) are floored to avoid log(0) issues
%
% See also: ACF, ACF_sliding

    if nargin < 2
        plotFig = false;
    end

    lags = (1:100)';
    nlags = length(lags);
    coefs = zeros(nlags, 1);

    for k = 1:nlags
        coefs(k) = ACF(x, lags(k));
        if coefs(k) < 0.01
            coefs(k) = 0.01;  % Floor to avoid log(0)
        end
    end

    loglags = log10(lags);
    logcoefs = log10(coefs);

    window = lags >= 10;
    pfit = polyfit(loglags(window), logcoefs(window), 1);
    ACFS = -pfit(1);

    if plotFig
        figure
        hold on
        plot(loglags, logcoefs)
        v = polyval(pfit, [1, 2]);
        plot([1, 2], v, 'LineWidth', 3.5, 'Color', 'r')
        xlabel('log_{10}(lag)')
        ylabel('log_{10}(ACF)')
        hold off
    end
end

