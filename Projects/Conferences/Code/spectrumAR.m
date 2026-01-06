N = 10000;

sCol = 200;
col = linspace(0,1,sCol);

pse = zeros(sCol,1);
acf = zeros(sCol,1);

for k = 1:sCol
    x = zeros(N,1);
    
    for i = 2:N
        x(i) = col(k)*x(i-1)+randn();
    end
    
    pse(k) = PSE_new(x);
    acf(k) = ACF(x,1);
    
end

%% plots

% plot
figure
ax1 = subplot(2,1,1);
hold on
ax2 = subplot(2,1,2);
hold on
plot(ax1,col, acf)
plot(ax2,col, pse)

% scatter
figure
scatter(pse,acf)
xlim([0,2])
ylim([0,1])

