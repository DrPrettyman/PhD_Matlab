function [T, W] = EOF1(X, nondimensionalise, weights)

if nargin<3 
    weights = ones(1,size(X,2));
end

if nargin<2
    nondimensionalise = false;
end

% calculate the subtracted-mean data, B
B = X - ones(size(X,1),1)*mean(X,1);

% calculate Z-scores, Z is just B normalised so that
% the std of each column is 1
Z = B ./ (ones(size(B,1),1)*std(B,1));

% nondimensionalise
if nondimensionalise
    if ~all(size(weights) == [1,size(B,2)])
        warning('weights array is the wrong size, using equal weightings')
        weights = ones(1,size(B,2));
    end
    B = Z .* (ones(size(B,1),1)*weights);
end

% calculate the covariance matrix, C
C = B'*B;
C = C/(size(X,1)-1);

% find the eigenvectors/values of C
[V,D] = eig(C);

% select the eigenvector corresponding to the 
% maximum eigenvalue
[row, col] = find(~(D - max(D(:))));
W = V(:,col);
W = W./norm(W);

% project Z scores onto the new basis
T = Z*W;