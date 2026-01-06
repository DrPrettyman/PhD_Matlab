function slidingACF = sliding_ACF1_RO(data, windowSize, showPlot)
%% SLIDING_ACF1_RO Sliding ACF(lag=1) with oscillation removal
%
% Computes sliding ACF after removing 12-period oscillations from each window.
%
% See also: ACF_sliding, remove_oscilations

    if nargin < 3 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    slidingACF = zeros(n, 1);

    for i = (1 + windowSize):n
        window = data((i - windowSize):i);
        window = remove_oscilations(window, 12);
        slidingACF(i) = ACF(window, 1);
    end

    if showPlot
        figure
        yyaxis left
        plot(1:n, data)
        ylabel('Data')

        yyaxis right
        plot((windowSize+1):n, slidingACF((windowSize+1):n))
        ylabel('ACF(1)')
        xlabel('Index')
    end
end

