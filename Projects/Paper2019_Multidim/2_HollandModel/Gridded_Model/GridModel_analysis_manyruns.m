%% obtain the result of a model run
[time, pressure, distance, cyclone_xy, site_xy] = Grid_Holland_model(10,10,20,-pi/2);

%% calculate the PS indicator  for all pressure series
windowSize = 90;
PS_indicator = cell(size(pressure));
for i = 1:m
    for j = 1:n
        
    end
end

KendallS_PS = zeros(size(pressure));
for i = 1:m
    for j = 1:n
        PS_series = PSE_sliding(pressure{i,j},windowSize);
        
        pressure_series = pressure{i,j};
        T_event = find(pressure_series == min(pressure_series));
        
        KendallS_PS(i,j) = mannkendall(...
            PS_series(T_event-40:T_event));
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