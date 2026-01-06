N = 10^4;

lambda = @(mu, sqrtsign)(0.5*(mu+sqrtsign*sqrt(mu.^2-4)));

mu_vals = linspace(-1.9,1.9,N);
lambda_vals_p = zeros(size(mu_vals));
lambda_vals_n = zeros(size(mu_vals));

for i = 1:N
    mu = mu_vals(i);
    lambda_vals_p(i) = lambda(mu,1);
    lambda_vals_n(i) = lambda(mu,-1);
end

mu_vals_short = [-1; 0; 1];
lambda_vals_s = zeros(numel(mu_vals_short),2);
lambda_vals_s(:,1) = lambda(mu_vals_short, 1);
lambda_vals_s(:,2) = lambda(mu_vals_short,-1);


%%

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,30,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.1 0.12 0.85 0.85];

ax1 = subplot('Position',pos1);
hold on

legend('AutoUpdate', 'off')
plot([-10, 10], [0, 0], 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
plot([0, 0], [-10, 10], 'color', 0.7*[1 1 1],...
    'LineStyle', '--', 'LineWidth', 2)
plot(ax1, lambda_vals_p,...
    'LineWidth', 2, 'LineStyle', '-', 'Color','k');
plot(ax1, lambda_vals_n,...
    'LineWidth', 2, 'LineStyle', '-', 'Color','k');
legend off
colors = ['r';'b';'g'];
p = zeros(numel(mu_vals_short),1);
for i = 1:3
    legendtext = ['\mu = ', num2str(mu_vals_short(i))];
    p(i) = plot(ax1, lambda_vals_s(i,:), 'Marker','>','LineStyle','none',...
        'Color', colors(i),'MarkerSize',15,'MarkerFaceColor',colors(i),...
        'DisplayName', legendtext);
end
legend([p(1), p(2), p(3)])

ylim([-1.3, 1.3])
xlim([-1.3, 1.3])
ylabel('imaginary part')
xlabel('real part')
% ann = annotation('textbox',...
%     pos1 + [0.02 0 0 0],...
%     'String','a',...
%     'FontSize', 30',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')


