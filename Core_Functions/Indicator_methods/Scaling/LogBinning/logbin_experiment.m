%% create some powerlaw function plus white noise
N = 10^4;
T = linspace(10^(-3),1,N)';
Z = T.^(2)+0.2*randn(N,1);

windowlimits = [-2, -0.5];

%% Take logs
LT = log10(T);
LZ = real(log10(Z));

%% Plot data normal and loglog
figure
ax1 = subplot(1,2,1);
plot(ax1,T,Z);
xlabel('t')
ylabel('z(t)')
ax2 = subplot(1,2,2);
plot(ax2,LT, LZ);
xlabel('log(t)')
ylabel('log(z)')

%% look at your window

lt1 = windowlimits(1);
lt2 = windowlimits(2);

window = find(LT > lt1 & LT < lt2);

wsize = size(window,1); %window length

LTw = LT(window);
LZw = LZ(window);

figure
ax3 = subplot(2,1,1);
plot(ax3,LTw, LZw);
xlabel('log(t)')
ylabel('log(z)')

%% split the window into subwindows
%  First establish how many windows to use
nowindows = 10; %the number of subwindows to use
goodnumber = false;
while goodnumber == false
    swlen = (lt2-lt1)/nowindows; %the length of each subwindow (the size in terms of t, not how many data are in each window.
    subwindow1 = find(LTw > lt1 & LTw < lt1+swlen); %the first subwindow
    sw1size = size(subwindow1,1); % the size of the first subwindow
    if sw1size > 1
        goodnumber = true;
    else
        nowindows = nowindows - 1;
    end
end

%% Now split the window into subwindows
subWindows = struct;

for i = 1:nowindows
    subWindows(i).index = find(LTw >= lt1+(i-1)*swlen & LTw < lt1+i*swlen);
    subWindows(i).LT = LTw(subWindows(i).index);
    subWindows(i).LZ = LZw(subWindows(i).index);
end

%% Partition
%for each subwindow (after the first), reduce the
%number of points to the same as in the first subwindow 
%by partitioning and taking the mean of LZ in each partition.

%each subwindow should be split into 
%'size(subWindows(1).LT,1)' partitions

subWindows(1).newLT = subWindows(1).LT;
subWindows(1).newLZ = subWindows(1).LZ;


noparts = size(subWindows(1).LT,1);

for i = 2:nowindows

    sw_start = subWindows(i).LT(1); %start time of the subwindow
    sw_end   = subWindows(i).LT(end);
    subWindows(i).partlen  = (sw_end - sw_start)/noparts;
    
    newLZ = zeros(noparts,1);
    newLT = zeros(noparts,1);
    for k = 1:noparts
        
        lt_0 = sw_start + (k-1)*subWindows(i).partlen;
        lt_1 = lt_0 + subWindows(i).partlen;
        
        part_index =...
            find(subWindows(i).LT >= lt_0 &...
            subWindows(i).LT < lt_1);
        
        LZpartition = subWindows(i).LZ(part_index);
        LTpartition = subWindows(i).LT(part_index);
        
        newLZ(k) = mean(LZpartition);
        newLT(k) = mean(LTpartition);
    end
    
    subWindows(i).newLZ = newLZ;
    subWindows(i).newLT = newLT;
    clear newLZ newLT
    
end


%% join up all the subwindows

newLZ = zeros(nowindows*noparts,1);
newLT = zeros(nowindows*noparts,1);

for i = 1:nowindows
    newwindowindex = ((i-1)*noparts+1:i*noparts)';
    newLZ(newwindowindex) = subWindows(i).newLZ;
    newLT(newwindowindex) = subWindows(i).newLT;
end

%% see if it works

ax4 = subplot(2,1,2);
plot(ax4,newLT, newLZ)
xlim([lt1, lt2])
xlabel('log(t)')
ylabel('log(z)')

%% test the fuction "logbin"

[newLT, newLZ] = logbin(LT, LZ, windowlimits, true);


