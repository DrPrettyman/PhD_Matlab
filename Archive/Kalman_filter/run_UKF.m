


%% Produce observations:

Q = 0.6;
R = 0.4;

z_0 = [1];
a = [0;-2;0;1];
f = @(z,lambda)(euler100(z,lambda,10^4,0.1));

N = 1000;
Z = zeros(1,N);
Z(:,1) = z_0;

for i = 2:N
    Z(:,i) = f(Z(:,i-1),a) + Q*randn;
end

Y = Z + R*randn(1,N);


%% Pass to UKF

z_0 = 1;
lambda_0 = [2;2;2;0.1];

lambda_positive = 4;
%lambda_0 = [-1;1];

g = @(z)z;

[ z, lambda ] = UKF( Y, z_0, lambda_0, f, g, Q, R, lambda_positive);

figure
hold on
plot(Z)
plot(Y)
legend('data','observations')
hold off

figure
hold on
plot(z, 'LineWidth',1.5, 'Color','k','DisplayName','x')
for i = 1:size(lambda,1)
    plot(lambda(i,:),'DisplayName',['\lambda(',num2str(i),')'])
end
legend('show')
hold off
