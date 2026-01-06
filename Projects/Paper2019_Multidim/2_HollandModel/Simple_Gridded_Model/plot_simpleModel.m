
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
windowSize = floor(90/Del_t);
PS_indicator = cell(size(pressure));
for i = 1:m
    for j = 1:m
        PS_indicator{i,j} = PSE_sliding(pressure{i,j},windowSize);
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
        plot(time, PS_indicator{i,j})
        xlim([-100,10])
        ylim([-2,3])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% For each site, find() the minimum pressure and then calculate the 
%  Mann-Kendall S for the PS series in the range T_event-50:T_event

KendallWS = floor(48/Del_t);
KendallS_PS = zeros(size(pressure));
for i = 1:m
    for j = 1:m
        
        KendallS_PS(i,j) = mannkendall(...
            PS_indicator{i,j}(T_event-KendallWS:T_event));
        
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