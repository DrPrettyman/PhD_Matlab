
M = 100;

[noise] = changingNoise(0.7,2,1000,M);
ps = zeros(size(noise));

for i = 1:M
    series = noise(:,i);
    
    ps(:,i) = smoothing(smoothing(PSE_sliding(series,100)));
end

%%
figure
hold on

for i = 1:M
    plot(ps(:,i));
end

m = mean(ps,2);
plot(m, 'Color','black','LineWidth',2)
