%% test the reconstruct_mu function
p = @(mu)(log10(...
    (1+mu^2-2*mu*cos(0.2*pi))/(1+mu^2-2*mu*cos(0.02*pi))...
    ));


%%

N = 100;
mu = 0.9;
sigma = 1;

S=struct;
S(1).type = 'Simple AR1';
S(2).type = 'AR1 + sine wave';
S(3).type = 'AR1 + complicated sine';

sizeAR = 10^4;
xaxis = linspace(0,20*pi,sizeAR)';
sinewave = sin(xaxis);
dsinewave = 7*sin(xaxis)+3*sin(4*xaxis+pi/2);
dsinewave = 2*sin(50*xaxis)+3*sin(7*xaxis);

for i = 1:3
    S(i).xaxis = xaxis;
end
AR = zeros(sizeAR,1); %create an AR(1) time series
for j = 2:sizeAR
    AR(j) = mu*AR(j-1)+sigma*randn();
end
S(1).Y = AR;
S(2).Y = AR+sinewave;
S(3).Y = AR+dsinewave;      


clear i j k beta AR mu sizeAR points alpha
disp(' ')



%% Plot

number_of_types = 3;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,42,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1;
hold on

h = 0.80; % sets the height of each subplot
w = 0.27; % sets the width of each subplot
wgap = 0.04; % sets horizontal gap between subplots
hgap1 = 0.04; % sets first vertical gap between subplots
hgap2 = 0.04; % sets second vertical gap between subplots
pos1 = [0.07 0.15 w h];

mksize = 5;
colPS = 'k';
colACF = 'k';
colDFA = 'k';
colCurve = 0.7*[1 1 1];

for type = 1:number_of_types
%for type = 3:3
    % load/trim the time series

    % create the axes
    ax1 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) 0 0 0]);
    hold on

    % plot the data
    plot(ax1,S(type).xaxis,S(type).Y,...
        'LineWidth', linethickness, 'Color', 'k');
    
    % set the axes properties
    %xlim(ax1,[0,1]); 
    %ylim(ax1,[0,1]) % ACF1 limits
    
    if type==1
        ylabel(ax1,' $z(t)$', 'Interpreter', 'latex');
    end
    xlabel(ax1,' $t$', 'Interpreter', 'latex');
    
    ylim(ax1,[-15,15]);
    set(ax1,'YGrid','on','XGrid','on',...
        'XAxisLocation','bottom',...
        'box','on','FontSize',fontsize,...
        'FontName', 'Times New Roman');
   
    
    
    abc = 'abc';
    annotationmsg = ['(', S(type).type, ')'];
        
    ann1 = annotation('textbox',...
        pos1 + [(type-1)*(w+wgap)+0.02 0 0 0],...
        'String',abc(type),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    ann2 = annotation('textbox',...
        pos1 + [(type-1)*(w+wgap)+0.04 -0.02 0 0],...
        'String',annotationmsg,...
        'FontSize', 15',...
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






