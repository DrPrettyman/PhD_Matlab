function Output = plot_eigenvals_real(x, windowlen)

% For a multivariate series x estimate A in a sliding window
% and plot the eigen values of A as a function of the indexing 
% on x.


len = size(x,1);

Output = zeros((len-windowlen),size(x,2));

for i = 1:(len-windowlen)
    windowA = estimate_A(x(i:i+windowlen,:));
    [wEigVec,wEigVal] = eig(windowA);
    for j = 1:size(x,2)
        Output(i,j) = wEigVal(j,j);
    end
end

% Plot the real part of the eigen values 

figure
hold on
for j = 1:size(x,2)
    plot(windowlen+1:len, real(Output(:,j)))
end

% Plot the imaginary part of the eigen values

figure
hold on
for j = 1:size(x,2)
    plot(windowlen+1:len, imag(Output(:,j)))
end

