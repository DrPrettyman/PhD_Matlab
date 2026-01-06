%% Create the structure PSEcomp

PSEcomp = AddPSE(cyclones100_data, 40, false);
for i = [50:10:250]
    PSEcomp = AddPSE(PSEcomp, i, false);
end

PSEcomp(15).h_name = 'mean';
PSEcomp(16).h_name = 'std';

for i = [40:10:250]
    [attrMean, attrStd] = plot_attribute(PSEcomp, ['PSE',num2str(i)], [1:14]);
    PSEcomp(15).(['PSE',num2str(i)]) = attrMean;
    PSEcomp(16).(['PSE',num2str(i)]) = attrStd;
end