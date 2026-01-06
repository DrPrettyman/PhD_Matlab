
%load('cyclones100')

%%

cycloneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noCy = size(cycloneList,1);

huge3DarrayACF2 = zeros(121,145,noCy);
huge3DarrayACF3 = zeros(121,145,noCy);
huge3DarrayACF4 = zeros(121,145,noCy);
huge3DarrayACF6 = zeros(121,145,noCy);
huge3DarrayACF12 = zeros(121,145,noCy);

for i = 1:noCy
    cy = cycloneList(i);
    
    huge3DarrayACF2(:,:,i) = cyclones100(cy).ACF2_sensitivity;
    huge3DarrayACF3(:,:,i) = cyclones100(cy).ACF3_sensitivity;
    huge3DarrayACF4(:,:,i) = cyclones100(cy).ACF4_sensitivity;
    huge3DarrayACF6(:,:,i) = cyclones100(cy).ACF6_sensitivity;
    huge3DarrayACF12(:,:,i) = cyclones100(cy).ACF12_sensitivity;
end

meanACF2 = mean(huge3DarrayACF2,3);
meanACF3 = mean(huge3DarrayACF3,3);
meanACF4 = mean(huge3DarrayACF4,3);
meanACF6 = mean(huge3DarrayACF6,3);
meanACF12 = mean(huge3DarrayACF12,3);

%%

%newIndex = size(cyclones100,2)+1;
newIndex = 21;

cyclones100(newIndex).h_name = 'mean';
cyclones100(newIndex).ACF2_sensitivity = meanACF2;
cyclones100(newIndex).ACF3_sensitivity = meanACF3;
cyclones100(newIndex).ACF4_sensitivity = meanACF4;
cyclones100(newIndex).ACF6_sensitivity = meanACF6;
cyclones100(newIndex).ACF12_sensitivity = meanACF12;
