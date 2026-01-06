function Y = gauss_smoother(X, bandwidth, showPlot)
%% GAUSS_SMOOTHER Gaussian kernel smoother for 2D data
%
% Applies a Gaussian kernel smoother to smooth noisy data.
% Uses Nadaraya-Watson kernel regression.
%
% Syntax:
%     Y = gauss_smoother(X, bandwidth)
%     Y = gauss_smoother(X, bandwidth, showPlot)
%
% Inputs:
%     X         - Input data [N x 2], where X(:,1) is x-values, X(:,2) is y-values
%     bandwidth - Bandwidth parameter for Gaussian kernel (controls smoothness)
%     showPlot  - If true, display plot of original and smoothed data (default: false)
%
% Outputs:
%     Y - Smoothed data [N x 2], same x-values with smoothed y-values
%
% Notes:
%     - Larger bandwidth = smoother result
%     - Smaller bandwidth = more local detail preserved

    if nargin < 3 || isempty(showPlot)
        showPlot = false;
    end

    xout = X(:,1);
    yout = zeros(size(xout));

    % Gaussian kernel function
    gaussian_kernel = @(x, xi) exp(-(x - xi).^2 / (2 * bandwidth^2));

    % Apply kernel smoothing at each point
    for i = 1:size(xout, 1)
        K = gaussian_kernel(xout(i), X(:,1));
        yout(i) = sum(K .* X(:,2)) / sum(K);
    end

    Y = [xout, yout];

    if showPlot
        figure
        hold on
        plot(X(:,1), X(:,2), '.', 'DisplayName', 'Original')
        plot(xout, yout, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Smoothed')
        legend('Location', 'best')
        hold off
    end
end
