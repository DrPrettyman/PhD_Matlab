function C = correlation_function(X,n,tau)

N = size(X,1);

t1 = 1;
tN = N - (n-1)*tau;

Y = zeros((tN-t1+1),n);

for i = 1:n
    % fill the rows of Y.
    Y(:,i) = X(t1 + (i-1)*tau : tN + (i-1)*tau);
    % columns of Y are the \bold(X)_i.
    % eg. Y(i,:) = \bold(X)_i
end

N = size(Y,1);

BigMat = zeros(N,N);

for i = 1:N
    for j = 1:N
        BigMat(i,j) = rssq(Y(i,:)-Y(j,:));
    end
end
        

C = @(r)(1/N^2)*sum(sum(r-BigMat));


return


function out = heavy_side(x)
out = 0;
if x >= 0
    out = 1;
end
return