%% Create and plot
%  X is a seris of length N which starts as red noise but gradually
%  more and more white noise is added, introducing a crossover in the
%  power spectrum.

N = 10^6;
T = linspace(0,10,N)';

mu = @(t)(1);


%%
ax1 = subplot(2,3,1:3);
hold on
yyaxis(ax1,'left')

plot(ax1,T, Mu)
plot(ax1,[T(i0); T(i0)],[0, Mu(i0)],'r--o')
plot(ax1,[T(i1); T(i1)],[0, Mu(i1)],'r--o')

%%
X = RedPlusWhite(T,mu);

yyaxis(ax1,'right')
plot(ax1,T,X)


%% PS indicator

[ pse_value, psdx, freq ] = PSE_new( X, 1);
pse_value