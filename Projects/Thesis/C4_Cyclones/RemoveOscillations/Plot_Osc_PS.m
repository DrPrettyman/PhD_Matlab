%% Here we plot the sea-level preassure 
%  and the power spectrum for a period prior to Hurricane Andrew.

%% load data
if ~exist('cyclones100','var'); load('cyclones100'); end

%% get slp data
h=1; % we choose the slp_data for the first field (Andrew)
slp1 = cyclones100(h).slp_data;
event1 = cyclones100(h).event_index;
time1 = (1:size(slp1,1))' - event1;

%% 
%slp1  = slp1(event1-1200:event1+100);
%time1 = time1(event1-1200:event1+100);

%% estimate power spectrum
X = slp1(event1-1200:event1-360);
t = time1(event1-1200:event1-360);
cutoff = 1/24;
% find the power spectrum
P = abs(fft(X)); P = P(2:floor(end/2));
f = (1:size(P,1))./(t(end)-t(1));
% find the peak
peak = find(P == max(P(f > cutoff))) ; 
freq = f(peak);
%% plot the figure
disp(['peak at ' num2str(freq)])
figure
plot(f,P)

%%

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,30,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.09 0.13 0.5 0.85];
pos2 = pos1 + [0.6 0 -0.2 0];

ax1 = subplot('Position',pos1)
hold on
plot(ax1, time1, slp1,...
    'Color','k','LineWidth', linethickness)
ylabel({'sea-level pressure (hPa)'},'Interpreter','latex')
xlabel({'time before event (hours)'},'Interpreter','latex')
xlim([-(24*10),0]);
ylim([1015.8, 1020.8]);
xticks(-480:48:0)
yticks(1016:1021)
ann = annotation('textbox',...
    pos1 + [0.05 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%xticklabels([]);
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



ax2 = subplot('Position',pos2)
hold on
plot(ax2, f, P,...
    'Color','k','LineWidth', linethickness)

ylabel({'spectral density'},'Interpreter','latex')
xlabel({'period (hours)'},'Interpreter','latex')
xticks([1/24 1/12 1/8 1/6 1/4 1/3 1/2])
xticklabels([24 12 8 6 4 3 2]);
xlim([1/120, 1/5]);
yticklabels([]);
%ylim([0.88,0.98]);
ann = annotation('textbox',...
    pos2 + [0.03 -0.03 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
