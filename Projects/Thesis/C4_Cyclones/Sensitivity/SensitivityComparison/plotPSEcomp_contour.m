%% Contour Plot PSEcomp

% PSEcomp is a structure created by applying AddPSE repeatedly to a data
% structure with increasing windowsize from 40 to 250. It therefore has the
% attributes "data", "PSE40", "PSE50", ... "PSE250".
% Here we plot all the PSE propogators as a contour plot with windowsize on
% the y axis.

load('PSEcomp_80to200.mat')

event_index = PSEcomp(1).event_index;

X = (-400:1:0);
Y = (80:200)';

Z = zeros(size(X,2), size(Y,1));

size(X)
size(Y)
size(Z)

for i = 1:size(Y,1)
    ws = Y(i);
    mean_i = PSEcomp(15).(['PSE',num2str(ws)]);
    
    %size(Z(:,i))
    %size(mean_i(event_index - 400 : event_index))
    
    Z(:,i) = mean_i(event_index - 400 : event_index);
end

figure
contourf(X, Y, Z')
colorbar()
set(gca,'FontName', 'TimesRoman','FontSize',20);
xlabel('time (hours since event)',...
    'FontSize', 25, 'FontName', 'TimesRoman')
ylabel('window size',...
    'FontSize', 25, 'FontName', 'TimesRoman')
xlim([-100,0])

%colorbar('FontSize', 20, 'FontName', 'TimesRoman')
%title('PSE indicator for different window sizes')