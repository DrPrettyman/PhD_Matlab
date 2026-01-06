
mu = 2;
sigma = 2;
x_0 = [0; 0];

F = @(t,r)([(0.05*t-2.9)*r(1) - r(1)^3 + randn(1,1)*sigma;...
    1 + r(1)^2 + randn(1,1)*sigma]);


%%
options=odeset('AbsTol', 10^(-5));
[tout,rout]=ode45(F,...
    (0:0.01:100),x_0,options);

%%
t_crit = find(tout>=58,1);

Mu = 0.05*tout-2.9;
traj = sqrt(Mu);
traj(Mu<0) = 0;

xout = zeros(size(rout));
xout(:,1) = rout(:,1).*cos(rout(:,2));
xout(:,2) = rout(:,1).*sin(rout(:,2));


%%

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,40,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.3;
hold on

pos1 = [0.05 0.15 0.3 0.80];
pos2 = pos1 + [0.4 0 0.2 0];

ax1 = subplot('Position',pos1);
hold on

plot(xout(:,1), xout(:,2),...
    'Color','k','LineWidth', linethickness,'LineStyle', '-')
plot(xout(t_crit,1), xout(t_crit,2), 'o',...
    'Color','k')
xlabel({'$x$'},'Interpreter','latex')
ylabel({'$y$'},'Interpreter','latex')

k = 1.8;
xlim([-k,k]);
ylim([-k,k]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')




ax2 = subplot('Position',pos2);
hold on

plot(tout, abs(rout(:,1)),...
    'Color','k','LineWidth', linethickness)
plot(tout, traj,...
    'Color','k','LineWidth', linethickness,'LineStyle', '--')

xlabel({'$t$'},'Interpreter','latex')
ylabel({'$r$'},'Interpreter','latex')

ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')




