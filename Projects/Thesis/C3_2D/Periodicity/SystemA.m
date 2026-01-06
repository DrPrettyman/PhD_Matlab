% For the Poincare method we look at only one point per period, that
% when the system crosses the -ve x-axis (theta = -\pi).
% For the smoothing method we average R over the last n points where n
% is the length of a period.

%% System
T1 = 10^4;
f = @(x,t)([ x(2); -x(1)*(x(1)+2*sqrt(1-(1/T1)*t)) ]); 

x0 = [-0.1;-0.001];
sigma = 0.01*[1;1];
tBounds = [0 T1];
delta_t = 10^(-3);
[tout,Zout] = milstein(f, sigma, x0, tBounds, delta_t,5);
Zout = Zout';
% t = tout(1:10:end)';
% Z = Zout(1:10:end,:);
t = tout;
Z = Zout;
Y  = Z(:,2);
X  = Z(:,1);
theta = atan2(Y,X);
R = sqrt(X.^2+Y.^2);
%%
plot(X,   Y, 'Color', 'red')

%% Periodicity
%  Find the return points
disp('Calculating return points...')
theta_pshift = zeros(size(theta));
for i = 2:numel(theta_pshift)-1
    theta_pshift(i) = theta(i+1);
end
return_points = find(theta<0 &...
    theta_pshift>0 &...
    (theta_pshift-theta)>6);
clear theta_pshift

%% Smoothing
returntime = zeros(size(t));
R_smooth   = zeros(size(t));
disp('Calculating smoothing...')
for i = return_points(3):numel(t)
    theta0 = theta(i);
    l = find(return_points<i);
    prev_window_points = return_points(l(end-1:end));
    prev_window = theta(prev_window_points(1)+1:prev_window_points(2));
    d = abs(prev_window - theta0);
    i0 = find(d==min(d),1) + prev_window_points(1);
    % i0 is the index of the last time theta was close to the current
    % value of theta.
    returntime(i) = t(i)-t(i0);
    R_smooth(i)   = mean(R(i0:i));
end 
clear l d prev_window_points prev_window theta0 i0

%% EOF method
[T_eof, W_eof] = EOF1(Z, true);

%%

S = struct;

S(1).method = 'Poincare';
S(1).t_full = t(return_points);
S(1).z_full = R(return_points);
S(1).t = linspace(S(1).t_full(1), S(1).t_full(end), numel(S(1).t_full))';
S(1).z = interp1q(S(1).t_full, S(1).z_full, S(1).t);

S(2).method = 'Smoothing';
S(2).t_full = t(return_points(3):end);
S(2).z_full = R_smooth(return_points(3):end);
S(2).t = S(2).t_full(1:1000:end);
S(2).z = S(2).z_full(1:1000:end);

S(3).method = 'EOF';
S(3).t_full = t;
S(3).z_full = T_eof;
S(3).t = S(3).t_full(1:1000:end);
S(3).z = S(3).z_full(1:1000:end);

S(4).method = 'Return times';
S(4).t_full = t(returntime>0.1 & returntime<8);
S(4).z_full = returntime(returntime>0.1 & returntime<8);
S(4).t = S(4).t_full(1:1000:end);
S(4).z = S(4).z_full(1:1000:end);

S(5).method = 'Radius only';
S(5).t_full = t;
S(5).z_full = R;
S(5).t = S(5).t_full(1:1000:end);
S(5).z = S(5).z_full(1:1000:end);





%% PS and DFA


for i = [1 2 3 5]
    windowsize = max(round(numel(S(i).t)/10,2,'significant'), 100);
    disp(['Calculating indicators: ',num2str(i),'/3'])
    S(i).windowsize = windowsize;
    S(i).PS   = PSE_sliding(S(i).z, windowsize);
    S(i).DFA  = DFA_sliding(S(i).z, 2, windowsize);
    S(i).ACF1 = ACF_sliding(S(i).z, 1, windowsize);
end
clear windowsize i


%% save the system to a structure
SysA = struct;
SysA.f = f;
SysA.T1 = T1;
SysA.delta_t = delta_t;
SysA.tBounds = tBounds;
SysA.sigma = sigma;
SysA.x0 = x0;
SysA.t = t;
SysA.Z = Z;
SysA.tout = tout;
SysA.Zout = Zout;
SysA.X = X;
SysA.Y = Y;
SysA.R = R;
SysA.theta = theta;
SysA.return_points = return_points;

%% plot Poincare
figure

ax1 = subplot(1,2,1);
hold on
plot(X,   Y, 'Color', 'red')
plot(X(return_points), Y(return_points),...
    'Marker','o','LineStyle','none','Color','k');
title('Return points')

