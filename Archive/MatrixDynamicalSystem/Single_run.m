N = 500;
P = 2;
NumberOfRuns = 100;
S_yes = true;
S_diag = true;

% Create a matrix B such that elements of B^k < corresponding
% elements of B. That is, the matrix is convergent. 
% B = ones(P);
% while any(any(B^10>0.999*B))
%     B = 0.6*randn(P);
% end
% B = B;

if P == 2
    W = mat_norm([[3;1],[-6;1]]);
    L = [[0.7,0];[0,0.90]];
elseif P == 3
        W = mat_norm([[1;1;1],[2;7;-3],[1;3;-2]]);
        L = [[0.7,0,0];[0,0.9,0];[0,0,0.6]];
else
        W = randn(P);
        L = diag(rand(P,1));
end
%B = @(t)W*L*inv(W);

%B = @(t)W*[[0.95+0.05*t/700;0],[0;0.99]]*inv(W);

B = @(t)[[0.95+0.05*t/300;0],[0;0.98]];
W = diag(ones(P,1));


if S_yes
    S = [[-0.015;0.01],[0.01;0.07]];
else
    S = zeros(P);
end

if S_diag
    S = diag(diag(S))
end

%find the theoretical covariance matrix D
D = zeros(P);
dummy = S*transpose(S);
for s = 0:1000
    D = D+dummy;
    dummy = B(1)*dummy*transpose(B(1));
end
clear dummy
D = D
[V,K] = eig(D)

variences = zeros(P,1);
B_variences = zeros(P,1);
eig_variences = zeros(P,1);
B_var = 0;
first_EOFs = zeros(NumberOfRuns,N); 
All_X = zeros(NumberOfRuns,P,N);

figure 

ax1 = subplot(2,2,1);
if P==3 
    %view(3);
end
title('projected onto xy axes')
xlabel(ax1,'x')
ylabel(ax1,'y')
hold on
ax2 = subplot(2,2,2);
if P==3 
    %view(3);
end
title('projected onto eigenvectors of B')
%xlabel(ax2,transpose(w1))
%ylabel(ax2,transpose(w2))
hold on
ax3 = subplot(2,2,3);
if P==3 
    %view(3);
end
title('projected onto eigenvectors of Cov Matrix')
%xlabel(ax2,transpose(w1))
%ylabel(ax2,transpose(w2))
hold on
ax4 = subplot(2,2,4);
if P==3 
    %view(3);
end
title('projected onto eigenvectors of real Cov Matrix')
%xlabel(ax2,transpose(w1))
%ylabel(ax2,transpose(w2))
hold on

for i = 1:NumberOfRuns
    X = zeros(P,N);
    X_tilde = zeros(P,N);
    X_hat = zeros(P,N);
    X_realCov = zeros(P,N);
    B_projection = zeros(1,N);
    
    
    r = 1+2*rand;
    theta = 2*pi*rand;
    x0 = [r*cos(theta);r*sin(theta)];
    X(:,1) = x0;
    clear r theta  
    
    for n = 2:N
        X(:,n) = B(n)*X(:,n-1)+S*randn(P,1);
    end
    All_X(i,:,:) = X;
    
    realCov = X*transpose(X)/(N-1);
    [realCovVectors, realCovValues] = eig(realCov);
    
    for l = 1:N
        X_tilde(:,l) = inv(W)*X(:,l);
        X_hat(:,l) = inv(V)*X(:,l);
        X_realCov(:,l) = inv(realCovVectors)*X(:,l);
        
        B_projection(l) = dot(X(:,l),W(:,1));
    end
    
    
    
    
    for l = 1:P
        variences(l) = variences(l)+var(X(l,:));
        B_variences(l) = B_variences(l)+var(X_tilde(l,:));
        eig_variences(l) = eig_variences(l)+var(X_hat(l,:));
    end
    B_var = B_var + var(B_projection);
    first_EOFs(i,:) = B_projection;
    plot(ax1,X(1,:), X(2,:))
    plot(ax2,X_tilde(1,:), X_tilde(2,:))
    plot(ax3,X_hat(1,:), X_hat(2,:))
    plot(ax4,X_realCov(1,:), X_realCov(2,:))

end

hold off
hold off
hold off
hold off

slopes = zeros(1,NumberOfRuns);
figure
ax1 = subplot(2,1,1);
hold on
ax2 = subplot(2,1,2);
hold on
xlim([1 N]);
for i = 1:NumberOfRuns
    % Plot the first EOFs
    plot(ax1,first_EOFs(i,:))
    
    % find and plot the ACF-1 (window 100) of the first EOFs
    acf = ACF_sliding(first_EOFs(i,:)',1,100);
    plot(ax2,(101:N)',acf(101:end))
    
    % find the slope of the ACF between points 600 and 700
    P = polyfit((1:100)',acf(1:100),1);
    slopes(i) = P(1);
    
end
hold off
hold off

figure 
h = histogram(slopes);

figure
hold on
for i = 1:NumberOfRuns
    plot(reshape(All_X(i,1,:),[1,N]),reshape(All_X(i,2,:),[1,N]));
end
hold off