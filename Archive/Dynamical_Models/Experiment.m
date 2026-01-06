

T = 100;
cp = @(t)@(z)z.^2;
initial_z = 0;

delta_t = 1;
sigma = @(t)0.1;
[t0, z0] = time_series_cp(T, delta_t, cp, initial_z, sigma);

delta_t = 0.1;
sigma = @(t)0.1;
[t1, z1] = time_series_cp(T, delta_t, cp, initial_z, sigma);

delta_t = 0.01;
sigma = @(t)0.1;
[t2, z2] = time_series_cp(T, delta_t, cp, initial_z, sigma);

delta_t = 0.0001;
sigma = @(t)0.1;
[t3, z3] = time_series_cp(T, delta_t, cp, initial_z, sigma);

figure
hold on
%plot(t0,z0)
plot(t1,z1)
plot(t2,z2)
plot(t3,z3)
hold off