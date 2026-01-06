



% f = @(x,y,mu)([-x+2*y+x^2;...
%     (2-mu)*x-y-3*x^2+1.5*x*y]);


%% define
syms x y mu
V = [-x+2*y+x^2;...
    (2-mu)*x-y-3*x^2+1.5*x*y];
[solx, soly] = solve(V==0, [x,y]);
J = jacobian(V, [x;y]);

%% Find the eigenvalues
mu_vals = linspace(-10,10,1000)';
S = struct;
for k = 1:numel(solx)
    S(k).mu_vals = mu_vals;
    S(k).solx = solx(k);
    S(k).soly = soly(k);
    S(k).J = subs(J, [x, y], [S(k).solx, S(k).soly]);
    eig_k = eig(S(k).J)
    eig_vals = zeros(numel(mu_vals),2);
    for i = 1:numel(mu_vals)
        for eig_number = 1:2
            eig_vals(i,eig_number) = subs(eig_k(eig_number), mu, mu_vals(i));
        end
    end
    S(k).eig_vals1 = eig_vals(:,1);
    S(k).eig_vals2 = eig_vals(:,2);
end

%% Plot

figure
title('Eigenvalues: imaginary part')
hold on
for k = 1:numel(S)
    a = subplot(2,3,k);
    b = subplot(2,3,k+3);
    plot(a, S(k).mu_vals, imag(S(k).eig_vals1))
    ylim(a,[-5,5])
    title(a, ['solution ',num2str(k)]);
    plot(b, S(k).mu_vals, imag(S(k).eig_vals2))
    ylim(b,[-5,5])
end

figure
title('Eigenvalues')
hold on
for k = 1:numel(S)
    a = subplot(2,3,k);
    hold on
    b = subplot(2,3,k+3);
    hold on
    plot(a, real(S(k).eig_vals1), imag(S(k).eig_vals1))
    plot(a, real(S(k).eig_vals1(1)), imag(S(k).eig_vals1(1)),'Marker','s')
    ylim(a,[-5,5])
    title(a, ['solution ',num2str(k)]);
    plot(b, real(S(k).eig_vals2), imag(S(k).eig_vals2))
    plot(b, real(S(k).eig_vals2(1)), imag(S(k).eig_vals2(1)),'Marker','s')
    ylim(b,[-5,5])
end
