function [pse_value, psdx, freq] = PSE_noBinning(Y, plotfigs)
%% PSE_NOBINNING Power Spectral Exponent without log-binning
%
% Computes the power spectral density and estimates the scaling exponent
% by fitting directly to the periodogram (no binning).
%
% Syntax:
%     [pse_value, psdx, freq] = PSE_noBinning(Y)
%     [pse_value, psdx, freq] = PSE_noBinning(Y, plotfigs)
%
% Inputs:
%     Y        - Time series data, column vector [N x 1]
%     plotfigs - If true, display log-log plot with fit (default: false)
%
% Outputs:
%     pse_value - Estimated power spectral exponent (negative slope)
%     psdx      - Power spectral density values
%     freq      - Corresponding frequency values
%
% Notes:
%     - Fits in frequency window [0.01, 0.1]
%     - For noisy data, consider using PSE_new with log-binning instead
%
% See also: PSE_new, PSE, PSE_sliding

    if nargin < 2 || isempty(plotfigs)
        plotfigs = false;
    end

    N = length(Y);
Fs=1;
xdft = fft(Y);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:Fs/N:Fs/2)';

logf = log10(freq);
logp = log10(psdx);
% disp([num2str(size(logf)), ' and ', num2str(size(logp))])
window_for_fit = find(freq<=(0.1) & freq>=(0.01));
pfit = polyfit(logf(window_for_fit), logp(window_for_fit), 1);
v = polyval(pfit, logf(window_for_fit));
pse_value = -pfit(1);

if plotfigs
    figure
    hold on
    
    window_for_plot = find(freq<=(0.316) & freq>=(0.0032));
    
    plot( logf(window_for_plot), logp(window_for_plot));
    plot( logf(window_for_fit), v, 'LineWidth', 3.5, 'Color', 'r');
    
    xlabel( 'log (F)'); ylabel( 'log(S)');
end

end

