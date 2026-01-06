function [ z, lambda ] = UKF( Y, z_0, lambda_0, f, Q, R)
% This is an implementation of the filter as described in Kwasniok
% only 1 system variables and 4 parameters.


% OUPUTS:
% z        -- time series of z 
% lambda   -- time series of lambda
% 
% INPUTS:
% Y        -- observed timeseries (n_o by T matrix)
%
% z_0      -- initial guess for z (column vector)
% lambda_0 -- initial guess for lambda (column vector)
%
% f        -- f = @(z,lambda)... system function of z and lambda
%
% Q        -- cov matrix of the dynamical noise
% R        -- cov matrix of the observation noise
%
% OTHER:
% x_hat_0 = \hat{x}_{t-1|t-1}
% x_hat_1 = \hat{x}_{t|t-1}
% x_hat = \hat{x}_{t|t}
%
% y_hat_1 = \hat{y}_{t|t-1}
%
% P_xx_0 = P_{t-1|t-1}
% P_xx_1 = P_{t|t-1}
% P_xx = P_{t|t}

T = size(Y,2); % number of observations

n_s = 1;      % dimension of system
n_p = 4; % dimension of parameter space
n = 5;          % dimension of augmented system space
n_o = 1;   % dimension of observation vector

Qa = blkdiag(Q, zeros(n_p)); % augmented system cov

x_hat = [z_0; lambda_0]; % initial guess for augmented state vector
P_xx = Qa; % initial guess for cov

x_hat_series = zeros(n, T+1);
x_hat_series(:,1) = x_hat;

sigma_points = zeros(n, 2*n); % empty matrix to hold sigma points
prop_sigma = zeros(n, 2*n); % empty matrix to hold propogated sigma points
sigma_obs = zeros(1, 2*n); % empty matrix to hold propogated observations

for t = 1:T
    
    %disp(['t = ',num2str(t)])
    x_hat_0 = x_hat;
    P_xx_0 = P_xx;
    
    % find a suitable matrix A using Cholesky decomposition
    try
        %A = fliplr(diag(ones(n,1)))*chol((n+kappa)*P_xx_0)';
        A = chol(n*P_xx_0)';
    catch
        % if the decomposion does not work, exit the method now.
        warning('cholesky decomposition not working. Matrix is not positive definate.');
        z = x_hat_series(1:n_s,1:t);
        lambda = x_hat_series(n_s+1:n,1:t);
        return 
    end
   
    % define the sigma points using x_hat and the matrix A
    sigma_points(:,n) = x_hat_0;
    for j = 1:n
        sigma_points(:,n+1-j) = x_hat_0 - A(:,j);
        sigma_points(:,n+j) = x_hat_0 + A(:,j);
    end
  
    
    % propogate the sigma points through the dynamical equation
    for j = 1:2*n
        s_x = sigma_points(1,j);
        s_lambda = sigma_points(2:5,j);
        propogated_s_x = f(s_x, s_lambda);
        propogated_sigma_points = [propogated_s_x ; s_lambda];
        prop_sigma(:,j) = propogated_sigma_points;
        sigma_obs(j) = propogated_s_x;
    end
       
    % find the means
    x_hat_1 = mean(prop_sigma);
    y_hat_1 = mean(sigma_obs); 
    
    % find the covariances
    sum = zeros(5,5);
    for j = 1:2*n
        sum = sum +...
            (propogated_sigma_points(:,j) - x_hat_1)*(propogated_sigma_points(:,j) - x_hat_1)';
    end
    P_xx_1 = (1/(2*n))*sum + Qa;
    
    sum = zeros(5,1);
    for j = 1:2*n
        sum = sum +...
            (propogated_sigma_points(:,j) - x_hat_1)*(sigma_obs(j) - y_hat_1)';
    end
    P_xy_1 = (1/(2*n))*sum + Qa(:,1);
    
    sum = zeros(1,1);
    for j = 1:2*n
        sum = sum +...
            (sigma_obs(j) - y_hat_1)*(sigma_obs(j) - y_hat_1)';
    end
    P_yy_1 = (1/(2*n))*sum + R;
    
    
     
    % Kalman gain matrix
    K = P_xy_1/P_yy_1;
    
    % Update
    x_hat = x_hat_1 + K*(Y(:,t)-y_hat_1);
    P_xx = P_xx_1 - K*P_yy_1*K';
    
    x_hat_series(:,t+1) = x_hat;
end
    
    
z = x_hat_series(1:n_s,:);
lambda = x_hat_series(n_s+1:n,:);


return


