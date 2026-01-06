
%% 
% In this script we create a matrix $B$ such that the first 
% eigenvalue approaches 1 from below.
%
% We then run the system 
%           $$ x_{n+1} = Bx_{n} + S\eta $$
% where \eta is white noise

%%
% First, the matrix of eigenvalues
Lambda = @(k)([[ 0.9+k*10^(-6) ; 0 ],[ 0 ; 0.9 ]]);

% Now, the matrix of eigenvectors, W
R = @(theta,phi)([[cos(theta);sin(theta)],...
    [-sin(phi); cos(phi)]]);
W = R(10*randn(1),10*randn(1));
Arg_W = atan(W(2,1)/W(1,1));
disp(['leading eigenvector angle = ',num2str(Arg_W)])

% Then the matrix B
B = @(k)(W*Lambda(k)*inv(W));

% We define the noise term and the initial point
S = 0.1*randn(2);
x_0 = zeros(2,1);

%% 

% we run the system
N = 1.03*10^5;
X = zeros(2,N);
X(:,1) = x_0;
for k = 2:N
    X(:,k) = B(k)*X(:,k-1) + S*randn(2,1);
end

%%

% and plot the result
figure
subplot(1,2,1)
plot(X(1,:),X(2,:))
title('dynamical system (upto k=N')
xlabel('x')
ylabel('y')
subplot(1,2,2)
plot(X(1,1:0.8*10^5),X(2,1:0.8*10^5))
title('dynamical system (before bifurcation)')
xlabel('x')
ylabel('y')

% **** NOTE *****
% We see that after time 10^5, the first eigenvalue equals 1 and the
% system diverges in the direction of the first eigenvector:
%           w = [cos(theta) ; sin(theta)]
% 

%%

% We also calculate the EOF score (and eigenvector) for the whole
% system.
[T, W_eof] = EOF1(X');

% How does this compare to the first eigenvector of B?
disp(['difference in angles = ',...
    num2str(abs(Arg_W - atan(W_eof(2)/W_eof(1))))])

% But what about before the birfurctation? 
% We consider the window 8*10^4 < k < 9*10^4
segment = X(:,8*10^4:9*10^4);
[T, W_eof_seg] = EOF1(segment');

disp(['difference in angles (segment only) = ',...
    num2str(abs(Arg_W - atan(W_eof_seg(2)/W_eof_seg(1))))])

%%

% Let's do this for half-overlapping segments
% of length 10^3
% and now inspect the the change in the argument angle of the EOF
% eigenvector
segSize = 10^3;
N_segments = floor(N/(segSize/2));
ArgAngle = zeros(N_segments,1);
ArgAngleDifference = zeros(N_segments,1);
for i = 1:N_segments
    segment = X(:,1+(segSize/2)*(i-1):i*(segSize/2));
    [Ts, Ws] = EOF1(segment');
    ArgAngle(i) = atan(Ws(2)/Ws(1));
    ArgAngleDifference(i) = abs(ArgAngle(i) - Arg_W);
end

figure
plot(ArgAngle)
title('EOF eigenvector angle')
xlabel('segment #')
ylabel('angle (radians)')

figure
plot(ArgAngleDifference)
title('Difference in eigenvector angles')
xlabel('segment #')
ylabel('angle difference (radians)')


