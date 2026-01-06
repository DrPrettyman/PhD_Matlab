Sx = @(f,c)(...
    (1)/(1+c^2-2*c*cos(2*pi*f))...
    );

PSGrad = @(f,c)(...
    (4*pi*c*f*sin(2*pi*f))/...
    (1+c^2-2*c*cos(2*pi*f))...
    );

%%

N = 10^5;

no_c_vals = 6;
c_values = linspace(0.5,1,no_c_vals);

c_values = [0.7, 0.8, 0.999];
no_c_vals = size(c_values,2);

f = linspace(1/N, 0.5, N);
power_spectrum = zeros(N,no_c_vals);
power_spectrum_grad = zeros(N,no_c_vals);

power_spectrum_c0 = zeros(N,1);
power_spectrum_grad_c0 = zeros(N,1);
c0 = 0.9;

for k = 1:no_c_vals
    for j = 1:N
        power_spectrum(j,k) = Sx(f(j), c_values(k));
        power_spectrum_grad(j,k) = PSGrad(f(j), c_values(k));
    end
end

for j = 1:N
    power_spectrum_c0(j) = Sx(f(j), c0);
    power_spectrum_grad_c0(j) = PSGrad(f(j), c0);
end
%%


fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,40,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.05 0.12 0.42 0.85];
pos2 = pos1 + [0.52 0 0 0];

ax1 = subplot('Position',pos1);
hold on
legend('AutoUpdate', 'off')
ylimits1 = [-1,4];
p = zeros(no_c_vals+1,1);
plot([-1, -1], ylimits1, 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
plot([-2, -2], ylimits1, 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
legend off
for k = 1:no_c_vals
    legendtext = ['\mu = ', num2str(c_values(k))];
    p(k) = plot(ax1, log10(f), log10(power_spectrum(:,k)),...
    'LineWidth', 1, 'LineStyle', '-.',...
    'DisplayName', legendtext);
end
legendtext_c0 = ['\mu = ', num2str(c0)];
p(end) = plot(ax1, log10(f), log10(power_spectrum_c0),...
    'LineWidth', 2.3, 'color', 'k', 'LineStyle', '-',...
    'DisplayName', legendtext_c0);
legend([p(1), p(2), p(4), p(3)])
ylim(ylimits1)
xlim([-3.4, log10(0.5)])
ylabel('$\log[S_x(f)]$', 'Interpreter', 'latex')
xlabel('$\log[f]$', 'Interpreter', 'latex')
ann = annotation('textbox',...
    pos1 + [0.02 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

ax2 = subplot('Position',pos2);
hold on
ylimits2 = [-0.2,2.2];
plot([-1, -1], ylimits2, 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
plot([-2, -2], ylimits2, 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
for k = 1:no_c_vals
    legendtext = ['\mu = ', num2str(c_values(k))];
    p(k) = plot(ax2, log10(f), power_spectrum_grad(:,k),...
    'LineWidth', 1, 'LineStyle', '-.',...
    'DisplayName', legendtext);
end
legendtext_c0 = ['\mu = ', num2str(c0)];
p(end) = plot(ax2, log10(f), power_spectrum_grad_c0,...
    'LineWidth', 2.3, 'color', 'k', 'LineStyle', '-',...
    'DisplayName', legendtext_c0);
%legend([p(1), p(2), p(4), p(3)])

ylim(ylimits2)
xlim([-3.4, log10(0.5)])

%title('Powet spectrum $S_x(f)$ --- loglog plot', 'Interpreter', 'latex')
ylabel('PS indicator, $B_f(\mu)$', 'Interpreter', 'latex')
xlabel('$\log[f]$', 'Interpreter', 'latex')

ann = annotation('textbox',...
    pos2 + [0.02 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','YAxisLocation','left',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')








%% Changing mu, several differnt values of f.

N = 10^5;
mu_values = linspace(0,1,N)';

logf_values  = [-2.5, -2, -1.5, -1, -0.5];
no_logf_values = size(logf_values,2);

power_spectrum_gradient_fmu = zeros(N,size(logf_values,2));

for k = 1:no_logf_values
    f_fixed = 10^logf_values(k);
    for j = 1:N
        power_spectrum_gradient_fmu(j,k) =...
            PSGrad(f_fixed, mu_values(j));
    end
end

%%
fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,40,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.05 0.12 0.42 0.85];


legendtext = ['$\log f = $ ', num2str(logf_values(1))];
plot(mu_values, power_spectrum_gradient_fmu(:,1),...
    'LineWidth', 2, 'color', 'r',...
    'DisplayName', legendtext);

for k = 2:4
    legendtext = ['$\log f = $ ', num2str(logf_values(k))];
    plot(mu_values, power_spectrum_gradient_fmu(:,k),...
        'LineWidth', 2,...
    'DisplayName', legendtext);
end

legendtext = ['$\log f = $ ', num2str(logf_values(end))];
plot(mu_values, power_spectrum_gradient_fmu(:,5),...
    'LineWidth', 2, 'color', 'b',...
    'DisplayName', legendtext);

%title(['PS gradient for log(f) = ',num2str(logf_fixed)])
xlabel('$\mu$', 'Interpreter', 'latex')
ylabel('PS indicator, $B_f(\mu)$', 'Interpreter', 'latex')

legend({},'Location', 'northwest','Interpreter','latex')

set(gca,'YGrid','on','XGrid','on','YAxisLocation','left',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')


%% How many data are in each frequency range?

serieslengths = [10^8 ; 10^9 ; 10^8];

f_ranges = [-3.5 -2.5; -3 -2; -2.5 -1.5; -2 -1; -1.5 -0.5];

no_data_points = zeros(5, 3);

for i = 1:3
    Y = randn(serieslengths(i),1);
    
    N = length(Y);
    Fs=1;
    xdft = fft(Y);
    xdft = xdft(1:floor(N/2)+1);
    psdx = (1/(Fs*N)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = (0:Fs/N:Fs/2)';

    logf = log10(freq);
    logp = log10(psdx);
    
    for k = 1:5
        
        f0 = f_ranges(k, 1);
        f1 = f_ranges(k, 2);
        
        no_data_points(k,i) = size(find(logf>=f0 & logf<=f1),1);
        
    end
    
end

T = table(f_ranges,...
    no_data_points(:,1), no_data_points(:,2),no_data_points(:,3));

%%

M = 100;
logN_values = linspace(1,6,M);
N_values = zeros(M,1);
no_data_in_range = zeros(M,1);
f0 = -2;
f1 = -1;
for i = 1:M
    N = floor(10^logN_values(i));
    N_values(i) = N;
    Y = randn(N,1);
    N = length(Y);
    Fs=1;
    xdft = fft(Y);
    xdft = xdft(1:floor(N/2)+1);
    psdx = (1/(Fs*N)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = (0:Fs/N:Fs/2)';
    logf = log10(freq);
    logp = log10(psdx);
    no_data_in_range(i) =...
        size(find(logf>=f0 & logf<=f1),1);
end
plot(log10(N_values), no_data_in_range./N_values)
