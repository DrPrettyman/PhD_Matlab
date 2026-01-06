function [DFApoints, alpha] = DFA_estimation(data, order, gauss, showPlot)
%% DFA_ESTIMATION Estimate DFA scaling exponent
%
% Computes the DFA fluctuation function F(s) at multiple scales and
% estimates the scaling exponent alpha from the log-log slope.
%
% Syntax:
%     [DFApoints, alpha] = DFA_estimation(data, order, gauss)
%     [DFApoints, alpha] = DFA_estimation(data, order, gauss, showPlot)
%
% Inputs:
%     data     - Time series data, column vector [N x 1]
%     order    - Polynomial order for detrending (typically 1 or 2)
%     gauss    - If true, use Gaussian-weighted DFA variant (default: false)
%     showPlot - If true, display log-log plot with fit (default: false)
%
% Outputs:
%     DFApoints - Matrix [N_s x 2] of (scale, F(scale)) pairs
%     alpha     - Estimated scaling exponent
%
% Notes:
%     - Uses logarithmically spaced scales from 10 to N/4
%     - Alpha ~ 0.5 for white noise, ~ 1 for 1/f noise, ~ 1.5 for Brownian
%
% See also: DFA, DFA_sliding

    if nargin < 4 || isempty(showPlot)
        showPlot = false;
    end

    % Define scale range (logarithmically spaced)
    s_min = 10;
    s_max = floor(size(data, 1) / 4);
    N_s = 6;

    s = floor(10.^(linspace(log10(s_min), log10(s_max), N_s+2)'));
    F = zeros(size(s, 1), 1);

    % Compute F(s) at each scale
    for i = 1:size(F, 1)
        if gauss
            F(i) = DFA_gauss(data, s(i), order);
        else
            F(i) = DFA(data, s(i), order);
        end
        F(i) = F(i) / sqrt(s(i));  % Kantelhardt scaling
    end

    DFApoints = [s, F];

    % Estimate alpha from log-log slope
    linearfit = polyfit(log10(s), log10(F), 1);
    alpha = linearfit(1) + 0.5;

    if showPlot
        figure
        loglog(s, F, '-o', 'DisplayName', 'DFA')
        hold on
        fit_line = 10^linearfit(2) * s.^linearfit(1);
        loglog(s, fit_line, 'r-', 'LineWidth', 1.5, ...
               'DisplayName', ['\alpha = ' num2str(alpha, '%.2f')])
        xlabel('Scale s')
        ylabel('F(s)')
        legend('Location', 'best')
        hold off
    end
end