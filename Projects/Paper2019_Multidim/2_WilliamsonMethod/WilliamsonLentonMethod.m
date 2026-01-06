function Output = WilliamsonLentonMethod(x, windowlen, k, delT)
% For an N by p data array x, we return the k^th eigenvalue of the jacobian
% matrix. 

% x         - the data arry
% windowlen - the desired window length
% k         - the index of the desired eigenvalue
% delT      - the timestep in the time series

% the length of the data array x
N = size(x,1);

% in a sliding window of "windowlen" points, we calculate the matrix A
% and find its eigenvalues.
A_eigenvals = zeros((N-windowlen),size(x,2));
for i = 1:(N-windowlen)
    windowA = estimate_A(x(i:i+windowlen,:));
    [wEigVec,wEigVal] = eig(windowA);
    for j = 1:size(x,2)
        A_eigenvals(i,j) = wEigVal(j,j);
    end
end

% considering only the k^th eigenvalue of A, we transform this to find the 
% k^th eigenvalue of the Jacobian matrix
realpart = (1/delT)*log(abs(A_eigenvals(:,k)));
imagpart = (1/delT)*angle(A_eigenvals(:,k));

% the output is the 
Output = [(1+windowlen:N)', realpart, imagpart];
end

