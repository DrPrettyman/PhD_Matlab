

%load('cyclones100.mat')
indices = [1:8,12,13,14,16,17,19];
NumCyclones = size(indices,2);
event_index = cyclones100(1).event_index;

xaxis = (0:48)';
AllCyclones48 = zeros(NumCyclones, 49);
for i = 1:NumCyclones
    AllCyclones48(i,:) =...
        cyclones100(indices(i)).slp_data_RO12((event_index-48):event_index);
end
MeanCyclone48 = mean(AllCyclones48)';



power = 2.6;

figure
ax1 = subplot(1,1,1);
hold on
m = MeanCyclone48;
m = AllCyclones48(7,:)';

for power = 2:12
    model = m(1)+m(end)*((xaxis/48).^power);
    
%plot(xaxis, m, 'LineStyle','--', 'Color',0.7*[1,1,1])
%plot(xaxis, model, 'LineStyle','-', 'Color',0.2*[1,1,1])
    plot(xaxis, m-model)
end
