
N = 10;

m = 10;
Del_t = 0.05;
windowSize = floor(90/Del_t);
KendallWS = floor(48/Del_t);

MassivePressure = cell(N,1);
MassivePS = cell(N,1);
MassiveKendall = cell(m,m);

for j = 1:m
    for k = 1:m
        MassiveKendall{j,k} = zeros(N,1);
    end
end

for i = 1:N
    disp(['Starting model trail ',num2str(i)])
    [time, pressure, site_xy, T_event] = simpleGridModel(m, 40, 0.8, 1.2);

    PS_indicator = cell(m,m);
    for j = 1:m
        for k = 1:m
            PS_indicator{j,k} = PSE_sliding(pressure{j,k},windowSize);
            [j,k]
        end
    end
    
    for j = 1:m
        for k = 1:m
            MassiveKendall{j,k}(i) = mannkendall(...
                PS_indicator{j,k}(T_event-KendallWS:T_event));
            
        end
    end
    
    MassivePressure{i} = pressure;
    MassivePS{i} = PS_indicator;
    
    clear pressure PS_indicator
end

MeanKendall = zeros(m,m);
for j = 1:m
    for k = 1:m
        MeanKendall(j,k) = mean(MassiveKendall{j,k});
    end
end
  

%%
figure
hold on
contourf(MeanKendall);
set(gca,'ydir','reverse')