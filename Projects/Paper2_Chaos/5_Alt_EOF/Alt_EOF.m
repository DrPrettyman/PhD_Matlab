% WARNING The data must be only 2-variable! X is an N by 2 matrix

% This function takes a dataset: timeseries arranged in columns in a
% matrix
% the function the mean-centres the data and projects onto unit
% vectors in an attempt to select the vector that maximises the ACF(1)
% of the projected 1D time series.

% since this is somewhat like the EOF method, but maximising ACF(1)
% instead of variance. 

function [P, u, ACF1] = Alt_EOF(X, nondimensionalise)
if nargin<2
    nondimensionalise = false;
end

% mean center the matrix to create new matrix Y
Y = X - ones(size(X,1),1)*mean(X,1);

if nondimensionalise
    Y = Y - ones(size(Y,1),1)*std(Y,1);
end

% for theta = 0 to pi, project onto the unit vector of angle theta
theta = linspace(0,pi,1000);
theta = theta(1:end-1);

maxACF = -1;
for i = 1:size(theta,2)
    vector = [cos(theta(i)); sin(theta(i))];
    projection = Y*vector;
    projACF = ACF(projection, 1);
    if maxACF < projACF
        maxACF = projACF;
        maxVector = vector;
    end
end

P = Y*maxVector;
u = maxVector;
ACF1 = maxACF;





