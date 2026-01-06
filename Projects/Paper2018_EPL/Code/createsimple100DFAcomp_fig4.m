%% Create the structure ACFcomp

%short_model = branching;
%for i=1:100
%    short_model(i).slp_data = short_model(i).z(1:600);
%end


%DFAcomp = Add_DFA2(short_model, 100);

DFAcomp(101).h_name = 'mean';
DFAcomp(102).h_name = 'std';


NumCyclones = size([1:100],2);

allAttr = zeros(NumCyclones, size(DFAcomp(1).(['DFA2_',num2str(100)]),1));

for i = 1:100
    allAttr(i,:) = DFAcomp(i).(['DFA2_',num2str(100)]);
    
end
attrMean = mean(allAttr);
attrStd = std(allAttr);

DFAcomp(101).(['DFA2_',num2str(i)]) = attrMean;
DFAcomp(102).(['DFA2_',num2str(i)]) = attrStd;

