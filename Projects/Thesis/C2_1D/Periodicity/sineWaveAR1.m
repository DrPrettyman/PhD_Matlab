%% test the reconstruct_mu function
p = @(mu)(log10(...
    (1+mu^2-2*mu*cos(0.2*pi))/(1+mu^2-2*mu*cos(0.02*pi))...
    ));


%%

N = 100;
doDFA = 0;
sigma = 1;
mu_vals = linspace(0,1,N)';
beta_vals = zeros(size(mu_vals));
for i = 1:numel(mu_vals)
    beta_vals(i) = p(mu_vals(i));
end

mu_anal = linspace(0,1,10^4)';
beta_anal = zeros(size(mu_anal));
for i = 1:numel(mu_anal)
    beta_anal(i) = p(mu_anal(i));
end

S=struct;
S(1).type = 'Simple AR1';
S(2).type = 'AR1 + sine wave';
S(3).type = 'AR1 + complicated sine';

for i = 1:3
    S(i).mu_vals = mu_vals;
    S(i).beta_vals = beta_vals;
    S(i).mu_anal = mu_anal;
    S(i).beta_anal = beta_anal;
    S(i).beta_PS = zeros(N, 1);
    S(i).mu_ACF1 = zeros(N, 1);
    S(i).alpha_DFA = zeros(N, 1);
end

sizeAR = 10^4;
xaxis = linspace(0,20*pi,sizeAR)';
sinewave = sin(xaxis);
dsinewave = 7*sin(xaxis)+3*sin(4*xaxis+pi/2);
dsinewave = 2*sin(50*xaxis)+3*sin(7*xaxis);

for i = 1:N
    mu = mu_vals(i);
    AR = zeros(sizeAR,1); %create an AR(1) time series
    for j = 2:sizeAR
        AR(j) = mu*AR(j-1)+sigma*randn();
    end
    S(1).Y = AR;
    S(2).Y = AR+sinewave;
    S(3).Y = AR+dsinewave;
    
    for k = 1:3
        S(k).beta_PS(i)  = PSE_new(S(k).Y);
        S(k).mu_ACF1(i) = ACF(S(k).Y,1);
        if doDFA
            [points, alpha] = DFA_estimation(S(k).Y, 2, false);
            S(k).alpha_DFA(i) = alpha;
        end
    end
    disp(['calculated mu = ',num2str(mu)])
end

clear i j k beta AR mu sizeAR points alpha
disp(' ')



%% Plot

number_of_types = 3;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,32,36];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

h = 0.27; % sets the height of each subplot
w = 0.27; % sets the width of each subplot
wgap = 0.04; % sets horizontal gap between subplots
hgap1 = 0.04; % sets first vertical gap between subplots
hgap2 = 0.04; % sets second vertical gap between subplots
pos1 = [0.07 0.68 w h];

mksize = 5;
colPS = 'k';
colACF = 'k';
colDFA = 'k';
colCurve = 0.7*[1 1 1];

for type = 1:number_of_types
%for type = 3:3
    % load/trim the time series
    t1 = S(type).mu_vals;

    % create the axes
    ax1 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) 0 0 0]);
    hold on
    ax2 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) -(h+hgap1) 0 0]);
    hold on
    ax3 = subplot('Position',...
        pos1 + [(type-1)*(w+wgap) -(2*h+hgap1+hgap2) 0 0]);
    hold on
    % plot the data
    plot(ax1,S(type).mu_anal,S(type).mu_anal,...
        'LineWidth', linethickness, 'Color', colCurve);
    plot(ax1,t1,S(type).mu_ACF1,...
        'LineWidth', linethickness, 'Color', colACF,...
        'Marker', '^', 'MarkerSize',mksize, 'LineStyle','none');
    plot(ax2,t1,S(type).alpha_DFA,...
        'LineWidth', linethickness, 'Color', colDFA,...
        'Marker', '^', 'MarkerSize',mksize, 'LineStyle','none');
    plot(ax3,S(type).mu_anal,S(type).beta_anal,...
        'LineWidth', linethickness, 'Color', colCurve);
    plot(ax3,t1,S(type).beta_PS,...
        'LineWidth', linethickness, 'Color', colPS,...
        'Marker', '^', 'MarkerSize',mksize, 'LineStyle','none');
    
    % set the axes properties
    xlim(ax1,[0,1]); xlim(ax2,[0,1]); xlim(ax3,[0,1]);
    
    ylim(ax1,[0,1]) % ACF1 limits
    ylim(ax2,[0.5,1.5]) % DFA limits
    ylim(ax3,[0,2]) % PS limits

%     xticks(ax1,[0 0.2 0.4 0.6 0.8]);
%     xticks(ax2,[ 0.2 0.4 0.6 0.8]);
    ax2.XAxis.TickLabels = '';
%     xticks(ax3,[0 0.2 0.4 0.6 0.8]);
%     yticks(ax1, (-10:10));
%     yticks(ax3,[0 0.4 0.8]);
    %title(ax1,transitions(type).type)
    if type==1
        ylabel(ax1,'ACF1');
        ylabel(ax2,'DFA');
        ylabel(ax3,'PS');
    end
    xlabel(ax3,'AR1 parameter  $\mu$', 'Interpreter', 'latex');
    
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






