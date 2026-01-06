 %% Contour Plot PSEcomp

% PSEcomp is a structure created by applying AddPSE repeatedly to a data
% structure with increasing windowsize from 40 to 250. It therefore has the
% attributes "data", "PSE40", "PSE50", ... "PSE250".
% Here we plot all the PSE propogators as a contour plot with windowsize on
% the y axis.

event_index = PSEcompRO(15).event_index;

X = (-400:1:0);
Y = (40:10:250)';

Z = zeros(size(X,2), size(Y,1));

size(X)
size(Y)
size(Z)

for i = 1:size(Y,1)
    ws = Y(i);
    mean_i = PSEcompRO(15).(['PSE',num2str(ws),'_RO12']);
    
    %size(Z(:,i))
    %size(mean_i(event_index - 400 : event_index))
    
    Z(:,i) = mean_i(event_index - 400 : event_index);
end

figure
contourf(X, Y, Z')
xlabel('Time (hours) - event at zero')
ylabel('Window size')
title('PSE indicator for different window sizes')