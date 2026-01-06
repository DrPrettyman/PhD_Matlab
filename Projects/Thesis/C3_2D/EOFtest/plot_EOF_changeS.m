%% Load save data 
%load('EOFchangeS_data')
%load('EOF3DchangeS_data')
%load('EOF4DchangeS_data')
load('EOF5DchangeS_data')

%% and create local variables for ease
Phi = Struct_EOFchangeS(1).theta_vals;

Theta1 = Struct_EOFchangeS(1).VectorAngles;
Theta2 = Struct_EOFchangeS(2).VectorAngles;
Theta3 = Struct_EOFchangeS(3).VectorAngles;

mTheta1 = Struct_EOFchangeS(1).meanVectorAngles;
mTheta2 = Struct_EOFchangeS(2).meanVectorAngles;
mTheta3 = Struct_EOFchangeS(3).meanVectorAngles;

sTheta1 = Struct_EOFchangeS(1).stdVectorAngles;
sTheta2 = Struct_EOFchangeS(2).stdVectorAngles;
sTheta3 = Struct_EOFchangeS(3).stdVectorAngles;

noTrials = size(Theta1,2);
%%


fontsize = 18;
Msz = 50; % Marker size
c1=0.8*[0 0 1]; % plot colours
c2=0.6*[1 0 1];
c3=0.9*[1 0 0];

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,15];
fig1.Resize = 'off';
hold on
for j = 1:noTrials
    scatter(Phi,Theta1(:,j),Msz,c1,'o','filled')
    scatter(Phi,Theta2(:,j),Msz,c2,'d','filled')
    scatter(Phi,Theta3(:,j),Msz,c3,'s','filled')
end
xlim([0,pi/4])
xticks([0,pi/4])
xticklabels({'\phi = 0','\phi = \pi/4'})

xlabel({'value of \phi'})
ylabel({'EOF eigenvector angle (radians)'})


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
