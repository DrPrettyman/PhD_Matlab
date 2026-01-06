
%% start with x near the center
x_0 = [sqrt(0.2);0.1];
T_end = 100;
%% Integrate the system in homoclinic_fun.m with mu a function 
%  of t which decreases from 0.5 to 0 as t goes from 0 to 100.
%  Standard deviation of the noise is 0.01
%[tout, xout]=homoclinic_fun(0,T_end,x_0,@(t)(1.5-0.005*t),0.0);
[tout, xout]=homoclinic_fun(0,T_end,x_0,@(t)(0.2-0.002*t),0.01);
tout = tout(1:50:end,:);
xout = xout(1:50:end,:);
figure
plot(xout(:,1),xout(:,2))
%pause

%% Plot the output in 3D.
figure
plot3(tout(1:end-5,1),xout(1:end-5,1),xout(1:end-5,2))

%% plot the eigenvalues:

delT = 0.5;
sliding_eigenvals = plot_eigenvals_Jacobian(xout, T_end, 60, delT, true);

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
