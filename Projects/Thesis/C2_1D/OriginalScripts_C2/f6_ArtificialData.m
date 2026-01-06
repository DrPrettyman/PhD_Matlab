

%% Set parameters

N = 10^4; % series length

alpha0 = 0; % initial parameter
alpha1 = 2; % final parameter

mu = linspace(alpha0,alpha1,N);


T = 10; % number of trials

wl = 0.01*N; % window length

%% Create the holders

AllSeries = zeros(N,T);

ACF1vals = zeros(N,T);
DFAvals  = zeros(N,T);
PSvals   = zeros(N,T);

%% run the trials

for j = 1:T
    j
    
    eta = rand(N,1);
    series = zeros(N,1);
    for k = 2:N
        series(k) = mu(k)*series(k-1) + eta(k);
    end
    
    AllSeries(:,j) = series;
    
    PSvals(:,j) = PSE_sliding(series, wl);
end

%% take the mean

PSmean = mean(PSvals,2);
PSstd = std(PSvals')';
%% plot

figure
hold on
for j = 1:T
    plot(AllSeries(:,j))
end

figure
hold on
plot(PSmean, 'color', 'b')
plot(PSmean - PSstd, 'color', 'b')
plot(PSmean + PSstd, 'color', 'b')















