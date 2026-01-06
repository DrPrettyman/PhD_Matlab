
%% 
% In this script we create a matrix $B$ such that the first 
% eigenvalue approaches 1 from below.
%
% We then run the system 
%           $$ x_{n+1} = Bx_{n} + S\eta $$
% where \eta is white noise

%% definitions
% the matrix of eigenvalues
Lambda = @(k)([[ 0.9+k*10^(-6) ; 0 ; 0],[ 0 ; 0.9 ; 0], [ 0 ; 0 ; 0.9]]);
% the noise std
sigma = 0.05;
% the initial point
x_0 = zeros(3,1); 
% the end time
N = 1.0*10^5;

%% First the two extreme cases
%           $$ x_{n+1} = \Lambda x_{n} + S\eta $$
% where S is either the identidy matrix (uncoupled variables) 
% or the matrix of ones (coupled)

% We define the noise term 
S = sigma*eye(3);  
% we run the system for X1
X1 = zeros(3,N);
X1(:,1) = x_0;   
for k = 2:N
    X1(:,k) = Lambda(k)*X1(:,k-1) + S*randn(3,1);
end

% We define the noise term 
S = sigma*(1/sqrt(3))*ones(3); 
% we run the system for X2
X2 = zeros(3,N);
X2(:,1) = x_0;   
for k = 2:N
    X2(:,k) = Lambda(k)*X2(:,k-1) + S*randn(3,1);
end

%% We calculate the EOF score (and eigenvector) 
% for  half-overlapping segments of length 10^3
% and now inspect the the change in the argument angle of the EOF
% eigenvector
segSize = 10^3;
N_segments = floor(N/(segSize/2));
ArgAngle1 = zeros(N_segments,1);
ArgAngle2 = zeros(N_segments,1);
for i = 1:N_segments
    segment1 = X1(:,1+(segSize/2)*(i-1):i*(segSize/2));
    [Ts, Ws] = EOF1(segment1');
    if acos(Ws(1))>pi/2
        Ws = -Ws;
    end
    ArgAngle1(i) = acos(Ws(1));
    
    segment2 = X2(:,1+(segSize/2)*(i-1):i*(segSize/2));
    [Ts, Ws] = EOF1(segment2');
    if acos(Ws(1))>pi/2
        Ws = -Ws;
    end
    ArgAngle2(i) = acos(Ws(1));
end

%% Keep all the variables in a structure to be saved

Struct_EOFextreme = struct;

Struct_EOFextreme.description = 'The system $x_{k+1} = \Lambda x_k +S\eta$. $x$ is two-dimensional, $\Lambda$ is diag(0.9+k*10^{-6}, 0.9). $S$ is the identity matrix in the first case and the ones matrix in the second case.';
Struct_EOFextreme.note = 'The series X and the argument angle of the EOF vector calculated in half-overlapping segments of length 1000';

Struct_EOFextreme(1).X = X1;
Struct_EOFextreme(2).X = X2;
Struct_EOFextreme(1).ArgAngle = ArgAngle1;
Struct_EOFextreme(2).ArgAngle = ArgAngle2;

%% Nice plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,28,28];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 0.5;
hold on

sp_w = 0.3;
sp_h = 0.3;
gap_w = 0.15;
gap_h = 0.08;

pos1 = [0.1 1-(sp_h+0.05) sp_w sp_h];
pos2 = pos1 - [0 sp_h+gap_h 0 0];

pos3 = pos1 + [sp_w+gap_w 0 0.1 0];
pos4 = pos2 + [sp_w+gap_w 0 0.1 0];

ax1 = subplot('Position',pos1);
hold on
plot(ax1, X1(1,:),X1(2,:),...
    'Color','k','LineWidth', linethickness)
xlabel({'$x$'},'Interpreter','latex')
ylabel({'$y$'},'Interpreter','latex')
xlim([-2,2]);
ylim([-2,2]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')




ax2 = subplot('Position',pos2);
hold on
plot(ax2, X2(1,:),X2(2,:),...
    'Color','k','LineWidth', linethickness)
%yticks([0.6 0.8 1 1.2 1.4])
xlabel({'$x$'},'Interpreter','latex')
ylabel({'$y$'},'Interpreter','latex')
xlim([-2,2]);
ylim([-2,2]);
%xticklabels([]);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')






ax3 = subplot('Position',pos3);
hold on
plot(ax3, ArgAngle1,...
    'Color','k','LineWidth', linethickness)
ylabel({'angle (radians)'},'Interpreter','latex')
xlabel({'segment #'},'Interpreter','latex')
xlim([0,200]);
%ylim([-2, 1.5]);
%xticklabels([]);
ann = annotation('textbox',...
    pos3 + [0.03 0 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

ax4 = subplot('Position',pos4);
hold on
plot(ax4, ArgAngle2,...
    'Color','k','LineWidth', linethickness)
ylabel({'angle (radians)'},'Interpreter','latex')
xlabel({'segment #'},'Interpreter','latex')
xlim([0,200]);
%ylim([-2, 1.5]);
%xticklabels([]);
ann = annotation('textbox',...
    pos3 + [0.03 0 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')


%% Nice plot
fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,18];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.5;
hold on

pos1 = [0.1 0.59 0.87 0.4];
pos2 = pos1 - [0 0.42 0 0];


ax1 = subplot('Position',pos1)
hold on
plot(ax1, (ArgAngle1),...
    'Color','k','LineWidth', linethickness)
ylabel({'angle (radians)'},'Interpreter','latex')
%xlabel({'segment #'},'Interpreter','latex')
xlim([0,200]);
ylim([0,pi/2]);
xticklabels([]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')




ax2 = subplot('Position',pos2)
hold on
plot(ax2, ArgAngle2,...
    'Color','k','LineWidth', linethickness)
ylabel({'angle (radians)'},'Interpreter','latex')
xlabel({'segment #'},'Interpreter','latex')
xlim([0,200]);
ylim([0,0.98]);
%ylim([-2, 1.5]);
%xticklabels([]);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')







