%% obtain the result of a model run
[time, pressure, distance, cyclone_xy, site_xy] = Grid_Holland_model(16,4,20,pi/3);

%% 2 by 10 figure
figure
m = size(site_xy,1);
n = size(site_xy,2);

[ha, pos] = tight_subplot(m,n,[.01 .01],[.01 .01],[.01 .01]);
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

%% calculate the PS and ACF(1) indicator  for all pressure series
windowSize = 100;
PS_indicator = cell(size(pressure));
ACF1_indicator = cell(size(pressure));
for i = 1:m
    for j = 1:n
        PS_indicator{i,j} = PSE_sliding(pressure{i,j},windowSize);
        ACF1_indicator{i,j} = ACF_sliding(pressure{i,j},1,windowSize);
    end
end

%% PSE figure
figure
[ha, pos] = tight_subplot(m,n,[.01 .01],[.01 .01],[.01 .01]);
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

%% ACF(1) figure
figure
[ha, pos] = tight_subplot(m,n,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:n
        axes(ha(count));
        plot(time, ACF1_indicator{i,j})
        xlim([-100,10])
        ylim([0.8,1])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% For each site, find() the minimum pressure and then calculate the 
%  Mann-Kendall S for the PS series in the range T_event-100:T_event

KendallWindowSize = 50;
KendallS_PS = zeros(size(pressure));
for i = 1:m
    for j = 1:n
        pressure_series = pressure{i,j};
        T_event = find(pressure_series == min(pressure_series));
        
        KendallS_PS(i,j) = mannkendall(...
            PS_indicator{i,j}(T_event-KendallWindowSize:T_event));
        %
        
    end
end

%%
figure
contourf(KendallS_PS);
colormap(hot);
