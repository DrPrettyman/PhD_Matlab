%% Load data

% This data has been created using Hopf100.m
%load(HopfEOFData)

fontsize = 18;
linewidth1 = 2.5;
linewidth2 = 1.5;
Msz = 50; % Marker size
c1=0.8*[1 0 0]; % plot colours
c2=0.6*[0 1 0];
c3=0.9*[0 0 1];

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,12];
fig1.Resize = 'off';
hold on

t = HopfEOFData.time;

plot(t, HopfEOFData.mean_ACF1,'color',c1,'lineWidth',linewidth1)
plot(t, HopfEOFData.mean_ACF1+HopfEOFData.std_ACF1,...
    'color',c1,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')
plot(t, HopfEOFData.mean_ACF1-HopfEOFData.std_ACF1,...
    'color',c1,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')

plot(t, HopfEOFData.mean_EOFsliding,'color',c2,'lineWidth',linewidth1)
plot(t, HopfEOFData.mean_EOFsliding+HopfEOFData.std_EOFsliding,...
    'color',c2,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')
plot(t, HopfEOFData.mean_EOFsliding-HopfEOFData.std_EOFsliding,...
    'color',c2,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')

plot(t, HopfEOFData.mean_EOFupto,'color',c3,'lineWidth',linewidth1)
plot(t, HopfEOFData.mean_EOFupto+HopfEOFData.std_EOFupto,...
    'color',c3,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')
plot(t, HopfEOFData.mean_EOFupto-HopfEOFData.std_EOFupto,...
    'color',c3,'lineWidth',linewidth2,'lineStyle','--','HandleVisibility','off')


legend({'global score','window score','moving score'},'Location','southeast');
%xlim([0,pi/4])
%xticks([0,pi/4])
%xticklabels({'\phi = 0','\phi = \pi/4'})

xlabel({'$t$'},'interpreter','latex')
ylabel({'ACF1 indicator'})


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

%%
mean(abs(HopfEOFData.mean_EOFsliding-HopfEOFData.mean_ACF1))
mean(abs(HopfEOFData.mean_EOFupto-HopfEOFData.mean_ACF1))
mean(abs(HopfEOFData.mean_EOFsliding-HopfEOFData.mean_EOFupto))


