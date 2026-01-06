%% Creating the data

N = 10;
Z = cell(N);
ACF1 = cell(N);
windowSize = 100;

T = 1000;
delta_t = 0.05;
initial_z = 0;
sigma = 0.01;
epsilon = 10^(-5);
t =  (0:delta_t:T)';
n = size(t,1);

mu = linspace(2*N,N,n);

for x = 1:N
    disp(['x = ',num2str(x)])
    for y = 1:N
        z = zeros(n,1);
        z(1) = initial_z;
        % populate the array z with the time series by looping over time
        for i = 1:(n-1)
            potential = @(z)z^4 + ((mu(i)-x-y)/10)*z^2;
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
        
        Z{x,y} = z;
        ACF1{x,y} = ACF_sliding(z,1,windowSize);
        
        
    end
end

%% Creating the contour plot

MKindex = 1000;
MKwindow = 100;

MKcoef = zeros(N);
for x = 1:N
    for y = 1:N
        MKcoef(x,y) = mannkendall(ACF1{x,y}(MKindex - MKwindow:MKindex));
    end
end
contourf(MKcoef)

c2 = colorbar;
c2.Label.String = 'Mann-Kendall coefficient';
c2.Label.FontSize = 14;
c2.FontSize = 14;

ylabel('y')
xlabel('x')
set(gca, 'FontSize', 12)

fileName = ['PitchforkContour_N10'];

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 12 10];
fig.PaperSize = [12 10];
print(fileName,'-dpdf','-r0')
