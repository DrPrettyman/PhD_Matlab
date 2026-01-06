

%% Integrate the system in homoclinic_fun.m with mu a function 
%  of t which decreases from 0.5 to 0 as t goes from 0 to 100.
%  Standard deviation of the noise is 0.01

f = @(x,t)([x(2); (0.2-0.002*t)-x(1)^2]);
sigma = 0.01*[1;1];
x0 = [sqrt(0.2);0.1];
tBounds = [0 100];
delta_t = 0.01;
[t,Y] = milstein(f, sigma, x0, tBounds, delta_t);
tout = t(1:50:end);
xout = Y(:,1:50:end)';
% figure
% plot(xout(:,1),xout(:,2))
% pause

%% Plot the output in 3D.
figure
plot3(tout(1:end-5,1),xout(1:end-5,1),xout(1:end-5,2))

%% plot the eigenvalues:

delT = 0.5;
sliding_eigenvals = plot_eigenvals_Jacobian(xout, t(end), 60, delT, true);

%% Calculate the EOF and the altEOF
%  and then the ACF signal of these

xEOF = EOF1(xout);
xAltEOF = Alt_EOF(xout);

xEOFACF = ACF_sliding(xEOF,1,100);
xAltEOFACF = ACF_sliding(xAltEOF,1,100);

figure
hold on
plot(xEOFACF(101:end))
plot(xAltEOFACF(101:end))
