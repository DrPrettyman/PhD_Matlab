load OscSystemA_workspace

types = [3 1 2];

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,45,22];
fig1.Resize = 'off';
fontsize = 18;
lineThickness = 1;
lineCol = 'k';
hold on

h = 0.26; % sets the height of each subplot
w = 0.27; % sets the width of each subplot
wgap = 0.05; % sets horizontal gap between subplots
hgap = 0.04; % sets first vertical gap between subplots
hgap2 = 0.02; % sets second vertical gap between subplots
pos0 = [0.05 0.08 w h];

for i = 1:numel(types)
    ti = types(i); %set type index
    pos1 = pos0 + [(i-1)*(w+wgap) 0 0 0];
    pos2 = pos0 + [(i-1)*(w+wgap) 1*(h+hgap) 0 0];
    pos3 = pos0 + [(i-1)*(w+wgap) 2*(h+hgap) 0 0];
    
    ax1 = subplot('Position', pos1);
    hold on
    ax2 = subplot('Position', pos2);
    hold on
    ax3 = subplot('Position', pos3);
    hold on
    
    tlimits = [S(ti).t(S(ti).windowsize+1), S(ti).t(end)];
    
    %plot ACF1
    plot(ax3, S(ti).t, S(ti).ACF1,...
        'Color', lineCol, 'LineWidth', lineThickness);
    xlim(ax3, tlimits);
    
    %plot PS
    plot(ax2, S(ti).t(S(ti).windowsize:end), S(ti).DFA,...
        'Color', lineCol, 'LineWidth', lineThickness);
    xlim(ax2, tlimits);
    
    %plot PS
    plot(ax1, S(ti).t, S(ti).PS,...
        'Color', lineCol, 'LineWidth', lineThickness);
    xlim(ax1, tlimits);
    
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation','bottom',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    set(ax2,'YGrid','on','XGrid','on',...
        'XAxisLocation','bottom',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    set(ax3,'YGrid','on','XGrid','on',...
        'XAxisLocation','top',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    
    if i == 1
        ylabel(ax1,'PS', 'Interpreter', 'latex');
        ylabel(ax2,'DFA', 'Interpreter', 'latex');
        ylabel(ax3,'ACF1', 'Interpreter', 'latex');
    end
    
    xlabel(ax1,'time $t$', 'Interpreter', 'latex');
    ax2.XAxis.TickLabels = '';
    
    abc = 'abc';
    annotationmsg = ['(', S(ti).method, ')'];
        
    ann1 = annotation('textbox',...
        pos3 + [0.02 0 0 0],...
        'String',abc(i),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        pos3 + [0.04 0 0 0],...
        'String',annotationmsg,...
        'FontSize', 15',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
end
    