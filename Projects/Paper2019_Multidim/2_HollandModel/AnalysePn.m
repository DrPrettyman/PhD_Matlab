%% Here we analyse the ambient pressure (p_n)

load('beforeHurricaneData.mat');
H = beforeHurricaneData;

means = zeros(size(H,2),1);
meanDiffsGlobal = zeros(size(H,2),1);
figure 
hold on
for i = 1:size(H,2)
    data = H(i).slp(1:end-1);
    meanDiffsGlobal(i) = max(data)-min(data);
    means(i) = mean(data);
    plot(data)
end


periods = 2400./(1:2400)';
figure 
hold on
for i = 1:size(H,2)
    data = H(i).slp(1:end-1);
    ps = abs( fft(data) ).^2;
    ps = ps(2:floor(end/2));
    periods = periods(1:size(ps,1));
    plot(periods, ps);
    ps(100)
    ps(200)
end

%%
x = (0:0.01:10)';
x = x(1:end-1);
y = sin(10*(2*pi*x)/4);
ps = abs(fft(y)).^2;
figure
plot(x,y)
figure
semilogy(ps(2:floor(end/2)))

%%

data = H(6).slp(1:end-1);
data = data(end-150:end-20)
x = (0:size(data,1)-1)';

shift12 = 1;
shift24 = 1;
a12 = 1; %amplitude of 12 hour wave
a24 = 0;
wave = a12*sin((2*pi*(x-shift12))/12)+a24*sin((2*pi*(x-shift24))/24);
figure
hold on
plot(x,data)
plot(x,wave+mean(data))
plot(x, data-wave)


%%
meanDiffs = zeros(size(H,2),1);
for k = 1:size(H,2)
    data = H(k).slp;
    difference = zeros(size(data));
    for i = 1:size(data,1)-24
        segment = data(i:i+23);
        difference(i) = max(segment) - min(segment);
    end
    meanDiffs(k) = mean(difference);
end 

%%

load('beforeHurricaneData.mat');
H = beforeHurricaneData;

means = zeros(size(H,2),1);
meanDiffsGlobal = zeros(size(H,2),1);
figure 
hold on
for i = 1:1
    data = H(i).slp(1:end-1);
    meanDiffsGlobal(i) = max(data)-min(data);
    means(i) = mean(data);
    plot(data)
end
