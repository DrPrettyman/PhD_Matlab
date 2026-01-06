%% Create the structure PSEcomp

ws_range = [80:200];

PSEcomp = Add_PSE(cyclones100_data, ws_range(1), false);
for i = ws_range(2:end)
    PSEcomp = Add_PSE(PSEcomp, i, false);
    disp(['done',num2str(i)])
end

PSEcomp(15).h_name = 'mean';
PSEcomp(16).h_name = 'std';

for i = ws_range
    [attrMean, attrStd] = plot_attribute(PSEcomp, ['PSE',num2str(i)], [1:14]);
    PSEcomp(15).(['PSE',num2str(i)]) = attrMean;
    PSEcomp(16).(['PSE',num2str(i)]) = attrStd;
end


PSEmeans = zeros(size(ws_range, 2), size(PSEcomp(15).PSE36, 2));
for i = 1:size(ws_range, 2)
    PSEmeans(i,:) = PSEcomp(15).(['PSE',num2str(ws_range(i))]);
end