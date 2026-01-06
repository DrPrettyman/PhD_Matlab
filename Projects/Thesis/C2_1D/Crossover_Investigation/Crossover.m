%% Crossover
plotfigs = 1;

N=10^4;

mu = 10^1.5/(2*pi);
White = mu*randn(N,1);
Red = cumsum(randn(N,1));
Both = White+Red;

S_white = abs(fft(White)).^2/N;
S_both = abs(fft(Both)).^2/N;
S_red = abs(fft(Red)).^2/N;
F = linspace(0,1,N)';

E_white = mu^2*ones(N,1);
E_red = (1/(4*pi^2))*F.^(-2);
E_both = (mu/(2*pi))*F.^(-1)+(1/(4*pi^2))*F.^(-2)+mu^2;


% figure
% plot(Both)


logP_red = log10(S_red);
logP_white = log10(S_white);
logP_both = log10(S_both);

logE_red = log10(E_red);
logE_white = log10(E_white);
logE_both = log10(E_both);

logF = log10(F);


%% Plot 

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,30,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 3;
hold on



plot(logF,logP_red,...
    'Color',[1 0.7 0.7],'LineWidth', 0.1)
plot(logF,logP_white,...
    'Color',0.6*[1 1 1],'LineWidth', 0.1)
plot(logF,logP_both,...
    'Color',[0.5 0.5 1],'LineWidth', 0.1)


plot(logF,logE_red,...
    'Color','k','LineWidth', linethickness,...
    'LineStyle', '--')
plot(logF,logE_white,...
    'Color','k','LineWidth', linethickness,...
    'LineStyle', '--')
plot(logF,logE_both,...
    'Color','k','LineWidth', linethickness)

xlim([-2.9 -0.1])
ylim([-0.9 4.9])

yticks([0 1 2 3 4]);
xticks([-3 -2 -1 0]);
xticklabels([0.001 0.01 0.1 1]);

xlabel({'$f$'},'Interpreter','latex');
ylabel({'log$[S(f)]$'},'Interpreter','latex');

set(gca,'YGrid','on','XGrid','on','box','on',...
        'FontSize',fontsize, 'FontName', 'Times New Roman')

[ pse_value, psdx, freq ] = PSE_new( Both, 0);
pse_value


