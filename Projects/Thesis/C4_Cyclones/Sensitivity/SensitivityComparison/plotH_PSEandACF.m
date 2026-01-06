

load('PSEcomp.mat')
load('ACFcomp.mat')

event_index = 2641;
xlims = (event_index-400):(event_index);
xaxis = xlims - event_index;

upp = PSEcomp(15).PSE240(xlims) + PSEcomp(16).PSE240(xlims);
low = PSEcomp(15).PSE240(xlims) - PSEcomp(16).PSE240(xlims);

figure
hold on  
plot(xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
plot(xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])  
plot(xaxis, PSEcomp(15).PSE240(xlims), 'LineWidth',1.5, 'Color','k')
ylabel('PSE Propogator value');
xlabel('Time before event');
hold off

%%
figure
ax1 = subplot(1,2,1);
hold on
upp = ACFcomp(15).ACF240(xlims) + ACFcomp(16).ACF240(xlims);
low = ACFcomp(15).ACF240(xlims) - ACFcomp(16).ACF240(xlims);
    
plot(ax1, xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
plot(ax1, xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    
plot(ax1, xaxis, ACFcomp(15).ACF240(xlims), 'LineWidth',1.5, 'Color','k')

ylabel(ax1, 'ACF Propogator value');
xlabel(ax1, 'Time before event');
hold off

%%
ax2 = subplot(1,2,2);
hold on
set(ax2,'yaxislocation','right');

upp = PSEcomp(15).PSE240(xlims) + PSEcomp(16).PSE240(xlims);
low = PSEcomp(15).PSE240(xlims) - PSEcomp(16).PSE240(xlims);
    
plot(ax2, xaxis, upp, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
plot(ax2, xaxis, low, 'LineStyle','--', 'Color',[0.5,0.5,0.5])
    
plot(ax2, xaxis, PSEcomp(15).PSE240(xlims), 'LineWidth',1.5, 'Color','k')
%plot(ax1, xaxis, CycloneStruct(6).ACF240(xlims), 'LineWidth',0.5, 'Color','r')

ylabel(ax2, 'PSE Propogator value');
xlabel(ax2, 'Time before event');
hold off

