
epsilon = @(t)(0.001*t+6.5);
T_end = 700;

[tout,xout] = VDP_fun(0,T_end, [0;0] ,epsilon, 10);

plot(tout,xout(:,1))

%%

acf = ACF_sliding(xout(:,1),1,100,1);