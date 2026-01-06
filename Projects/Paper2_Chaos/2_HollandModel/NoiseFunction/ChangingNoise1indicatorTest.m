
N = 1;
seriesLength = 1000;
windowSize = 100;

noiseSamples = zeros(seriesLength, N);
noiseACF = zeros(size(noiseSamples));
noisePS  = zeros(size(noiseSamples));
for i = 1:N
    noiseSamples(:,i) = changingNoise1(0.4, 2, seriesLength);
    noiseACF(:,i) = ACF_sliding(noiseSamples(:,i),1, windowSize);
    noisePS(:,i)  = PSE_sliding(noiseSamples(:,i),windowSize);
end
xAxis = linspace(0,100, seriesLength);


%%
figure

ax1 = subplot(3,1,1);
hold on
ax2 = subplot(3,1,2);
hold on
ax3 = subplot(3,1,3);
hold on

for k = 1:N
   plot(ax1, xAxis, noiseSamples(:,k))
   plot(ax2, xAxis, noiseACF(:,k))
   plot(ax3, xAxis, noisePS(:,k))
end
plot(ax1, xAxis, mean(noiseSamples,2), 'color','k','LineWidth',3)
plot(ax2, xAxis, mean(noiseACF,2), 'color','k','LineWidth',3)
plot(ax3, xAxis, mean(noisePS,2), 'color','k','LineWidth',3)

ylim(ax2,[-0.1,1.1])
ylim(ax3,[-0.1,2.1])

xlim(ax1,[xAxis(windowSize+1), 100])
xlim(ax2,[xAxis(windowSize+1), 100])
xlim(ax3,[xAxis(windowSize+1), 100])