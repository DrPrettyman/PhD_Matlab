%% Plot_pitchforkMuRelationship.m 
%
% Plots the relationship between the pitchfork model parameter mu and
% the PS exponent, and also between mu and the ACF1.
%

%% Fetch data
% either run the script or load the workspace

% CalculatePitchforkEWS.m
% load pitchforkEWS_workspace.mat

%% Variables

t_axis = linspace(0,1,N)';

%% Initialise
fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,28];
fig1.Resize = 'off';
fontsize = 18; linethickness = 2;
hold on
pos1 = [0.1 0.76 0.87 0.20];
pos2 = pos1 - [0 0.22 0 0];
pos3 = pos2 - [0 0.21 0 0];
pos4 = pos3 - [0 0.21 0 0];

subpos = {pos2, pos3, pos4};
ylimits = {[-0.2, 1], [-0.9, 3.2], [0.3, 1.5]};
abc = ['b';'c';'d'];
% tippingcolor = 0.6*[1,1,1];
tippingcolor = 'r';

%% Plot
%
% *** Plot the timeseries on the first axes ********************TimeSeries
ax1 = subplot('Position',pos1);
hold on
plot(ax1, t_axis, TimeSeries,...
    'Color','k','LineWidth', 0.01)
plot(ax1, [0.6,0.6], [-10,10],...
    'Color',tippingcolor,'LineWidth', linethickness,'LineStyle', '--')
ylabel({'z(t)'},'Interpreter','latex')
xlim([0,1]);
ylim([-1.1, 1.1]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','top',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')


% *** Plot the EWS series on the other axes ************************EWS
for k = 1:3
    ax(k) = subplot('Position',subpos{k});
    hold on
    imean = IndicatorStruct(k).mean;
    istd  = IndicatorStruct(k).std;
    plot(ax(k), t_axis(ws+1:end), imean(ws+1:end),...
        'Color','k','LineWidth', linethickness)
    hold on
    plot(ax(k), t_axis(ws+1:end),...
        imean(ws+1:end)+istd(ws+1:end),...
        'Color','k','LineWidth', linethickness,'LineStyle', ':')
    plot(ax(k), t_axis(ws+1:end),...
        imean(ws+1:end)-istd(ws+1:end),...
        'Color','k','LineWidth', linethickness,'LineStyle', ':')
    plot(ax(k), [0.6,0.6], [-10,10],...
        'Color',tippingcolor,'LineWidth', linethickness,'LineStyle', '--')
    %yticks([0.6 0.8 1 1.2 1.4])
    xlabel({'$t$'},'Interpreter','latex')
    ylabel(IndicatorStruct(k).indicatorName)
    xlim([0,1]);
    ylim(ylimits{k});
    if k<3; xticklabels([]); end
    ann = annotation('textbox',...
        subpos{k} + [0.03 0 0 0],...
        'String',abc(k),...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    set(gca,'YGrid','on','XGrid','on','box','on',...
        'FontSize',fontsize, 'FontName', 'Times New Roman')
end


clear ax1 ax pos1 pos2 pos3 pos4 fontsize linethickness ann imean istd

