alpha_vals = (0:0.05:3)';
pse_vals = zeros(size(alpha_vals));
acf_vals = zeros(size(alpha_vals));

N = 10000;

for i = 1:size(alpha_vals,1)
    
    alpha = alpha_vals(i);
    
    samplesize = 30;
    pse_temp = zeros(samplesize,1);
    acf_temp = zeros(samplesize,1);
    for k = 1:samplesize
        alpha_noise = noise_generator(N, alpha)';
        pse_temp(k) = PSE_new(alpha_noise);
        acf_temp(k) = ACF(alpha_noise,1);
    end
    pse_vals(i) = mean(pse_temp);
    acf_vals(i) = mean(acf_temp);
end

figure
plot(alpha_vals, pse_vals, alpha_vals,  acf_vals)

alpha = 1.5;
severalseries = zeros(N, 100);
for i = 1:100
    severalseries(:,i) = noise_generator(N, alpha)';
end
meanseries = mean(severalseries,1);
figure
plot(meanseries)
PSE_new(meanseries')