
load('cyclones100')

%%

cycloneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noCy = size(cycloneList,1);

huge3DarrayACF1 = zeros(121,145,noCy);
huge3DarrayPS = zeros(121,145,noCy);
huge3DarrayDFA = zeros(121,145,noCy);

for i = 1:noCy
    cy = cycloneList(i);
    
    huge3DarrayACF1(:,:,i) = cyclones100(cy).ACF1_sensitivity;
    huge3DarrayPS(:,:,i) = cyclones100(cy).PS_sensitivity;
    huge3DarrayDFA(:,:,i) = cyclones100(cy).DFA_sensitivity;
end

meanACF1 = mean(huge3DarrayACF1,3);
meanPS = mean(huge3DarrayPS,3);
meanDFA = mean(huge3DarrayDFA,3);

%%
newIndex = 21;

cyclones100(newIndex).h_name = 'mean';
cyclones100(newIndex).ACF1_sensitivity = meanACF1;
cyclones100(newIndex).PS_sensitivity = meanPS;
cyclones100(newIndex).DFA_sensitivity = meanDFA;

