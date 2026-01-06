%load('dsp_method_comp_data.mat')
%load('ar1_method_comp_data.mat')

colours = linspace(0,1,20);

figure
hold on

for k = 1:4
    errorbar(colours, means(:,k), errors(:,k))
end
legend('ACF', 'ACF(1)', 'DFA', 'PS')