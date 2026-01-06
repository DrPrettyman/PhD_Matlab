function [X] = func6_ArtificalData(N, s, alpha0, alpha1)

%% construct series

Ns = ceil(N/s); % length of each segment
alphaVals = linspace(alpha0,alpha1, s);

X = zeros(Ns*s,1);
for i = 1:s
    alpha = alphaVals(i);
    noise = dsp.ColoredNoise(alpha, Ns, 1);
    nextSeries = noise();
    
    nextSeries = nextSeries/std(nextSeries);
    
%     if i>1
%         nextSeries = nextSeries - (nextSeries(1) - X((i-1)*Ns));
%     end
    
    X( (i-1)*Ns+1 : i*Ns ) = nextSeries;   
end

X = X(1:N);