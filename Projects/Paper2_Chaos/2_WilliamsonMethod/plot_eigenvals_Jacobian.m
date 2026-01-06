function Output = plot_eigenvals_Jacobian(x, T_end, windowlen, delT, plotornot)

% For a multivariate series x, 

len = size(x,1);

Output = zeros(len,size(x,2));

for i = (windowlen+1):len
    windowA = estimate_A(x(i-windowlen:i,:));
    [wEigVec,wEigVal] = eig(windowA);
    for j = 1:size(x,2)
        Output(i,j) = wEigVal(j,j);
    end
end

%% make a nice figure showing real and imaginary parts
%choose the j^th eigen vector

j=2;

xaxis = (0:delT:T_end)';
 %choose the first evector
realpart = (1/delT)*log(abs(Output(:,j)));
imagpart = (1/delT)*angle(Output(:,j));

realpart(1:windowlen) = zeros(windowlen,1);
imagpart(1:windowlen) = zeros(windowlen,1);
%original_eigen = Output(:,j);

%  disp(size(xaxis))
%  disp([xaxis(1), xaxis(end)])
%  disp(size(realpart))
%  disp(size(imagpart))
 
xaxis = xaxis(1:numel(realpart));
plotoutput = [xaxis, realpart, imagpart];


if plotornot
    figure
    subplot(2,1,1);
    plot(xaxis, realpart);
    title('Jacobian eigenvalue real part')
    
    subplot(2,1,2);
    plot(xaxis, imagpart);
    title('Jacobian eigenvalue imag part')
end
%% for our plotting purposes, it makes more sense to return what we have 
%  plotted here, rather than the list of eigenvectors held in "Output".

Output = plotoutput;


