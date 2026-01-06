N = 10^5;

random_walk = cumsum(randn(N,1));
% random_walk = sin((0:N-1)');

Fs=1;
xdft = fft(random_walk);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:Fs/N:Fs/2)';

disp(['len psdx = ', num2str(size(psdx))])
disp(['len freq = ', num2str(size(freq))])

disp(['psdx(1) = ', num2str(psdx(1))])
disp(['psdx(2) = ', num2str(psdx(2))])
disp(['psdx(end) = ', num2str(psdx(end))])

disp(['freq(1) = ', num2str(freq(1))])
disp(['freq(2) = ', num2str(freq(2))])
disp(['freq(end) = ', num2str(freq(end))])

logf = log10(freq);
logp = log10(psdx);

windowlimits = [-2, -1];

[binnedLF, binnedLP] = logbin(logf, logp, windowlimits, false);

goodones = ~(isnan(binnedLF)+isnan(binnedLP));
binnedLF = binnedLF(goodones);
binnedLP = binnedLP(goodones);

pfit = polyfit(binnedLF, binnedLP, 1);
pse_value = -pfit(1);

figure
plot(logf, logp)