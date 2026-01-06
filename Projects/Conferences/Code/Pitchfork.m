%% Creating the data

N = 1;

windowSize = 100;

T = 1000;
delta_t = 0.05;
initial_z = 0;
sigma = 0.01;
epsilon = 10^(-5);
t =  (0:delta_t:T)';
n = size(t,1);

Z = zeros(floor(n*delta_t)+1,N);
ACF1 = zeros(size(Z));
mu = linspace(-2,0.5,n);

for k = 1:N

        z = zeros(n,1);
        z(1) = initial_z;
        % populate the array z with the time series by looping over time
        for i = 1:(n-1)
            potential = @(z)z^4 - mu(i)*z^2;
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
        z = z(1:floor(1/delta_t):end);
        
        Z(:,k) = z;
        ACF1(:,k) =  ACF_sliding(z,1,windowSize);
end

mu = mu(1:floor(1/delta_t):end);

figure
ax1 = subplot(2,1,1);
hold on
ax2 = subplot(2,1,2);
hold on
for i = 1:N
        plot(ax1,mu,Z(:,i))

        plot(ax2,mu,ACF1(:,i))
end

%% Save the data
Zsave = [mu', Z];
ACF1save = [mu', ACF1];

save('dataZ_Pitchfork.dat','Zsave','-ascii')
save('dataACF1_Pitchfork.dat','ACF1save','-ascii')