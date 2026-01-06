
lags = [1 2 3 4 5 6 8 10 12];
numPlots = 9;
numcols = 3;

t_axis = (-500:0)';
t_lims = [-200,0];


numrows = ceil(numPlots/numcols);
abc = 'abcdefghijklmnopqrstuvwxyz';
abc = abc(1:numrows*numcols);
fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,45,25];
fig1.Resize = 'off';
fontsize = 18;
lineThickness = 1;
lineCol = 'k';
hold on

h = 0.25; % sets the height of each subplot
w = 0.27; % sets the width of each subplot
wgap = 0.05; % sets horizontal gap between subplots
hgap = 0.05; % sets first vertical gap between subplots
pos0 = [0.05 0.70 w h];
    
for i = 1:numPlots
    col = mod(i-1,numcols); row = floor((i-1)/(numcols));
    [col, row]
    acf_mean = Cy_20lags(lags(i)).ACF1_mean;
    acf_std  = Cy_20lags(lags(i)).ACF1_std;
    
    pos1 = pos0 + [col*(w+wgap) -row*(h+hgap) 0 0];
    ax1 = subplot('Position', pos1);
    hold on
    
    plot(ax1, t_axis, acf_mean,...
        'Color', lineCol, 'LineWidth', 1.5)
    
    plot(ax1, t_axis, acf_mean-acf_std,...
        'Color', lineCol, 'LineWidth', lineThickness, 'LineStyle', '--')
    plot(ax1, t_axis, acf_mean+acf_std,...
        'Color', lineCol, 'LineWidth', lineThickness, 'LineStyle', '--')
    
    xlim(ax1, t_lims);
    
    if row == 0
        ttickloc = 'top';
    else
        ttickloc = 'bottom';
    end
    if row ~= 0 && row ~= numrows-1
        ax1.XAxis.TickLabels = '';
    end
    if row == numrows-1
        xlabel(ax1,'time $t$', 'Interpreter', 'latex');
    end
    if col == 0
        ylabel(ax1,'ACF', 'Interpreter', 'latex');
    end
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation',ttickloc,...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    annotationmsg = ['(lag-',num2str(lags(i)),')'];   
    ann1 = annotation('textbox',...
        pos1 + [0.02 0 0 0],...
        'String',abc(i),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        pos1 + [0.04 -0.01 0 0],...
        'String',annotationmsg,...
        'FontSize', 15',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
end