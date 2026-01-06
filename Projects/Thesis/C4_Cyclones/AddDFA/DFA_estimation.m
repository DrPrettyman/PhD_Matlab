function [DFApoints, alpha] = DFA_estimation(data, order, gauss, showPlot)
%% DFA_ESTIMATION Estimate DFA scaling exponent (project-specific version)
%
% NOTE: Consider using Core_Functions/Indicator_methods/Scaling/DFA_estimation.m
%
% See also: DFA, DFA_sliding

    if nargin < 4 || isempty(showPlot)
        showPlot = false;
    end

    s_min = 10;
    s_max = floor(size(data, 1) / 4);
    N_s = 6;

    s = floor(10.^(linspace(log10(s_min), log10(s_max), N_s + 2)'));
    F = zeros(size(s, 1), 1);

    for i = 1:size(F, 1)
        if gauss
            F(i) = DFA_gauss(data, s(i), order);
        else
            F(i) = DFA(data, s(i), order);
        end
        F(i) = F(i) / sqrt(s(i));  % Kantelhardt scaling
    end

    DFApoints = [s, F];
    linearfit = polyfit(log(s), log(F), 1);
    alpha = linearfit(1) + 0.5;

    if showPlot
        fit_line = exp(linearfit(2)) * s.^alpha;
        figure
        loglog(s, F, '-o')
        hold on
        loglog(s, fit_line)
        hold off
    end
end