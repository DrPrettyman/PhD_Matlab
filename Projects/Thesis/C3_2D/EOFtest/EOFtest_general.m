
%% 
% In this script we create a matrix $B$ such that the first 
% eigenvalue approaches 1 from below.
%
% We then run the system 
%           $$ x_{n+1} = Bx_{n} + S\eta $$
% where \eta is white noise

%% definitions
% the matrix of eigenvalues
Lambda = @(k)([[ 0.9+k*10^(-6) ; 0 ],[ 0 ; 0.9 ]]);
% the eigenvector matrix
R = @(theta,phi)([[cos(theta);sin(theta)],...
    [-sin(phi);cos(phi)]]);

%% Parameters 
% the initial point
x_0 = zeros(2,1); 
% the end time
N = 1.0*10^5;
% the number of trials
NoTrials = 3;
% Number of segments
segSize = 10^3;
NoSegments = floor(N/(segSize/2));

%% Variables 
S1 = eye(2);
S2 = eye(2)+[[0;1],[1;0]];
ArgDif1 = zeros(NoSegments, NoTrials);
ArgDif2 = zeros(NoSegments, NoTrials);

%% Loop over the trials 
for i = 1:NoTrials
    disp(['Trial #',num2str(i)])
    % create the eigenvector matrix W and thus B
    W = R(2*pi*rand,2*pi*rand);
    %W = eye(2);
    B = @(k)(W*Lambda(k)*inv(W));
    % the argument angle of W
    ArgW = atan(W(2,1)/W(1,1));
    % loop over N using S1 and S2
    X1 = zeros(2,N);
    X1(:,1) = x_0; 
    X2 = zeros(2,N);
    X2(:,1) = x_0; 
    for k = 2:N
        X1(:,k) = B(k)*X1(:,k-1) + S1*randn(2,1);
        X2(:,k) = B(k)*X2(:,k-1) + S2*randn(2,1);
    end
    % EOF for both series in half-overlapping segments of length
    % segSize
    ArgAngle1 = zeros(NoSegments,1);
    ArgAngle2 = zeros(NoSegments,1);
    for j = 1:NoSegments
        segment1 = X1(:,1+(segSize/2)*(j-1):j*(segSize/2));
        [Ts, Ws] = EOF1(segment1');
        if acos(Ws(1))>pi/2
            Ws = -Ws;
        end
        ArgAngle1(j) = atan(Ws(2)/Ws(1));
        segment2 = X2(:,1+(segSize/2)*(j-1):j*(segSize/2));
        [Ts, Ws] = EOF1(segment2');
        if acos(Ws(1))>pi/2
            Ws = -Ws;
        end
        ArgAngle2(j) = atan(Ws(2)/Ws(1));
    end
    ArgDif1(:,i) = ArgAngle1-ArgW;
    ArgDif2(:,i) = ArgAngle2-ArgW;
end

%% Calculate the means
meanArgDif1 = mean(ArgDif1,2);
meanArgDif2 = mean(ArgDif2,2);

%% Plot
figure
subplot(1,2,1)
hold on
for i = 1:NoTrials
    plot(ArgDif1(:,i))
end
plot(meanArgDif1,'LineWidth',3)
subplot(1,2,2)
hold on
for i = 1:NoTrials
    plot(ArgDif2(:,i))
end
plot(meanArgDif2,'LineWidth',3)


