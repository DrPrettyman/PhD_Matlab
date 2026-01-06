function [White, Red] = seasonal(length, sigma, plot_data, deseasonalise)

t = 0:(length-1);
X = sin(t*(2*pi/365));

White = X + sigma .* randn(1,length);
Red = X + cumsum(sigma .* randn(1,length));

if plot_data == true
    figure
    plot(White)
    title('Anual wave with White noise')
    pause(2)

    figure
    plot(Red)
    title('Anual wave with red noise')
    pause(2)
end

if deseasonalise == true
    White = White - X;
    Red = Red - X;
    
    figure
    plot(White)
    title('White noise')
    pause(2)

    figure
    plot(Red)
    title('Red noise')
    pause(2)
end

return