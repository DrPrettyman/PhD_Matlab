

N = 200;

F = zeros(N,1);
F(1)=0.4;
for i = 2:N
    F(i) = 4*F(i-1)*(1-F(i-1));
end


%%
fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,35,12];
fig1.Resize = 'off';
hold on

plot((1:N), F,'LineWidth',1.7)


ylim([-0.3, 1.3]);
yticks([0,1]);

xlabel({'$n$ (time parameter)'},'interpreter', 'latex')
ylabel({'$x$'},'interpreter', 'latex')


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')