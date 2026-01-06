

%% y^2/2 + x^3/3 - \alpha*x = c


c_vals = linspace(-1,1.5,11)';
alpha = 1;

x_axis = linspace(-2,2,1000)';

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,20,20];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1;
hold on
h = 0.80; % sets the height of each subplot
w = 0.80; % sets the width of each subplot
pos1 = [0.15 0.15 w h];

ax1 = subplot('Position',pos1);
hold on

for i = 1:numel(c_vals)
    c = c_vals(i);
    y_axis_p = sqrt(c+alpha*x_axis - x_axis.^3./3);
    y_axis_m = -y_axis_p;
    plot(ax1,x_axis, y_axis_p, 'Color' , 'k')
    plot(ax1,x_axis, y_axis_m, 'Color' , 'k')
end
plot([0,0], [-10, 10], 'Color' , 'k')

xlim(ax1,[-2,2])
ylim(ax1,[-2,2])

ylabel(ax1,' $y$', 'Interpreter', 'latex');
xlabel(ax1,' $x$', 'Interpreter', 'latex');

set(ax1,'YGrid','on','XGrid','on',...
    'XAxisLocation','bottom',...
    'box','on','FontSize',fontsize,...
    'FontName', 'Times New Roman');