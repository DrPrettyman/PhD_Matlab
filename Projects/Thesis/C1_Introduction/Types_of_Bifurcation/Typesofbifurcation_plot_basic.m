%% Types of tipping _ plot

% Plots the data contained in the structure "bifurcations" which is
% produced by running "Typesoftipping.m"
%

%% Load the structure or run the script
load bifurcations30
% If there is no structure "bifurcations", run the scipt "Typesoftipping.m"


%% Plot

number_of_types = size(bifurcations,2);

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,20,18];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.3;
hold on

h = 0.27; % sets the height of each subplot
w = 0.9; % sets the width of each subplot
hgap = 0.02; % sets the vertical gap between subplots
pos1 = [0.08 0.71 w h];

for type = 1:number_of_types
    
    % load/trim the time series
    t1 = bifurcations(type).t1;
    z1 = bifurcations(type).Zarray(:,1);
    if strcmp(bifurcations(type).type,'Noise-induced')
        if z1(100) > 0
            z1 = -z1;
        end
    end
    if strcmp(bifurcations(type).type,'Pitchfork')
        if z1(end) < 0
            z1 = -z1;
        end
    end
    
    % create the axes plot the data
    subplot_pos = pos1 + [0 -(type-1)*(h+hgap) 0 0];
    ax1 = subplot('Position', subplot_pos);
    plot(ax1,t1,z1,...
        'LineWidth', linethickness, 'Color', 'k');
    
    % set the axes properties
    xlim(ax1,[0,1]);

    ylim(ax1,[-1.9, 1.9]);
   
    xticks(ax1,[0 0.2 0.4 0.6 0.8 1]);
    yticks(ax1, (-10:10));
    ylabel(ax1,'$z(t)$', 'Interpreter', 'latex');
    
    if type == 3
        xlabel(ax1,'time $t$', 'Interpreter', 'latex');
    end
    
    if type == 1 || type ==2
        ax1.XAxis.TickLabels = '';
    end
    
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation','bottom',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    
    abc = 'abc';
    annotationmsg = ['(', bifurcations(type).type, ')'];
        
    ann1 = annotation('textbox',...
        subplot_pos + [0.02 0 0 0],...
        'String',abc(type),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        subplot_pos + [0.06 -0.014 0 0],...
        'String',annotationmsg,...
        'FontSize', 20',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    clear t1 z1 pse_mean1 t1_pse acf_mean1 t1_acf
    clear annotationmsg abc ann1 ann2
end
clear type 
clear number_of_types 
clear ax1 ax2 ax3
clear pos1 h w hgap
clear linethickness fontsize 






