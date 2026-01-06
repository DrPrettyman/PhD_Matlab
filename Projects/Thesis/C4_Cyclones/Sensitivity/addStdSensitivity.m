
load('cyclones100')

%%

cycloneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noCy = size(cycloneList,1);
windowsizes = (40:160)';

huge3DarrayACF1 = zeros(121,noCy);
huge3DarrayPS = zeros(121,noCy);
huge3DarrayDFA = zeros(121,noCy);

for i = 1:noCy
    cy = cycloneList(i);
    
    for j = 1:121
        huge3DarrayACF1(j,i) = std(cyclones100(cy).ACF1_sensitivity(j,1:end-48));
        huge3DarrayPS(j,i) = std(cyclones100(cy).PS_sensitivity(j,1:end-48));
        huge3DarrayDFA(j,i) = std(cyclones100(cy).DFA_sensitivity(j,1:end-48));
    end
end

stdACF1 = mean(huge3DarrayACF1,2);
stdPS = mean(huge3DarrayPS,2);
stdDFA = mean(huge3DarrayDFA,2);

%%

newIndex = 22;

cyclones100(newIndex).h_name = 'std';
cyclones100(newIndex).ACF1_sensitivity = stdACF1;
cyclones100(newIndex).PS_sensitivity = stdPS;
cyclones100(newIndex).DFA_sensitivity = stdDFA;
