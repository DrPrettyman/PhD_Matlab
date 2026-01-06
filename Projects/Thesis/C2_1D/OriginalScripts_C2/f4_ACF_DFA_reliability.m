%% ACF/DFA reliability

% This script tests the reliability of the ACF and DFA scaling
% exponents by applying both methods to N noise series of length
% noiseLen for each alpha value between 0 and 1. For each alpha, N
% noise series are generated and the methods applied and the std
% found. Then the std values are plotted over the values alpha.


%% Init

N = 10;
noiseLen = 1000;

alpha_values = linspace(0,1,51)';

%% Main Program

ACF_std = zeros(size(alpha_values));
DFA_std = zeros(size(alpha_values));

for j = 1:size(alpha_values,1)
    disp([num2str(j),' / ', num2str(numel(alpha_values))])
    alpha = alpha_values(j);
    coloredNoise = dsp.ColoredNoise(alpha, noiseLen, 1);
    
    ACFval  = zeros(N,1);
    DFAval  = zeros(N,1);

    for i = 1:N
        noise = coloredNoise();
    
        ACFval(i)  = ACF_scaling(noise);
        [a, DFAexp] = DFA_estimation(noise,2,false);
        DFAval(i)  = DFAexp;
    end
    
    ACF_std(j) = std(ACFval);
    DFA_std(j) = std(DFAval);
    
end
  
%% Figure

linethickness = 2;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,40,15];
fig1.Resize = 'off';
fontsize = 20;
hold on

plot(alpha_values, ACF_std,...
    'LineWidth', linethickness , 'Color', 0.1*[1 1 1],...
    'Marker', '^')
plot(alpha_values, DFA_std,...
    'LineWidth', linethickness , 'Color', 0.7*[1 1 1],...
    'Marker', 's')

%ylim([ymin, ymax])
%xlim([0, 39])

%yticks((-100:10:100))
%xticks((0:10:N-1))

xlabel('AR(63) model parameter $\lambda$','Interpreter','latex')
ylabel({'Standard deviation of','exponent values'},'Interpreter','latex')

legend({'ACF','DFA'},'FontSize',20, 'Interpreter','latex',...
    'Location','northwest')

set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')







