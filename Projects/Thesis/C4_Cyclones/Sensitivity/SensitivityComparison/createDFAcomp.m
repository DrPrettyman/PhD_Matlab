%% Create the structure ACFcomp

%DFAcomp = Add_DFA2(cyclones100_data, 40);
for i = [50:10:250]
    DFAcomp = Add_DFA2(DFAcomp, i);
end

DFAcomp(15).h_name = 'mean';
DFAcomp(16).h_name = 'std';

for i = [40:10:250]
    [attrMean, attrStd] = plot_attribute(DFAcomp, ['DFA2_',num2str(i)], [1:14]);
    DFAcomp(15).(['DFA2_',num2str(i)]) = attrMean;
    DFAcomp(16).(['DFA2_',num2str(i)]) = attrStd;
end

DFAmeans = zeros(size([40:10:250], 2), size(DFAcomp(15).DFA40, 2));
dummy = [40:10:250];
for i = 1:size([40:10:250], 2)
    DFAmeans(i,:) = DFAcomp(15).(['DFA2_',num2str(dummy(i))]);
end