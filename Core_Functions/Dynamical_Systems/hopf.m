
%% start with x near the center
x_0 = [0.001;0];

%% Integrate the system in hopf_fun.m with mu a function 
%  of t which increses from -2.8 to 0.2 as t goes from 0 to 6.
%  Standard deviation of the noise is 0.01
T_end = 65;
[tout, rout]=hopf_fun(0,T_end,x_0,@(t)(-2.9+0.05*t),0.01);

figure
plot(tout, rout(:,2))

xout = zeros(size(rout));
xout(:,1) = rout(:,1).*cos(rout(:,2));
xout(:,2) = rout(:,1).*sin(rout(:,2));

tout = tout(1:50:end,:);
xout = xout(1:50:end,:);

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

ax1 = subplot('Position',pos1)
hold on
plot(ax1, tout(:,1),xout(:,1),...
    'Color','k','LineWidth', linethickness)
ylabel({'$x$'},'Interpreter','latex')
xlim([0,65]);
ylim([-3.9,3.9]*0.001);
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




ax2 = subplot('Position',pos2)
hold on
plot(ax2, tout(:,1),xout(:,2),...
    'Color','k','LineWidth', linethickness)
%yticks([0.6 0.8 1 1.2 1.4])
xlabel({'$t$'},'Interpreter','latex')
ylabel({'$y$'},'Interpreter','latex')
xlim([0,65]);
ylim([-3.9,3.9]*0.001);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')







%% plot the series
%pause
figure
plot3(tout(:,1),xout(:,1),xout(:,2))
title('3D plot')

%% find Jacobian the eigenvalues
delT = 0.5;
sliding_eigenvals = plot_eigenvals_Jacobian(xout, T_end, 60, delT, true);

%% find the ACF1 signal of the EOF

xEOF = EOF1(xout);
xAltEOF = Alt_EOF(xout);

xEOFACF = ACF_sliding(xEOF,1,100);
xAltEOFACF = ACF_sliding(xAltEOF,1,100);

figure
hold on
plot(xEOFACF(101:end))
plot(xAltEOFACF(101:end))