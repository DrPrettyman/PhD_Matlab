% A simple exponential model of the cyclone pressure drop


X = linspace(-10,4,1000)';
Y = -exp(X);
Y = Y + randn(1000,1)*0.1;

windowSize = 100;

PSE_sliding(Y,100,true);
A = ACF_sliding(Y,1,100,false);
%% 
figure
hold on   
yyaxis left
plot(X,Y)
xlabel('t')
ylabel('z(t)')
yyaxis right
plot(X((windowSize+1):end),A((windowSize+1):end));
ylabel('ACF-1 indicator of z(t) (100-point window)')
