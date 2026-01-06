
%% This is just like plot_simpleModel but here we make it easy by sampling
%  the series every 20 time steps (corresponding to 1 hour).
%  Probably this won't be any different to just using a i hour time step
%  in the model. We shall see.

[time, pressure, site_xy, T_event] = simpleGridModel(10, 40, 0.8, 1.2);
Del_t = 0.05;

%% full size figure
figure

m = size(site_xy,1);
[ha, pos] = tight_subplot(m,m,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:m
        axes(ha(count));
        plot(time, pressure{i,j})
        xlim([-100,10])
        ylim([950,1030])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% calculate the PS indicator  for all pressure series

pressureEasy = cell(size(pressure));
timeEasy = time(1:20:end);
for i = 1:m
    for j = 1:m
        pressureEasy{i,j} = pressure{i,j}(1:20:end);
    end
end

windowSize = 90;
PS_indicator = cell(size(pressure));
for i = 1:m
    for j = 1:m
        PS_indicator{i,j} = PSE_sliding(pressureEasy{i,j},windowSize);
        [i,j]
    end
end

%% full size PSE figure
figure
[ha, pos] = tight_subplot(m,m,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:m
        axes(ha(count));
        plot(timeEasy, PS_indicator{i,j})
        xlim([-100,10])
        ylim([-2,3])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% For each site, find() the minimum pressure and then calculate the 
%  Mann-Kendall S for the PS series in the range T_event-50:T_event

KendallWS = 48;
KendallS_PS = zeros(size(pressure));
T_eventEasy = floor(T_event/20)+1;
for i = 1:m
    for j = 1:m
        
        KendallS_PS(i,j) = mannkendall(...
            PS_indicator{i,j}(T_eventEasy-KendallWS:T_eventEasy));
        
    end
end
    
%%

figure
hold on
contourf(KendallS_PS);
% for i = 1:m
%     for j = 1:m
%         text(j,i,num2str(KendallS_PS(i,j)))    
%     end
% end
set(gca,'ydir','reverse')