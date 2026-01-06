% In this script we create a matrix $B$, diagonal, such that the first 
% eigenvalue, also the first element, approaches 1 from below

B = @(k)([[ 0.9+k*10^(-6) , 0 ];[ 0 , 0.9 ]]);

% We define the noise term

S = [[0.2,0.3];[0.4,0.1]];

% We set the initial point

x_0 = [0 ; 0];

% we run the system

N = 10^5+2000;
X = zeros(2,N);

X(:,1) = x_0;

for k = 2:N
    X(:,k) = B(k)*X(:,k-1) + S*randn(2,1);
end

% and plot the result

figure
plot(X(1,:),X(2,:))
title('dynamical system')
xlabel('x')
ylabel('y')

%% 
% Now we look at the EOF series

[T, W] = EOF1(X', 0);

figure
plot(T)
title('EOF series')

% and now inspect the the change in the argument angle of the EOF
% eigenvector

segSize = 1000;
N_segments = floor(N/segSize);
ArgAngle = zeros(N_segments,1);

for i = 1:N_segments
    segment = X(:,1+segSize*(i-1):i*segSize);
    [Ts, Ws] = EOF1(segment');
    ArgAngle(i) = 180/pi*atan(Ws(2)/Ws(1));
end

figure
plot(ArgAngle)
title('EOF eigenvector angle')
xlabel('segment #')
ylabel('angle (degrees)')



