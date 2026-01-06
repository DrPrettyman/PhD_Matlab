function slidingSEX = SEX_sliding(data, windowSize, detrend, showPlot)
%% SEX_SLIDING Sliding window scaling exponent via power spectrum
%
% See also: scalingexp, PSE_sliding

    if nargin < 4 || isempty(showPlot)
        showPlot = false;
    end

    n = size(data, 1);
    slidingSEX = zeros(n, 1);

    for i = (1 + windowSize):n
        window = data((i - windowSize):i);
        slidingSEX(i) = scalingexp(window);
    end

    if showPlot
        figure
        yyaxis left
        plot(1:n, data)
        ylabel('Data')

        yyaxis right
        plot((windowSize+1):n, slidingSEX((windowSize+1):n))
        ylabel('Scaling Exponent')
        xlabel('Index')
    end
end