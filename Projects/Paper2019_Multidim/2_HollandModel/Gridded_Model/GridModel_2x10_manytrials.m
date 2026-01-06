%% obtain the result of N model runs

N = 10;

m = 16;
n = 4;
time_all = zeros(701,N);
pressure_all = cell(m,n);
for i = 1:m
    for j = 1:n
        pressure_all{i,j} = zeros(701,N);
    end
end
%[time, pressure, distance, cyclone_xy, site_xy]
for k = 1:N
    [time, pressure] = Grid_Holland_model(m,n,20,pi/3);
    time_all(:,k) = time;
    for i = 1:m
        for j = 1:n
            pressure_all{i,j}(:,k) = pressure{i,j};
        end
    end
end
clear time pressure i j k 
    

%% calculate the PS and ACF(1) indicator  for all pressure series
windowSize = 100;
PS_mean = cell(size(pressure_all));
PS_std = cell(size(pressure_all));
ACF1_mean = cell(size(pressure_all));
ACF1_std = cell(size(pressure_all));
for i = 1:m
    for j = 1:n
        PS_dummy = zeros(701,N);
        ACF_dummy = zeros(701,N);
        for k = 1:N
            event_index = find(time_all(:,k)==0);
            PS_dummy = PSE_sliding(pressure_all{i,j}(event_index-400:event_index+50,k),windowSize);
            ACF_dummy = ACF_sliding(pressure_all{i,j}(event_index-400:event_index+50,k),1,windowSize);
        end
        PS_mean{i,j} = mean(PS_dummy,2);
        ACF1_mean{i,j} = mean(ACF_dummy,2);
        PS_std{i,j} = std(PS_dummy')';
        ACF_std{i,j} = std(ACF_dummy')';
    end
    disp(num2str(i))
end
clear PS_dummy ACF_dummy windowSize event_index i j k

%% PSE figure
figure
[ha, pos] = tight_subplot(m,n,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:n
        axes(ha(count));
        plot(PS_mean{i,j})
        xlim([300,401])
        ylim([-2,3])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');
clear ha pos count i j

%% ACF(1) figure
figure
[ha, pos] = tight_subplot(m,n,[.01 .01],[.01 .01],[.01 .01]);
count = 1;
for i = 1:m
    for j = 1:n
        axes(ha(count));
        plot(ACF1_mean{i,j})
        xlim([300,401])
        ylim([0.8,1])
        count = count +1;
    end
end
set(ha,'XTickLabel',''); 
set(ha,'YTickLabel','');

%% For each site, find() the minimum pressure and then calculate the 
%  Mann-Kendall S for the PS series in the range T_event-100:T_event

KendallS_PS = zeros(size(pressure_all));
T=401;
for i = 1:m
    for j = 1:n       
        KendallS_PS(i,j) = mannkendall(...
            PS_mean{i,j}(T-100:T));
        %
        
    end
end
clear T i j 

%%
figure
contourf(KendallS_PS);
colormap(hot);
