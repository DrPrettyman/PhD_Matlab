%% Create the structure ACFcomp



DFAcomp = Add_DFA2(branching, 100);

DFAcomp(15).h_name = 'mean';
DFAcomp(16).h_name = 'std';


NumCyclones = size([1:14],2);

allAttr = zeros(NumCyclones, size(DFAcomp(1).(['DFA2_',num2str(100)]),1));

for i = 1:14
    allAttr(i,:) = DFAcomp(i).(['DFA2_',num2str(100)]);
    
end
attrMean = mean(allAttr);
attrStd = std(allAttr);

DFAcomp(15).(['DFA2_',num2str(i)]) = attrMean;
DFAcomp(16).(['DFA2_',num2str(i)]) = attrStd;

