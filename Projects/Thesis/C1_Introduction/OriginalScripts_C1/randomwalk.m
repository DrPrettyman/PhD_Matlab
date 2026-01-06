N=10000;

noise = randn(N,1);
R = zeros(N,1);
Q = zeros(N,1);
P = zeros(N,1);


psi = [0.5];
phi = [0.8, -0.2];

for i = 2:N
    R(i) = R(i-1)+noise(i);
    Q(i) = psi(1)*Q(i-1)+noise(i);
end
for i = 3:N
    P(i) = phi(1)*P(i-1)+phi(2)*P(i-2)+noise(i);
end

R = R/std(R);
Q = Q/std(Q);
P = P/std(P);

%%

z1 = (phi(1)+sqrt(phi(1)^2+4*phi(2)^2))/(-2*phi(2))
z2 = (phi(1)-sqrt(phi(1)^2+4*phi(2)^2))/(-2*phi(2))

t = (1:N);
mean(t/sqrt(t.^2+t))
ACF(R,1)
ACF(P(end-floor(N/3):end),1)
%%
fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,35,12];
fig1.Resize = 'off';
hold on

plot(R,...
    'LineWidth',1.7)
plot(P,...
    'LineWidth',1.7)

%ylim([-1.5, 1.5]);
%yticks([-1,0,1]);

xlabel({'$t$'},'interpreter', 'latex')
ylabel({'$x$'},'interpreter', 'latex')

legend({'random walk','AR(2) process'},'location','northwest')

set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')