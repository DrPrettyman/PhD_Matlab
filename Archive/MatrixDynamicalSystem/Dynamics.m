
N = 10;
P = 2;

S_yes = true;

% Create a matrix B such that elements of B^k < corresponding
% elmt.s of B. That is, the matrix is convergent. 
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
B = W*L*inv(W);

%B = diag([0.8,0.9])
%[W,L] = eig(B)

if S_yes
    S = [[-0.15;0],[0;0.07]];
else
    S = zeros(P);
end

%find the theoretical covariance matrix D
D = zeros(P);
dummy = S*transpose(S);
for s = 0:1000
    D = D+dummy;
    dummy = B*dummy*transpose(B);
end
clear dummy
D = D
[V,K] = eig(D)

variences = zeros(P,1);
B_variences = zeros(P,1);
eig_variences = zeros(P,1);
B_var = 0;

X = zeros(P,N);
X_tilde = zeros(P,N);
X_hat = zeros(P,N);
B_projection = zeros(1,N);
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
for i = -3:1:3
    for j = -3:1:3
        if P == 3
            for k = -3:1:3
                %x0 = randn(P,1);
                x0 = [i;j;k];
                
                X(:,1) = x0;
                
                for l = 2:N
                    X(:,l) = B*X(:,l-1)+S*randn(P,1);
                end
                
                for l = 1:N
                    X_tilde(:,l) = inv(W)*X(:,l);
                end
                
                for l = 1:N
                    X_hat(:,l) = inv(V)*X(:,l);
                end
                
                for l = 1:P
                    variences(l) = variences(l)+var(X(l,:));
                    B_variences(l) = B_variences(l)+var(X_tilde(l,:));
                    eig_variences(l) = eig_variences(l)+var(X_hat(l,:));
                end
                
                plot3(ax1,X(1,:), X(2,:), X(3,:))
                plot3(ax2,X_tilde(1,:), X_tilde(2,:), X_tilde(3,:))
                plot3(ax3,X_hat(1,:), X_hat(2,:), X_hat(3,:))
                
            end
        else
            if P==2
                x0 = [i;j];
            else
                x0 = 2*randn(P,1);
                x0(1) = i;
                x0(2) = j;
            end
            X(:,1) = x0;
                
            for l = 2:N
                X(:,l) = B*X(:,l-1)+S*randn(P,1);
            end
            
            for l = 1:N
                X_tilde(:,l) = inv(W)*X(:,l);
            end
            
            for l = 1:N
                X_hat(:,l) = inv(V)*X(:,l);
            end
            
            for l = 1:N
                B_projection(l) = dot(X(:,l),W(:,1));
            end
            
            for l = 1:P
                variences(l) = variences(l)+var(X(l,:));
                B_variences(l) = B_variences(l)+var(X_tilde(l,:));
                eig_variences(l) = eig_variences(l)+var(X_hat(l,:));
            end
            B_var = B_var + var(B_projection);
           
            plot(ax1,X(1,:), X(2,:))
            plot(ax2,X_tilde(1,:), X_tilde(2,:))
            plot(ax3,X_hat(1,:), X_hat(2,:))
            
        end
    end
end
hold off
hold off
hold off

variences
eig_variences
%B_variences
B_var
% 
% figure
% %view(3);
% hold on
% for i = -3:1:3
%     for j = -3:1:3
%         %x0 = randn(P,1);
%         x0 = [i;j];
%         
%         X(:,1) = x0;
%         
%         for k = 2:N
%             X(:,k) = B*X(:,k-1)+S*randn(P,1);
%         end
%         
%         for k = 1:N
%             X_tilde(:,k) = inv(W)*X(:,k);
%         end
%         
%         if P==2
%             plot(ax1,X(1,:), X(2,:))
%             plot(ax2,X_tilde(1,:), X_tilde(2,:))
%         elseif P==3
%             plot3(X(1,:), X(2,:), X(3,:))
%             %plot3(X_tilde(1,:), X_tilde(2,:), X_tilde(3,:))
%         end
%     end
% end
% hold off
% 
% x0 = [2;2;2];
% 
% X(:,1) = x0;
% 
% for k = 2:N
%     X(:,k) = B*X(:,k-1)+S*randn(P,1);
% end
% 
% for k = 1:N
%     X_tilde(:,k) = inv(W)*X(:,k);
% end
% figure
% plot3(X(1,:), X(2,:), X(3,:))


% 
% for i = 2:N
%     X(:,i) = B*X(:,i-1)+S*randn(P,1);
% end
% 
% C = cov(X(:,floor(N/2):end)');
% 
% D = zeros(P);
% for k = 0:10*N
%     D = D + B^k*S*S'*(B')^k;
% end
% 
% C - D
% 



% figure
% hold on
% for i = 1:P
%     plot(X(i,:))
% end
% hold off

