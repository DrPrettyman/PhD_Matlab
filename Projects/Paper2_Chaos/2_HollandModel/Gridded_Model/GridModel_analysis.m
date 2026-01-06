%% obtain the result of a model run
[time, pressure, distance, cyclone_xy, site_xy] = Grid_Holland_model(10,10,20,-pi/2);

%% 4 by 4 figure
figure
m = size(site_xy,1);
n = size(site_xy,2);

[ha, pos] = tight_subplot(4,4,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:3:m
    for j = 1:3:n
        axes(ha(count));
        plot(time, pressure{i,j}, 'LineWidth', 2, 'Color', 'black')
        xlim([-100,10])
        ylim([900,1030])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% 10 by 10 figure
figure
m = size(site_xy,1);
n = size(site_xy,2);

[ha, pos] = tight_subplot(10,10,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:n
        axes(ha(count));
        plot(time, pressure{i,j})
        xlim([-100,10])
        ylim([900,1030])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% calculate the PS indicator  for all pressure series
windowSize = 100;
PS_indicator = cell(size(pressure));
for i = 1:m
    for j = 1:n
        PS_indicator{i,j} = PSE_sliding(pressure{i,j},windowSize);
    end
end



%% 4 by 4 PSE figure
figure
[ha, pos] = tight_subplot(4,4,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:3:m
    for j = 1:3:n
        axes(ha(count));
        plot(time, PS_indicator{i,j})
        xlim([-100,10])
        ylim([-2,3])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');


%% 10 by 10 PSE figure
figure
[ha, pos] = tight_subplot(10,10,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:n
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
%  Mann-Kendall S for the PS/ACF1 series in the range T_event-100:T_event

KendallWindowSize = 100;
KendallS_PS = zeros(size(pressure));
for i = 1:m
    for j = 1:n
        pressure_series = pressure{i,j};
        T_event = find(pressure_series == min(pressure_series));
        
        KendallS_PS(i,j) = mannkendall(...
            PS_indicator{i,j}(T_event-40:T_event));
        %T_event-KendallWindowSize:T_event
        
    end
end
    
%%

figure
hold on
contourf(KendallS_PS);
% for i = 1:m
%     for j = 1:n
%         text(j,i,num2str(KendallS_PS(i,j)))    
%     end
% end
set(gca,'ydir','reverse')