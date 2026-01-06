
%% Load data

load('cyclones100')
HurricaneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noH = size(HurricaneList,1);
%%
meanDeviation = zeros(80,1);
for i = 1:80 
    disp(num2str(i))
    periods = zeros(noH,1);
    for j = 1:noH
        h = HurricaneList(j);
        k = cyclones100(h).event_index;
        X = cyclones100(h).slp_data(...
            (k - 24*(i+10)):(k - 24*10));
        periods(j) = 1/...
            findFrequency((1:size(X,1)),X,false,1/23);
    end
    meanDeviation(i) = mean(abs(periods-12));
end

%%
amp = zeros(noH,1);
for j = 1:noH
    h = HurricaneList(j);
    k = cyclones100(h).event_index;
    X = cyclones100(h).slp_data(...
        (k - 1200):(k - 360));
    minmaxlist = zeros(N-12,1);
    for i = 1:N-12
        window = X(i:(i+12));
        minmaxlist(i) = max(window)-min(window);
    end
    amp(j) = mean(minmaxlist)/2;
    clear i window minmaxlist
end
amp