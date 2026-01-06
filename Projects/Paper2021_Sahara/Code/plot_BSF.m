%% Plot BSF

figure

m_lon = size(lon,1);
m_lat = size(lat,1);
[ha, pos] = tight_subplot(m_lat,m_lon,[.01 .01],[.01 .01],[.01 .01]);

global_xlim = [0, 8000];
global_ylim = [-0.1, 0.5];
count = 1;
for j = 1:m_lat
    for i = 1:m_lon
        axes(ha(count));
        if ~all(BSF{i,j}==0)
            plot(time, BSF{i,j})
            xticklabels('')
            yticklabels('')
            xlim(global_xlim)
            ylim(global_ylim)
        end
        count = count +1;
    end
end
%set(ha,'XTickLabel',''); 
%set(ha,'YTickLabel','');