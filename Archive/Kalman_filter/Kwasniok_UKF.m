function [ z, lambda ] = Kwasniok_UKF( Y, z_0, lambda_0, f, g, Q, R, lambda_positive)

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
% g        -- g = @(z)... observation function
%
% Q        -- cov matrix of the dynamical noise
% R        -- cov matrix of the observation noise
%
% lambda_positive -- an array of indices i for which lambda(i)>=0

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

n_s = size(z_0,1);      % dimension of system
n_p = size(lambda_0,1); % dimension of parameter space
n = n_s + n_p;          % dimension of augmented system space
n_o = size(g(z_0),1);   % dimension of observation vector
if ~n_o == size(Y,1)
    error('observation function does not map to the dimension of the observations')
end

Qa = blkdiag(Q, zeros(n_p)); % augmented system cov

x_hat = [z_0; lambda_0]; % initial guess for augmented state vector
%P_xx = diag(ones(n,1)); % initial guess for cov
P_xx = 0.1*randn(n) + diag(2*ones(n,1));
%P_xx = diag(x_hat); % initial guess for cov

x_hat_series = zeros(n, T+1);
x_hat_series(:,1) = x_hat;

sigma_points = zeros(n, 2*n+1); % empty matrix to hold sigma points
prop_sigma = zeros(n, 2*n+1); % empty matrix to hold propogated sigma points
sigma_obs = zeros(n_o, 2*n+1); % empty matrix to hold propogated observations

kappa = 0; % unused parameter
weights = (1/(2*(n+kappa)))*ones(2*n+1,1);
weights(n+1) = kappa/(n+kappa);

for t = 1:T
    
    %disp(['t = ',num2str(t)])
    x_hat_0 = x_hat;
    P_xx_0 = P_xx;
    
    % find a suitable matrix A using Cholesky decomposition
    try
        %A = fliplr(diag(ones(n,1)))*chol((n+kappa)*P_xx_0)';
        A = chol((n+kappa)*P_xx_0)';
    catch
        % if the decomposion does not work, exit the method now.
        warning('cholesky decomposition not working. Matrix is not positive definate.');
        z = x_hat_series(1:n_s,1:t);
        lambda = x_hat_series(n_s+1:n,1:t);
        return 
    end
   
    % define the sigma points using x_hat and the matrix A
    sigma_points(:,n+1) = x_hat_0;
    for j = 1:n
        sigma_points(:,n+1-j) = x_hat_0 - A(:,j);
        sigma_points(:,n+1+j) = x_hat_0 + A(:,j);
    end
    
    % make sure positive-only lambda value remain positive
    sigma_points(n_s+lambda_positive,:) =...
        abs(sigma_points(n_s+lambda_positive,:));
  
    
    % propogate the sigma points through the dynamical equation
    for j = 1:2*n+1
        prop_sigma(1:n_s,j) = ...
            f(sigma_points(1:n_s,j),sigma_points(n_s+1:n,j));
        prop_sigma(n_s+1:n,j) = sigma_points(n_s+1:n,j);
        sigma_obs(:,j) = g(prop_sigma(1:n_s,j));
    end
       
    % find the weighted means
    x_hat_1 = prop_sigma*weights;
    y_hat_1 = sigma_obs*weights; 
    
    % find the covariances
    % first subtract the means
    prop_sigma = prop_sigma - x_hat_1*ones(1,2*n+1);
    sigma_obs = sigma_obs - y_hat_1*ones(1,2*n+1);
    
    % Then multiply. The weights are in the middle of the product.
    P_xx_1 = (prop_sigma*diag(weights)*prop_sigma') + Qa;
    P_xy_1 = (prop_sigma*diag(weights)*sigma_obs');
    P_yy_1 = (sigma_obs*diag(weights)*sigma_obs') + R;
        % note, we are missing the Qa and qa from the last two,
        % it is neccessary to find out why these are used in Kwasniok, 
        % but not in Sitz.
     
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


