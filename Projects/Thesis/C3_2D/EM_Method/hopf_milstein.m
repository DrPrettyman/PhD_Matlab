
%% init

f = @(x,t)( [(-2.9+0.05*t)*x(1) - x(1)^3 ; 1 + x(1)^2 ] );
sigma = [0.01; 0.01];
x0 = [0.001;0];
tBounds = [0, 65];
delta_t = 0.01;

%% calculate
[tout,rout] = milstein(f, sigma, x0, tBounds, delta_t);

rout = rout';
tout = tout';

xout = zeros(size(rout));
xout(:,1) = rout(:,1).*cos(rout(:,2));
xout(:,2) = rout(:,1).*sin(rout(:,2));

tout = tout(1:50:end);
xout = xout(1:50:end,:);

clear rout x0 tBounds f sigma delta_t

%% plot(xout(:,1),xout(:,2))

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,13];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.1 0.55 0.87 0.380];
pos2 = pos1 - [0 0.43 0 0];

ax1 = subplot('Position',pos1);
hold on
plot(ax1, tout,xout(:,1),...
    'Color','k','LineWidth', linethickness)
ylabel({'$x$'},'Interpreter','latex')
xlim([0,65]);
ylim([-0.039,0.039]);
xticklabels([]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')




ax2 = subplot('Position',pos2);
hold on
plot(ax2, tout,xout(:,2),...
    'Color','k','LineWidth', linethickness)
%yticks([0.6 0.8 1 1.2 1.4])
xlabel({'$t$'},'Interpreter','latex')
ylabel({'$y$'},'Interpreter','latex')
xlim([0,65]);
ylim([-0.039,0.039]);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

clear ax1 ax2 ann fontsize linethickness pos1 pos2 

%% 3D plot

figure
plot3(tout, xout(:,1), xout(:,2))

