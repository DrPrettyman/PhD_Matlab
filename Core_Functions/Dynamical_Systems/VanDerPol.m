%% start with x near the center
x_0 = [0;0];

%% Integrate the system in hopf_fun.m with mu a function 
%  of t which increses from -2.8 to 0.2 as t goes from 0 to 6.
%  Standard deviation of the noise is 0.01
T_end = 400;
[tout_system,xout_system] = VDPwithnoise_fun(T_start ,T_end, x_0,...
        @(t)(-0.38 + 0.001*t), 0.01);
    tout = tout_system(1:100:end);
    xout = xout_system(1:100:end,:);

%% plot(xout(:,1),xout(:,2))

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,10];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

plot(tout(:,1),xout(:,1),...
    'Color','k','LineWidth', linethickness)
ylim(0.001*[-5.8,5.8])
ylabel({'$x$'},'Interpreter','latex')
xlabel({'$t$'},'Interpreter','latex')
set(gca,'YGrid','on','XGrid','on',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')
