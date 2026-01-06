load('cyclones100')

HurricaneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noH = size(HurricaneList,1);

time_axis = (1:size(cyclones100(1).slp_data,1))' - cyclones100(1).event_index;



%%
fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,35,12];
fig1.Resize = 'off';
hold on
for j = 1:noH
    cy = HurricaneList(j);
    plot(time_axis,cyclones100(cy).slp_data,'LineWidth',1.7)
end
xticks((-24*10:24:24*10));
xlim([-130,40])

xlabel({'Time (hours)'})
ylabel({'SLP (hPa)'})


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
