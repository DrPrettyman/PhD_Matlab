%% Types of bifurcation _ plot

% Plots the data contained in the structure "bifurcations" which is
% produced by running "Typesoftipping.m"
%

%% Load the structure or run the script
%load bifurcations30
% If there is no structure "bifurcations", run the scipt "Typesoftipping.m"


%% Plot

number_of_types = size(bifurcations,2);

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,45,22];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.3;
hold on

h = 0.27; % sets the height of each subplot
w = 0.29; % sets the width of each subplot
wgap = 0.03; % sets horizontal gap between subplots
hgap1 = 0.02; % sets first vertical gap between subplots
hgap2 = 0.02; % sets second vertical gap between subplots
pos1 = [0.05 0.68 w h];

for type = 1:number_of_types
%for type = 3:3
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
    pse_mean1 =...
        bifurcations(type).mean_pse(...
        bifurcations(type).pse_windowsize+1:end);
    t1_pse =...
        t1(bifurcations(type).pse_windowsize+1:end);
    acf_mean1 =...
        bifurcations(type).mean_acf(...
        bifurcations(type).acf_windowsize+1:end);
    t1_acf =...
        t1(bifurcations(type).acf_windowsize+1:end);
    
    % create the axes
    ax1 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) 0 0 0]);
    ax2 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) -(h+hgap1) 0 0]);
    ax3 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) -(2*h+hgap1+hgap2) 0 0]);
    
    % plot the data
    plot(ax1,t1,z1,...
        'LineWidth', linethickness, 'Color', 'k');
    plot(ax2,t1_pse,pse_mean1,...
        'LineWidth', linethickness, 'Color', 'k');
    plot(ax3,t1_acf,acf_mean1,...
        'LineWidth', linethickness, 'Color', 'k');
    
    % set the axes properties
    xlim(ax1,[0,1]); xlim(ax2,[0,1]); xlim(ax3,[0,1]);
    ylim(ax2,[-0.5,2.3]) % PSE limits
    ylim(ax3,[-0.1,1]) % ACF1 limits

    ylim(ax1,[-1.9, 1.9]);

    xticks(ax1,[0 0.2 0.4 0.6 0.8]);
    xticks(ax2,[ 0.2 0.4 0.6 0.8]);
    ax2.XAxis.TickLabels = '';
    xticks(ax3,[0 0.2 0.4 0.6 0.8]);
    yticks(ax1, (-10:10));
    yticks(ax3,[0 0.4 0.8]);
    %title(ax1,bifurcations(type).type)
    if type==1
        ylabel(ax1,'$z(t)$', 'Interpreter', 'latex');
        ylabel(ax2,'PS indicator');
        ylabel(ax3,'ACF1 indicator');
    end
    xlabel(ax3,'time $t$', 'Interpreter', 'latex');
    
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation','top',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    set(ax2,'YGrid','on','XGrid','on',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    set(ax3,'YGrid','on','XGrid','on',...
        'XAxisLocation','bottom',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    
    abc = 'abc';
    annotationmsg = ['(', bifurcations(type).type, ')'];
        
    ann1 = annotation('textbox',...
        pos1 + [(type-1)*(w+wgap)+0.02 0 0 0],...
        'String',abc(type),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        pos1 + [(type-1)*(w+wgap)+0.04 -0.01 0 0],...
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
clear pos1 h w wgap hgap1 hgap2 
clear linethickness fontsize 






