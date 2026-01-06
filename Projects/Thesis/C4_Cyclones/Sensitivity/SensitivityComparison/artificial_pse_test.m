%% create artificial data 

alpha = 0.25;
n = 100000;
white = rand(2*n+2,1);

freq = 1./(1:2*n+2)';
white_ps = fft(white);

%figure
%loglog(freq , abs(white_ps).^2)

alpha_ps = white_ps.*(1./(1:2*n+2)'.^alpha);

figure
loglog(freq , abs(alpha_ps).^2)

inverse_fourier = ifft(alpha_ps);
alpha_noise = abs(inverse_fourier(2:floor(end/2)));

figure
plot(alpha_noise)

pse = PSE_homemade(alpha_noise(1:10:end), true)
acf = ACF(alpha_noise(1:10:end), 1)

alpha_vals = (0:0.1:2)';
pse_vals = zeros(size(alpha_vals));
acf_vals = zeros(size(alpha_vals));

for i = 1:size(alpha_vals,1)
    alpha = alpha_vals(i);
    n = 10000;
    white = rand(2*n+2,1);
    freq = 1./(1:2*n+2)'; 
    white_ps = fft(white);
    alpha_ps = white_ps.*(1./(1:2*n+2)'.^alpha);
    inverse_fourier = ifft(alpha_ps);
    alpha_noise = abs(inverse_fourier(2:floor(end/2)));

    pse_vals(i) = -PSE_homemade(alpha_noise);
    acf_vals(i) = ACF(alpha_noise,1);
end

figure
plot(alpha_vals, pse_vals, alpha_vals,  acf_vals)
