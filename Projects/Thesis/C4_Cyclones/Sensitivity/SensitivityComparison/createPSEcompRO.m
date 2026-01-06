%% Create the structure PSEcomp

TOP = 250;

PSEcompRO = Add_PSE(cyclones100_data, 40, true);
for i = [50:10:TOP]
    PSEcompRO = Add_PSE(PSEcompRO, i, true);
end

PSEcompRO(15).h_name = 'mean';
PSEcompRO(16).h_name = 'std';

for i = [40:10:TOP]
    [attrMean, attrStd] = plot_attribute(PSEcompRO, ['PSE',num2str(i),'_RO12'], [1:14]);
    PSEcompRO(15).(['PSE',num2str(i),'_RO12']) = attrMean;
    PSEcompRO(16).(['PSE',num2str(i),'_RO12']) = attrStd;
end

PSEcompRO(15).event_index = PSEcompRO(1).event_index;
PSEcompRO(16).event_index = PSEcompRO(1).event_index;

PSEmeans = zeros(size([40:10:TOP], 2), size(PSEcompRO(15).PSE40_RO12, 2));
dummy = [40:10:TOP];
for i = 1:size([40:10:TOP], 2)
    PSEmeans(i,:) = PSEcompRO(15).(['PSE',num2str(dummy(i)),'_RO12']);
end

