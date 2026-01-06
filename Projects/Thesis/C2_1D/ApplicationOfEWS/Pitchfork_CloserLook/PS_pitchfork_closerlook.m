

%%
serieslen=10^5; % Length of each time series
no_parts = 30;  % We partition the interval [0,1] into (no_parts) parts
part_len = 0.1; % of length (part_len).
mu0 = 0.6; 
sigma = 1;      % The noise term in the AR(1) model
plotbeta = true;


p = @(mu)(log10(...
    (1+mu.^2-2*mu.*cos(0.2*pi))/(1+mu.^2-2*mu.*cos(0.02*pi))...
    ));
betaplotx = linspace(mu0,1,10^4)';
betaploty = zeros(10^4,1);
for i = 1:10^4; betaploty(i) = p(betaplotx(i)); end

part_midpoints = linspace(mu0+part_len/2, 1-part_len/2, no_parts);
part_endpoints = zeros(no_parts, 2);
for i = 1:no_parts
    part_endpoints(i,1) = part_midpoints(i) - part_len/2;
    part_endpoints(i,2) = part_midpoints(i) + part_len/2;
end 
clear i 

%%
mu_PS   = zeros(no_parts,1);
beta_PS = zeros(no_parts,1);
mu_ACF1 = zeros(no_parts,1);
for i = 1:no_parts
    disp([num2str(i),'/',num2str(no_parts),': Calculating mu_est for ',...
        'mu in [',num2str(part_endpoints(i,1)),',',...
        num2str(part_endpoints(i,2)),']'])
    AR = zeros(serieslen,1); % create an AR(1) time series with chaging mu
    mu_vals = linspace(part_endpoints(i,1),part_endpoints(i,2),serieslen)';
    for j = 2:serieslen
        AR(j) = mu_vals(j)*AR(j-1)+sigma*randn();
    end
    beta = PSE_new(AR);
    beta_PS(i) = beta;
    mu_PS(i)   = reconstruct_mu_func(beta);
    mu_ACF1(i) = ACF(AR,1);
end
clear i j beta AR mu_vals
disp(' ')

%% Nice plot
fig1 = figure; fig1.Units = 'centimeters'; fig1.Resize = 'off';
fig1.Position = [0,0,30,15];
fontsize = 18;
hold on
pos1 = [0.07 0.15 0.40 0.80];
pos2 = pos1 + [0.52 0 0 0];
xlimits = [mu0,1];

ax1 = subplot('Position',pos1);
hold on
if plotbeta
    plot(ax1,betaplotx,betaploty, 'Color', 0.7*[1,1,1], 'LineWidth',2)
    ylimits = [p(mu0),2];
else
    plot(ax1,[mu0,1],[mu0,1], 'Color', 0.7*[1,1,1], 'LineWidth',2)
end
for i = 1:no_parts
    x1 = part_endpoints(i,1);
    x2 = part_endpoints(i,2);
    if plotbeta
        y = beta_PS(i);
    else
        y = mu_PS(i);
    end
    plot(ax1,[x1,x2],[y,y], 'Color', 'k', 'LineWidth',2)
    plot(ax1,[(x1+x2)/2],[y], 'Color', 'k', 'LineWidth',2,...
        'LineStyle','none','Marker','o','MarkerSize',10)
end
clear x1 x2 y i
ylim(ylimits)
xlim(xlimits)
xlabel('AR(1) model parameter \mu')
if plotbeta
    ylabel('PS exponent \beta')
else
    ylabel('estimated value \mu')
end
ann1 = annotation('textbox',...
    pos1 + [0.02 0 0 -0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
% annotation_string = '(PS method)';
% ann2 = annotation('textbox',...
%     pos1 + [0.05 0 0 0],...
%     'String',annotation_string,...
%     'FontSize', 20',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

ax2 = subplot('Position',pos2);
ylimits = [mu0,1];
hold on
plot(ax2,[mu0,1],[mu0,1], 'Color', 0.7*[1,1,1], 'LineWidth',2)
for i = 1:no_parts
    x1 = part_endpoints(i,1);
    x2 = part_endpoints(i,2);
    y  = mu_ACF1(i);
    plot(ax2,[x1,x2],[y,y], 'Color', 'k', 'LineWidth',2)
    plot(ax2,[(x1+x2)/2],[y], 'Color', 'k', 'LineWidth',2,...
        'LineStyle','none','Marker','o','MarkerSize',10)
end
clear x1 x2 y i
ylim(ylimits)
xlim(xlimits)
xlabel('AR(1) model parameter \mu')
ylabel('lag-1 ACF')
ann1 = annotation('textbox',...
    pos2 + [0.02 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
% annotation_string = '(ACF1 method)';
% ann2 = annotation('textbox',...
%     pos2 + [0.05 0 0 0],...
%     'String',annotation_string,...
%     'FontSize', 20',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

clear ann1 ann2 pos1 pos2 ax1 ax2 annotation_string
clear fontsize ylimits xlimits 