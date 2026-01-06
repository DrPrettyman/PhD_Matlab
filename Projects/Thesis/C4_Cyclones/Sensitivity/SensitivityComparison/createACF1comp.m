%% Create the structure ACFcomp

ACFcomp = Add_ACF(cyclones100_data, 40, false);
for i = [50:10:250]
    ACFcomp = Add_ACF(ACFcomp, i, false);
end

ACFcomp(15).h_name = 'mean';
ACFcomp(16).h_name = 'std';

for i = [40:10:250]
    [attrMean, attrStd] = plot_attribute(ACFcomp, ['ACF',num2str(i)], [1:14]);
    ACFcomp(15).(['ACF',num2str(i)]) = attrMean;
    ACFcomp(16).(['ACF',num2str(i)]) = attrStd;
end


ACFmeans = zeros(size([40:10:250], 2), size(ACFcomp(15).ACF40, 2));
dummy = [40:10:250];
for i = 1:size([40:10:250], 2)
    ACFmeans(i,:) = ACFcomp(15).(['PSE',num2str(dummy(i))]);
end