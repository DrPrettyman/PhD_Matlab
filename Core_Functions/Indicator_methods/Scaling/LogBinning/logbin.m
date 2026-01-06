function [newLT, newLZ] = logbin(LT, LZ, windowlimits, plotfigs)

%% A logarithmic binning function

% Takes logarithmic independent variable LT and dependent variable LZ
% and bins both logarithmically.
% For T = linspace(a,b,N) and Z being data dependent on T, then LT
% should be of the form log10(T) and LZ = log10(Z).
% The window limits should be defined on the logarithmic time LT with
% the relation:
% LT(1) <= windowlimits(1) < windowlimits(2) <= LT(end)

%% check for errors

if size(LT) ~= size(LZ)
    error('LT and LZ different sizes')
    return 
elseif size(LT,1) <= 10
    error('LT must be longer than 10 elements')
    return
elseif LT(1) >= LT(end) || LT(1) > windowlimits(1) || windowlimits(1) >= windowlimits(2) || windowlimits(2) > LT(end)
    error('windowlimits must satisfy LT(1) <= windowlimits(1) < windowlimits(2) <= LT(end)')
    return
end

%% deal with any infinite values
infindex = find(LT == -Inf | LT == Inf);
LT(infindex) = LT(infindex+1);

    
infindex = find(LZ == -Inf | LZ == Inf);
LZ(infindex) = 10^(-5);
clear infindex


%% Trim the data to only the window
lt1 = windowlimits(1);
lt2 = windowlimits(2);

window = find(LT >= lt1 & LT <= lt2);

LTw = LT(window);
LZw = LZ(window);

%% split the window into subwindows
%  First establish how many windows to use
nosubwindows = 10; %the number of subwindows to use
goodnumber = false;
while goodnumber == false
    swlen = (lt2-lt1)/nosubwindows; %the length of each subwindow (the size in terms of t, not how many data are in each window.
    subwindow1 = find(LTw > lt1 & LTw < lt1+swlen); %the first subwindow
    sw1size = size(subwindow1,1); % the size of the first subwindow
    if sw1size > 1
        goodnumber = true;
    else
        nosubwindows = nosubwindows - 1;
    end
end
clear goodnumber sw1size subwindow1

%% Now split the window into subwindows
subWindows = struct;

for i = 1:nosubwindows
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

for i = 2:nosubwindows

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

newLZ = zeros(nosubwindows*noparts,1);
newLT = zeros(nosubwindows*noparts,1);
for i = 1:nosubwindows
    newwindowindex = ((i-1)*noparts+1:i*noparts)';
    newLZ(newwindowindex) = subWindows(i).newLZ;
    newLT(newwindowindex) = subWindows(i).newLT;
end

%% Plot
if plotfigs == true
    figure
    ax3 = subplot(2,1,1);
    plot(ax3,LTw, LZw);
    xlabel('log(t)')
    ylabel('log(z)')
    title('Original data in window')
    ax4 = subplot(2,1,2);
    plot(ax4,newLT, newLZ)
    xlim([lt1, lt2])
    xlabel('log(t)')
    ylabel('log(z)')
    title('Binned data')
end





