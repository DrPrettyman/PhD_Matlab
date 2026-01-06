%% Here we demonstrate the calculation of the DFA method using 
%  a red noise series (exponent 0.85)

%% generate the noise
alpha = 1;
N = 40;
noise = dsp.ColoredNoise(alpha, N, 1);
noise1 = noise();

%% perform the order-2 DFA method for segment length N/2

seglen = floor(N/2);

[F, plotableF, plotableB] = DFA(noise1, seglen, 2);

%% plot

linethickness = 2;

xaxis = (1:N)'-1;
cumnoise = cumsum(noise1);

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,40,15];
fig1.Resize = 'off';
fontsize = 20;
hold on

ymin = min([min(cumnoise) min(plotableF)]);
ymax = max([max(cumnoise) max(plotableF)]);

plot(xaxis, cumnoise, 'LineWidth', linethickness ,...
    'Color', 0.5*[1 1 1], 'Marker', '^')

plot(xaxis(1:seglen), plotableF(1:seglen),...
    'LineWidth', linethickness, 'Color', 'r')
plot(xaxis(seglen+1:end), plotableF(seglen+1:end),...
    'LineWidth', linethickness, 'Color', 'r')

breakpoint = (xaxis(seglen)+xaxis(seglen+1))/2;
plot([0,0], [ymin, ymax],...
    'LineStyle', '--', 'LineWidth', linethickness, 'Color', 'k')
plot([breakpoint,breakpoint], [ymin, ymax],...
    'LineStyle', '--', 'LineWidth', linethickness, 'Color', 'k')
plot([xaxis(N),xaxis(N)], [ymin, ymax],...
    'LineStyle', '--', 'LineWidth', linethickness, 'Color', 'k')

ylim([ymin, ymax])
xlim([0, 39])

yticks((-100:10:100))
xticks((0:10:N-1))

xlabel('$t$','Interpreter','latex')
ylabel({'$Y(t)$ = ', 'cumulative sum of $z(t)$'},'Interpreter','latex')

set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

