
N = 10000;

% White noise
xw = zeros(N,1);
for i = 2:N
    xw(i) = randn();
end
figure;
plot(xw)
pseW = PSE_new(xw,1);

% Red noise
xr = zeros(N,1);
for i = 2:N
    xr(i) = xr(i-1)+randn();
end
figure;
plot(xr)
pseR = PSE_new(xr,1);

% plot
figure
ax1 = subplot(2,1,1);
hold on
ax2 = subplot(2,1,2);
hold on
for i = 1:N
        plot(ax1,xw)

        plot(ax2,xr)
end

