
N = 1000;
M = 50;

distanceVector = linspace(2000,-10,N);

Sarray = zeros(N,M);
PSE_array = zeros(N,M);
ACF_array = zeros(N,M);

lin = linspace(0,1,N)';
lin_r = 1-lin;
for i = 1:M
    disp(num2str(i))
    noise0 = noise_generator( N , 0, false)';
%     noise1 = noise_generator( N , 2, false)';
%     
%     S = lin.*noise0 + lin_r.*noise1;

    S = zeros(N,1);
    for t = 1:N
        redNoiseSize = distanceFunction(distanceVector(t));
        %redNoiseSize = 0.7;
        S(t) = redNoiseSize*noise1(t)+(1-redNoiseSize)*noise0(t);
    end
    Sarray(:,i) = S;
    
    PSE_array(:,i) = PSE_sliding(S,100);
    ACF_array(:,i) = ACF_sliding(S,1,100);
    
end

%%
ACFmean = mean(ACF_array,2);
PSEmean = mean(PSE_array,2);

figure 
hold on
plot(distanceVector, ACFmean)
plot(distanceVector, PSEmean)
set ( gca, 'xdir', 'reverse' )
xlabel('Distance (km)')
ylabel('Indicator value')



