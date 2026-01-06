%% long range test

%% Short range correlated 
N = 5000;
numTrials = 200;
exponentsShort = linspace(0,1,numTrials)';

acf_ValuesShort = zeros(numTrials,1);
acf1ValuesShort = zeros(numTrials,1);

for k = 1:numTrials
    exp = exponentsShort(k)
    
    
    noise = zeros(N,1);
    for i = 2:N
        noise(i) = exp*noise(i-1)+0.2*randn();
    end
    noise = noise-mean(noise);
    sample = noise./var(noise);
    
    acf_ValuesShort(k) = ACF_scaling(noise);
    acf1ValuesShort(k) = ACF(noise,1);
end

%%
figure
hold on
plot(acf1ValuesShort)
plot(acf_ValuesShort)

%% Long range correlated 
N = 5000;
numTrials = 200;
exponentsLong = linspace(0,2,numTrials)';

acf_ValuesLong = zeros(numTrials,1);
acf1ValuesLong = zeros(numTrials,1);

for k = 1:numTrials
    exp = exponentsLong(k)
    
    noise = dsp.ColoredNoise(exp, N, 1);
    sample = noise();

    acf_ValuesLong(k) = ACF_scaling(sample);
    acf1ValuesLong(k) = ACF(sample,1);
end

%%
figure
hold on
plot(acf1ValuesLong)
plot(acf_ValuesLong)

%% plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,40,15];
fig1.Resize = 'off';
fontsize = 20;
linethickness = 2;
hold on

pos1 = [0.1 0.18 0.42 0.80];
pos2 = [0.57 0.18 0.42 0.8];

ax1 = subplot('Position',pos1)
hold on
plot(ax1, exponentsShort, acf_ValuesShort,...
    'Color',0.6*[1 1 1],'LineWidth', linethickness)
plot(ax1, exponentsShort, acf1ValuesShort,...
    'Color',0.1*[1 1 1],'LineWidth', linethickness)
plot(ax1, [-10 10], [1 1],...
    'Color','k','LineStyle', '--',...
    'LineWidth', 0.5)

%xticks([0 0.5 1 1.5 2])
xlabel({'AR(1) model parameter'},'Interpreter','latex')
%yticks([0.6 0.8 1 1.2 1.4])
ylabel({'Exponent value'},'Interpreter','latex')
a = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
xlim([0,1]);
ylim([-0.4,2]);
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



ax2 = subplot('Position',pos2)
%ax2 = subplot(2,1,2)
hold on
plot(ax2, exponentsLong, acf_ValuesLong,...
    'Color',0.6*[1 1 1],'LineWidth', linethickness)
plot(ax2, exponentsLong, acf1ValuesLong,...
    'Color',0.1*[1 1 1],'LineWidth', linethickness)
plot(ax2, [-10 10], [1 1],...
    'Color','k','LineStyle', '--',...
    'LineWidth', 0.5)

xticks([0 0.5 1 1.5 2])
xlabel({'AR(63) model parameter'},'Interpreter','latex')
yticks([0,0.5,1,1.5]);
yticklabels([])
b = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
xlim([0,2]);
ylim([-0.4,2]);
legend('ACF exponent','ACF1 value');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



%% long range test

noise = dsp.ColoredNoise(2, N, 1);
sample = noise();

acf_exp = ACF_scaling(sample, true)

acf10 = ACF(sample,10)
acf100 = ACF(sample,100)
