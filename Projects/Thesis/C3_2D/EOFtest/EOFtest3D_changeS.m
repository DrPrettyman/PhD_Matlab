%% 
% In this script we create a matrix $B$ such that the first 
% eigenvalue approaches 1 from below.
%
% We then run the system 
%           $$ x_{n+1} = Bx_{n} + S\eta $$
% where \eta is white noise

%% definitions
% dimension of system
% dim = 3;
% dim = 4;
dim = 5;
% the matrix of eigenvalues
TopLeftMat = zeros(dim); TopLeftMat(1,1) = 1;
Lambda = @(k)(k*10^(-6)*TopLeftMat+0.9*eye(dim));
% the noise std
sigma = 0.05;
% the initial point
x_0 = zeros(dim,1); 
% the end time
N = 10^5;
% the start and end times of segments
N1start = 1*10^4;
N1end = 2*10^4;
N2start = 4.5*10^4;
N2end = 5.5*10^4;
N3start = 8*10^4;
N3end = 9*10^4;
% The matrix S
S = @(theta)( sigma*( cos(theta)*eye(dim)+...
    (sin(theta)/sqrt(dim-1))*(ones(dim)-eye(dim)) ));
% the number of different theta values
noThetas = 30;
% the range of theta values
maxTheta = atan(sqrt(dim-1));
theta_vals = (linspace(0,maxTheta,noThetas))';
% number of trials performed at each theta value
noTrials = 10;

%% Variable holders
% all EOF eigenvector angles at each theta value
VectorAngles1 = zeros(noThetas,noTrials);
VectorAngles2 = zeros(noThetas,noTrials);
VectorAngles3 = zeros(noThetas,noTrials);

%% We loop over the theta values
for i = 1:noThetas
    theta = theta_vals(i);
    disp(['theta = ',num2str(theta)])
    for j = 1:noTrials
        disp(['   trial no. ',num2str(j)])
        X1 = zeros(dim,N);
        X1(:,1) = x_0;   
        for k = 2:N
            X1(:,k) = Lambda(k)*X1(:,k-1) + S(theta)*randn(dim,1);
        end
        
        segment1 = X1(:,N1start:N1end);
        segment2 = X1(:,N2start:N2end);
        segment3 = X1(:,N3start:N3end);
        % for segment 1
        [Ts1, Ws1] = EOF1(segment1');
        if acos(Ws1(1))>pi/2; Ws1 = -Ws1; end
        VectorAngles1(i,j) = acos(Ws1(1));
        % for segment 2
        [Ts2, Ws2] = EOF1(segment2');
        if acos(Ws2(1))>pi/2; Ws2 = -Ws2; end
        VectorAngles2(i,j) = acos(Ws2(1));
        % for segment 3
        [Ts3, Ws3] = EOF1(segment3');
        if acos(Ws3(1))>pi/2; Ws3 = -Ws3; end
        VectorAngles3(i,j) = acos(Ws3(1));
    end
end

%% Calculate the mean and std

meanVectorAngles1 = mean(VectorAngles1,2);
stdVectorAngles1 = std(VectorAngles1,0,2);

meanVectorAngles2 = mean(VectorAngles2,2);
stdVectorAngles2 = std(VectorAngles2,0,2);

meanVectorAngles3 = mean(VectorAngles3,2);
stdVectorAngles3 = std(VectorAngles3,0,2);

%% Keep all the variables in a structure to be saved

Struct_EOFchangeS = struct;

Struct_EOFchangeS.description = 'The system $x_{k+1} = \Lambda x_k +S\eta$. $x$ is two-dimensional, $\Lambda$ is diag(0.9+k*10^{-6}, 0.9). $S$ is allowed to vary so that the system is either uncoupled (S = I) or coupled (S=ones) with a range of values inbetween';
Struct_EOFchangeS.note = 'The series X and the argument angle of the EOF vector calculated in half-overlapping segments of length 1000';

Struct_EOFchangeS.theta_vals = theta_vals;

Struct_EOFchangeS(1).k_range = [N1start N1end];
Struct_EOFchangeS(2).k_range = [N2start N2end];
Struct_EOFchangeS(3).k_range = [N3start N3end];

Struct_EOFchangeS(1).VectorAngles = VectorAngles1;
Struct_EOFchangeS(2).VectorAngles = VectorAngles2;
Struct_EOFchangeS(3).VectorAngles = VectorAngles3;

Struct_EOFchangeS(1).meanVectorAngles = meanVectorAngles1;
Struct_EOFchangeS(1).stdVectorAngles = stdVectorAngles1;
Struct_EOFchangeS(2).meanVectorAngles = meanVectorAngles2;
Struct_EOFchangeS(2).stdVectorAngles = stdVectorAngles2;
Struct_EOFchangeS(3).meanVectorAngles = meanVectorAngles3;
Struct_EOFchangeS(3).stdVectorAngles = stdVectorAngles3;

%% Plot

figure
title('segment 1')
hold on
for j = 1:noTrials
    scatter(theta_vals,VectorAngles1(:,j))
end

figure
title('segment 2')
hold on
for j = 1:noTrials
    scatter(theta_vals,VectorAngles2(:,j))
end

figure
title('segment 3')
hold on
for j = 1:noTrials
    scatter(theta_vals,VectorAngles3(:,j))
end
