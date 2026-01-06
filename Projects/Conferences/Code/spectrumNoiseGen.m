N = 10000;

sCol = 200;
col = linspace(0,2,sCol);

pse = zeros(sCol,1);
acf = zeros(sCol,1);

for k = 1:sCol
    noise = dsp.ColoredNoise(col(k), N, 1);
    x = noise();
    
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
