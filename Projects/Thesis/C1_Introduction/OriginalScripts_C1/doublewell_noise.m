%% Define parameters
% First we define the parameters of the model 
% and make one time series as a test

T = 1000;
delta_t = 0.05;
cp = @(t)@(z)z^4+(3.0-t/200)*z^2;
initial_z = 0;

F = @(t)0;


%% Create N instances
% now we create 100 instances of the model and save them in a structure
N = 1;

Pitchfork = struct;

sigma = @(t)0.1;
[t, z] = time_series_cp(T, delta_t, cp, initial_z, sigma);
z = z(1:20:end);
t = t(1:20:end);
Pitchfork(1).time_axis = t;
Pitchfork(1).data = z;
sigma = @(t)0.4;
[t, z] = time_series_cp(T, delta_t, cp, initial_z, sigma);
z = z(1:20:end);
t = t(1:20:end);
Pitchfork(2).time_axis = t;
Pitchfork(2).data = z;

%%
fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,35,12];
fig1.Resize = 'off';
hold on

plot(Pitchfork(1).time_axis, Pitchfork(1).data,...
    'LineWidth',1.7)
plot(Pitchfork(2).time_axis, Pitchfork(2).data,...
    'LineWidth',1.7)

ylim([-1.5, 1.5]);
yticks([-1,0,1]);

xlabel({'$t$'},'interpreter', 'latex')
ylabel({'$z$'},'interpreter', 'latex')

legend({'small noise','large noise'})

set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')