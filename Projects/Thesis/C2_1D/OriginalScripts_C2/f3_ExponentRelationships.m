%%
load('Scaling_comparrison/ps_dfa_compShort_data.mat')
load('Scaling_comparrison/ps_dfa_comp_data.mat')

pShort = polyfit(pseValuesShort, dfaValuesShort,1) ;
pLong  = polyfit(pseValues, dfaValues,1);

yShort = polyval(pShort, pseValuesShort); 
yLong  = polyval(pLong , pseValues); 

x = linspace(0,2,10);
y = (x+1)/2;


%% plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,30,12];
fig1.Resize = 'off';
fontsize = 20;
linethickness = 4;
hold on

pos1 = [0.1 0.18 0.44 0.80];
pos2 = [0.55 0.18 0.44 0.80];

colgrey = 0.3*[1 1 1];

ax1 = subplot('Position',pos1)
hold on
scatter(ax1, pseValuesShort, dfaValuesShort,...
    'MarkerEdgeColor',colgrey)
%plot(ax1, pseValuesShort, yShort,'LineWidth', linethickness, 'Color', 'r');
plot(ax1, x,y,...
    'LineWidth', linethickness, 'Color', 'r', 'LineStyle', '--');
xticks([0 0.5 1 1.5 2])
xlabel({'PS exponent value  $\beta$'},'Interpreter','latex')
yticks([0.6 0.8 1 1.2 1.4])
ylabel({'DFA exponent value $\alpha$'},'Interpreter','latex')
a = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%a.FontSize = fontsize;
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

ax2 = subplot('Position',pos2)
%ax2 = subplot(2,1,2)
hold on
scatter(ax2, pseValues, dfaValues,...
    'MarkerEdgeColor',colgrey)
%plot(ax2, pseValues, yLong,'LineWidth', linethickness, 'Color', 'r');
plot(ax2, x,y,...
    'LineWidth', linethickness, 'Color', 'r','LineStyle', '--');
xticks([0 0.5 1 1.5 2])
xlabel({'PS exponent value  $\beta$'},'Interpreter','latex')
yticks([0.6 0.8 1 1.2 1.4])
yticklabels([])
b = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')