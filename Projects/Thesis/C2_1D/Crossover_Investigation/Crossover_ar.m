N = 10^3;
S = @(f,lambda)(1/abs(1-lambda*exp(-2*pi*1i*f)).^2);
dS = @(f,lambda)(...
    ( -4*pi*lambda*f*sin(2*pi*f) )...
    /...
    ( 1+lambda^2-2*lambda*cos(2*pi*f) )...
    );
F = linspace(0,1,N);

c = 0;
eta = randn(N,1);

Z = struct;
lambda_vals = [0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;0.999];
for k = 1:10
    Z(k).lambda = lambda_vals(k);
    x = zeros(N,1);
    for j = 2:N
        x(j) = Z(k).lambda*x(j-1)+c+eta(j);
    end
    Z(k).ar1 = x;
    clear x
    [ Z(k).pse_value, Z(k).psdx, Z(k).freq ] = PSE_new(Z(k).ar1);
    Sf = zeros(N,1);
    dSf = zeros(N,1);
    for j = 1:N
        Sf(j) = S(F(j),Z(k).lambda);
        dSf(j) = dS(F(j),Z(k).lambda);
    end
    Z(k).Sf = Sf;
    Z(k).dSf = dSf;
    clear Sf
end

%%   plot S(f)
figure 
hold on
for k = 1:10
    plot(F,Z(k).Sf)
end
xlim([0 0.5])
ylim([0 10])
xlabel('F')
ylabel('Power Spectrum')




%%   log10log10 plot S(f)
figure 
hold on
for k = 1:10
    plot(log10(F),log10(Z(k).Sf))
end
xlim([-2.3 log10(0.5)])
ylim([-0.9 2.4])
xlabel('log( F )')
ylabel('log( Power Spectrum )')


%% plot the derivative


figure 
hold on
for k = 1:10
    plot(log10(F),Z(k).dSf)
end
%ylim([0 10])
xlim([-2.3 log10(0.5)])
xlabel('log( F )')
ylabel('PS gradient')

figure 
yyaxis left
plot(log10(F),log10(Z(7).Sf))
ylabel('log( Power Spectrum )')

yyaxis right
plot(log10(F),Z(7).dSf)
ylabel('PS gradient')
xlabel('log( F )')
xlim([-2.3 log10(0.5)])


%% find the maximum of the derivative dlog10S(f)/dlog10f as a function of lambda
%dS = @(f,lambda)((-4*pi*lambda*f*sin(2*pi*f))/(1+lambda^2-2*lambda*cos(2*pi*f)));

N=10^3;
Lambda = linspace(0.001,0.999,N)';
maxderiv = zeros(N,1);
F = linspace(0,1,N)';

figure 
hold on
for l = 1:N
    lambda = Lambda(l);

    dSf = zeros(N,1);
    for j = 1:N
        dSf(j) = dS(F(j),lambda);
    end
    maxderiv(l) = F(dSf == min(dSf));
    
    if mod(l,100) == 0
        plot(log10(F),(dSf))
    end

    clear dSf lambda
end
xlim([-3, log10(0.5)])
xlabel('log( F )')
ylabel('PS gradient')

figure
plot(Lambda, maxderiv)
xlabel('lambda')
ylabel('F where minimum PS gradient is found')


%% changing lambda

ddlambda_G = @(f,lambda)(...
    ( -4*pi*f*sin(2*pi*f)*(1-lambda^2) )...
    /...
    (( 1+lambda^2-2*lambda*cos(2*pi*f) )^2)...
    );


Lambda_vals = linspace(0.001,0.999,N)';

LogF_vals = (-3:0.5:-0.5)';
figure 
hold on
for k = 1:size(LogF_vals,1)
    f = 10^(LogF_vals(k));
    ddlambda_G_vals = zeros(N,1);
    for l = 1:N
        ddlambda_G_vals(l) = ddlambda_G(f,Lambda_vals(l));
    end
    plot(Lambda_vals, ddlambda_G_vals)
end
xlabel('lambda')
ylabel('rate of change of PS gradient wrt lambda')
ylim([-10,1])

%% individual f values


Lambda_vals = linspace(0.001,0.999,N)';


% first for f = 0.01
f = 10^(-2);
PSgrad_vals = zeros(N,1);
ddlambda_G_vals = zeros(N,1);
figure
hold on
for l = 1:N
    PSgrad_vals(l) = dS(f,Lambda_vals(l));
    ddlambda_G_vals(l) = ddlambda_G(f,Lambda_vals(l));
end
yyaxis left
plot(Lambda_vals,PSgrad_vals)
ylabel('PS gradient')
yyaxis right
plot(Lambda_vals,ddlambda_G_vals)
ylabel('rate of change of PS gradient')
xlabel('lambda')
title('f = 10^{-2}')

% then for f = 0.1
f = 10^(-1);
PSgrad_vals = zeros(N,1);
ddlambda_G_vals = zeros(N,1);
figure
hold on
for l = 1:N
    PSgrad_vals(l) = dS(f,Lambda_vals(l));
    ddlambda_G_vals(l) = ddlambda_G(f,Lambda_vals(l));
end
yyaxis left
plot(Lambda_vals,PSgrad_vals)
ylabel('PS gradient')
yyaxis right
plot(Lambda_vals,ddlambda_G_vals)
ylabel('rate of change of PS gradient')
xlabel('lambda')
title('f = 10^{-1}')

%% finding "f"
f = @(a)( (2*pi)^(-1)*( (-a + sqrt(a^2-2*(2*a-a^2-1)*(2-4*a+a^2)))/(2*a-a^2-1)    )   );

N=10^4;
Lambda = linspace(0,0.999,N)';
F = zeros(N,1);
for j = 1:N
    tempF = f(Lambda(j));
    if imag(tempF)==0
        F(j) = tempF;
    end
end

plot(Lambda, F);