ax2 = subplot(1,2,2);
hold on
plot(t,   R, 'Color', 'red')
plot(t(return_points), R(return_points),...
    'Marker','o','LineStyle','none','Color','k');
title('Poincare method')

clear ax1 ax2

%% clear all these things we don't need
% clear f T1 delta_t tBounds sigma x0 
% clear t Z tout Zout X Y R theta return_points
% clear R_smooth T_eof W_eof returntime


%% Good plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,44,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1;
hold on

h = 0.80; % sets the height of each subplot
w = 0.26; % sets the width of each subplot
wgap = 0.06; % sets horizontal gap between subplots
hgap1 = 0.04; % sets first vertical gap between subplots
hgap2 = 0.04; % sets second vertical gap between subplots
pos1 = [0.06 0.15 w h];
pos2 = pos1 + [(w+wgap) 0 0 0];
pos3 = pos1 + [2*(w+wgap) 0 0 0];


ax1 = subplot('Position',pos1);
hold on
ax2 = subplot('Position',pos2);
hold on
ax3 = subplot('Position',pos3);
hold on

% plot the data
% plot(ax1, X,   Y, 'Color', 'red')
% plot(ax1, X(return_points), Y(return_points),...
%     'Marker','o','LineStyle','none','Color','k');
% ylabel(ax1,' $y$', 'Interpreter', 'latex');
% xlabel(ax1,' $x$', 'Interpreter', 'latex');
% xlim(ax1, [-2,1]);
% ylim(ax1, [-2,2]);

plot(ax2, t,   R, 'Color', 'red')
plot(ax2, t(return_points), R(return_points),...
    'Marker','o','LineStyle','none','Color','k');
ylabel(ax2,' $r(t)$', 'Interpreter', 'latex');
xlabel(ax2,' $t$', 'Interpreter', 'latex');
xlim(ax2, [t(1),t(end)]);
ylim(ax2, [0,1.9]);

plot(ax3, S(2).t,   S(2).z, 'Color', 'k','LineWidth',2)
ylabel(ax3,' $\bar{r}(t)$', 'Interpreter', 'latex');
xlabel(ax3,' $t$', 'Interpreter', 'latex');
xlim(ax3, [t(1),t(end)]);
ylim(ax3, [0,1.9]);

plot(ax1, S(3).t,   abs(S(3).z), 'Color', 'k','LineWidth',0.1)
ylabel(ax1,' $z(t)$', 'Interpreter', 'latex');
xlabel(ax1,' $t$', 'Interpreter', 'latex');
xlim(ax1, [t(1),t(end)]);
ylim(ax1, [0,3]);

set(ax1,'YGrid','on','XGrid','on',...
    'XAxisLocation','bottom',...
    'box','on','FontSize',fontsize,...
    'FontName', 'Times New Roman');
set(ax2,'YGrid','on','XGrid','on',...
    'XAxisLocation','bottom',...
    'box','on','FontSize',fontsize,...
    'FontName', 'Times New Roman');
set(ax3,'YGrid','on','XGrid','on',...
    'XAxisLocation','bottom',...
    'box','on','FontSize',fontsize,...
    'FontName', 'Times New Roman');

ann1 = annotation('textbox',...
    pos1 + [0.02 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
ann2 = annotation('textbox',...
    pos2 + [0.02 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
ann3 = annotation('textbox',...
    pos3 + [0.02 0 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');


ann1 = annotation('textbox',...
    pos1 + [0.04 -0.018 0 0],...
    'String','(EOF)',...
    'FontSize', 20',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
ann2 = annotation('textbox',...
    pos2 + [0.04 -0.018 0 0],...
    'String','(Poincar�)',...
    'FontSize', 20',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
ann3 = annotation('textbox',...
    pos3 + [0.04 -0.018 0 0],...
    'String','(smoothing)',...
    'FontSize', 20',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');


%% Good plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,25,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1;
hold on
h = 0.80; % sets the height of each subplot
w = 0.80; % sets the width of each subplot
pos1 = [0.15 0.15 w h];

ax1 = subplot('Position',pos1);
hold on

% plot the data
plot(ax1, X,   Y, 'Color', 0.4*[1 1 1])
plot(ax1, X(return_points), Y(return_points),...
    'Marker','o','LineStyle','none','Color','k');
ylabel(ax1,' $y$', 'Interpreter', 'latex');
xlabel(ax1,' $x$', 'Interpreter', 'latex');
xlim(ax1, [-2,1]);
ylim(ax1, [-2,2]);


set(ax1,'YGrid','on','XGrid','on',...
    'XAxisLocation','bottom',...
    'box','on','FontSize',fontsize,...
    'FontName', 'Times New Roman');

%% Save workspace for later use (run SystemA.m to regenerate)
save('OscSystemA_workspace.mat', 'S', 'SysA');