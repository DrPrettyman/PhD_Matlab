%%

% create red noise 'z' and white noise 'eta'
N = 10^5;
z = zeros(N,1);
t = linspace(0,1,N)';
for i = 2:N
    z(i) = z(i-1) + randn();
end
z = 10*z./std(z);
eta = randn(N,1);

% calculate DFA
s_min = 8;
s_max = 120;
N_s = 20;
 
s = floor( 10.^(...
    ( log10(s_min):...
    ((log10(s_max)-log10(s_min))/(N_s+1)):...
    log10(s_max) )'...
    ) );

F_red = zeros(numel(s),1);
F_eta = zeros(numel(s),1);
for i = 1:numel(s)
    s(i)
    F_red(i) = DFA(z,   s(i), 2);
    F_eta(i) = DFA(eta, s(i), 2);
end

%%
log_s = log10(s);
log_F_red = log10(F_red);
log_F_eta = log10(F_eta);

win = find(s>=10 & s<=100);

linearfit_red = polyfit(log_s(win),log_F_red(win),1);
linearfit_eta = polyfit(log_s(win),log_F_eta(win),1);

v_red = polyval(linearfit_red, log_s(win));
v_eta = polyval(linearfit_eta, log_s(win));
%% plot the figure

col_red = 0*[1,1,1];
col_eta = 0.5*[1,1,1];

fig1 = figure;
fig1.Units = 'centimeters';
w=44; h=14;
fig1.Position = [0,15,w,h];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 0.2;
hold on

plotw = (0.85*h)/w;
pos1 = [0.05 0.13 plotw 0.85];
pos2 = pos1 + [plotw+0.1 0 0 0];
pos3 = pos2 + [plotw+0.02 0 0 0];

ax1 = subplot('Position',pos1)
hold on
plot(ax1, t, eta,...
    'Color',col_eta,'LineWidth', linethickness)
plot(ax1, t, z,...
    'Color',col_red,'LineWidth', linethickness)

ylabel({'$z(t)$'},'Interpreter','latex')
xlabel({'$t$'},'Interpreter','latex')
% xlim([-(24*10),0]);
% ylim([1015.8, 1020.8]);
% xticks(-480:48:0)
% yticks(1016:1021)
legend('white noise', 'red noise')
ann = annotation('textbox',...
    pos1 + [0.02 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%xticklabels([]);
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

powerlimits = [0,0];
powerlimits(1) = min(min(log_F_red),min(log_F_eta));
powerlimits(2) = max(max(log_F_red),max(log_F_eta));
ax2 = subplot('Position',pos2)
hold on
plot(ax2, log_s, log_F_red,...
    'Color',col_red,'LineWidth', 2, 'Marker','o')
plot(ax2, log_s(win), v_red,...
    'Color','r','LineWidth', 2, 'LineStyle', '--')
ylim(powerlimits);
ylabel({'DFA coefficient: $\log F(s)$'},'Interpreter','latex')
xlabel({'Segment size: $\log(s)$'},'Interpreter','latex')
% xticks([1/24 1/12 1/8 1/6 1/4 1/3 1/2])
% xticklabels([24 12 8 6 4 3 2]);
% xlim([1/120, 1/5]);
% yticklabels([]);
% ylim([0.88,0.98]);
ann = annotation('textbox',...
    pos2 + [0.03 -0.03 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

ax3 = subplot('Position',pos3)
hold on
plot(ax3, log_s, log_F_eta,...
    'Color',col_eta,'LineWidth', 2, 'Marker','o')
plot(ax3, log_s(win), v_eta,...
    'Color','r','LineWidth', 2, 'LineStyle', '--')

ylim(powerlimits);

xlabel({'Segment size: $\log(s)$'},'Interpreter','latex')
yticklabels([]);
ann = annotation('textbox',...
    pos3 + [0.03 -0.03 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
