

PSdata = cyclones100(22).PS_sensitivity;
ACF1data = cyclones100(22).ACF1_sensitivity;
DFAdata = cyclones100(22).DFA_sensitivity;

DATA = [PSdata,ACF1data,DFAdata];

wsizes = (40:160)';


%%

fontsize = 18;
Msz = 5; % Marker size
c1=0.8*[0 0 1]; % plot colours
c2=0.6*[0.1 1 0.1];
c3=0.9*[1 0 0];

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,28,12];
fig1.Resize = 'off';
hold on

h = stem(wsizes, DATA, 'filled','MarkerSize', Msz);

h(1).Color = c1;
h(2).Color = c2;
h(3).Color = c3;

xlabel('Window size')
ylabel('Standard deviation in indicator')

legend({'PS','ACF1','DFA'})

set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
