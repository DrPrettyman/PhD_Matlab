/'.;─ µphi_vals = (0:0.01:1)';
pse_vals = zeros(size(phi_vals));
acf_vals = zeros(size(phi_vals));

N = 10000;

for i = 1:size(phi_vals,1)
    
    phi = [phi_vals(i)];
    
    samplesize = 50;
    pse_temp = zeros(samplesize,1);
    acf_temp = zeros(samplesize,1);
    for k = 1:samplesize
        AR1_phi = ARp(phi, N);
        pse_temp(k) = PSE_new(AR1_phi);
        acf_temp(k) = ACF(AR1_phi, 1);
    end
    pse_vals(i) = mean(pse_temp);
    acf_vals(i) = mean(acf_temp);
end

clear xlabel ylabel
figure
plot(phi_vals, pse_vals, phi_vals,  acf_vals)
xlabel('phi value');
ylabel('Indicator value');