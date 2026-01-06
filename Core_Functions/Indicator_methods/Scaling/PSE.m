function pse_value = PSE(Y, plotfigs)
%% PSE Power Spectrum Scaling Exponent
%
% Estimates the scaling exponent (beta) from the power spectrum slope.
% For a signal with power spectrum S(f) ~ f^(-beta), this returns beta.
%
% Syntax:
%     pse_value = PSE(Y)
%     pse_value = PSE(Y, plotfigs)
%
% Inputs:
%     Y        - Time series data, column vector [N x 1]
%     plotfigs - If true, display diagnostic plots (default: false)
%
% Outputs:
%     pse_value - Estimated scaling exponent (slope of log-log spectrum)
%
% Notes:
%     - Uses periodogram for spectrum estimation
%     - Fits in frequency range [0.01, 0.1]
%     - Beta ~ 0 for white noise, ~1 for 1/f noise, ~2 for Brownian motion
%
% See also: PSE_sliding, PSE_new

    if nargin < 2 || isempty(plotfigs)
        plotfigs = false;
    end

    % Compute power spectrum using periodogram
    [pxx, f] = periodogram(Y, [], [], 1);

    % Remove zero frequency component
    f = f(2:end);
    pxx = pxx(2:end);
    logf = log10(f);
    logp = log10(pxx);

    % Fit line in log-log space within specified frequency range
    window_for_fit = (f <= 0.1) & (f >= 0.01);
    pfit = polyfit(logf(window_for_fit), logp(window_for_fit), 1);
    pse_value = pfit(1);

    if plotfigs
        figure
        ax1 = subplot(1,2,1);
        ax2 = subplot(1,2,2);

        loglog(ax1, f, pxx)
        xlabel(ax1, 'Frequency');
        ylabel(ax1, 'Spectral power');

        hold(ax2, 'on')
        plot(ax2, logf, logp)
        v = polyval(pfit, logf(window_for_fit));
        plot(ax2, logf(window_for_fit), v, 'LineWidth', 1.5, 'Color', 'r')
        xlabel(ax2, 'log(f)');
        ylabel(ax2, 'log(S)');
    end
end
