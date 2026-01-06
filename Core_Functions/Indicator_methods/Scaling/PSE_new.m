function [pse_value, psdx, freq] = PSE_new(Y, plotfigs)
%% PSE_NEW Power Spectral Exponent with log-binning
%
% Computes the power spectral density and estimates the scaling exponent
% using log-binning for robust estimation.
%
% Syntax:
%     [pse_value, psdx, freq] = PSE_new(Y)
%     [pse_value, psdx, freq] = PSE_new(Y, plotfigs)
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
%     - Uses log-binning via logbin() for robust slope estimation
%     - Fits in frequency window [0.01, 0.1] (log10: [-2, -1])
%     - PSE ~ 0 for white noise, ~ 1 for 1/f noise, ~ 2 for Brownian
%
% See also: PSE, PSE_noBinning, PSE_sliding, logbin

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

windowlimits = [-2, -1];

[binnedLF, binnedLP] = logbin(logf, logp, windowlimits, false);

goodones = ~(isnan(binnedLF)+isnan(binnedLP));
binnedLF = binnedLF(goodones);
binnedLP = binnedLP(goodones);

pfit = polyfit(binnedLF, binnedLP, 1);
pse_value = -pfit(1);

if plotfigs
    figure
    hold on
    v = polyval(pfit, binnedLF);
    plot( binnedLF, binnedLP);
    plot( binnedLF, v, 'LineWidth', 3.5, 'Color', 'r');
    
    xlabel( 'log(F)'); ylabel( 'log(S)');
end

end



