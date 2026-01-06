if ~exist('cyclones100','var'); load('cyclones100'); end

windowlimits = [-2, -1];
cycloneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noCy = size(cycloneList,1);

%% get data

S = struct;
for i = 1:noCy
    h = cycloneList(i);
    S(i).name = cyclones100(h).h_name;
    slp1 = cyclones100(h).slp_data_RO12;
    event1 = cyclones100(h).event_index;
    time1 = (1:size(slp1,1))' - event1;
    X = slp1(1:event1-96);
    t = time1(1:event1-96);

    [ pse_value, psdx, freq ] = PSE_new( X, 0);
    logf = log10(freq);
    logp = log10(psdx);
    [binnedLF, binnedLP] = logbin(logf, logp, windowlimits, false);
    S(i).binnedLF = binnedLF;
    S(i).binnedLP = binnedLP;
    S(i).X = X;
    S(i).t = t;
end

%% plot

numPlots = 14;
numcols = 5;

f_lims = [-2, -1];

numrows = ceil(numPlots/numcols);
abc = 'abcdefghijklmnopqrstuvwxyz';
abc = abc(1:numrows*numcols);
fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,40,22];
fig1.Resize = 'off';
fontsize = 18;
lineThickness = 1;
lineCol = 'k';
hold on

h = 0.25; % sets the height of each subplot
w = h*fig1.Position(4)/fig1.Position(3); % sets the width of each subplot
wgap = 0.05; % sets horizontal gap between subplots
hgap = 0.03; % sets first vertical gap between subplots
pos0 = [0.05 (numrows)*(h+hgap)-0.18 w h];
    
for i = 1:numPlots
    col = mod(i-1,numcols); row = floor((i-1)/(numcols));
    [col, row]
    
    pos1 = pos0 + [col*(w+wgap) -row*(h+hgap) 0 0];
    ax1 = subplot('Position', pos1);
    hold on
    
    plot(ax1, S(i).binnedLF, S(i).binnedLP,...
        'Color', lineCol, 'LineWidth', 1.5,...
        'Marker', '^', 'MarkerSize', 5, 'LineStyle', 'none')
    
    xlim(ax1, f_lims);
    
    if row == 0
        ttickloc = 'top';
    else
        ttickloc = 'bottom';
    end
    if row ~= 0 && row ~= numrows-1 && i ~= numPlots
        ax1.XAxis.TickLabels = '';
    end
    if row == numrows-1 || i == numPlots
        xlabel(ax1,'$\log f$', 'Interpreter', 'latex');
    end
    if col == 0
        ylabel(ax1,'$\log S(f)$', 'Interpreter', 'latex');
    end
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation',ttickloc,...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
    annotationmsg = ['(',S(i).name,')'];   
%     ann1 = annotation('textbox',...
%         pos1 + [0.02 0 0 0],...
%         'String',abc(i),...
%         'FontSize', 30',...
%         'LineStyle', 'none',...
%         'FitBoxToText', 'off',...
%         'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        pos1 + [0.04 -0.01 0 0],...
        'String',annotationmsg,...
        'FontSize', 15',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
end