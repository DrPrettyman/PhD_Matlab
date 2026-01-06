



T = 1000;
delta_t = 0.05;
initial_z = 0;
sigma = 0.01;

epsilon = 10^(-5);
t =  (0:delta_t:T)';
n = size(t,1);
mu = linspace(3,-2,n);

z = zeros(n,1);
z(1) = initial_z;

x = 2;
y = 2;
% populate the array z with the time series by looping over time
for i = 1:(n-1)
    potential = @(z)z^4 + (mu(i))*z^2;
    % Calculate the derivative of the potential at z(t(i))
    dirivative_of_potential = (potential(z(i)+epsilon)...
        - potential(z(i)-epsilon)) / (2*epsilon);
    % Calculate the gradient \dot{z}
    grad_z = -dirivative_of_potential...
        + sqrt(1/delta_t)*sigma*randn;
    % Advance the value of z forward in time according to its gradient
    z(i+1) = z(i) + delta_t*grad_z;
    clear potential dirivative_of_potential grad_z
end

t = t(1:20:end);
z = z(1:20:end);

figure
plot(t,z)

figure
plot(t, ACF_sliding(z,1,100))