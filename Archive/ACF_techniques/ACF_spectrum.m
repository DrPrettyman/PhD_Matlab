function spectrum = ACF_spectrum(z)

N = size(z,1);

spectrum = zeros(floor(N/2),1);

for lag = 1:floor(N/2)
    spectrum(lag) = ACF(z, lag);
end

return