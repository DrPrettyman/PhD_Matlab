load('branching_basic.mat')

n = size(branching,2);
dum = zeros(n,1);
for i=1:n; dum(i) = 'm'; end
headers = cellstr([dum, num2str((0:n-1)')])';
headers = [headers, {'mean_pse', 'std_pse', 'mean_acf', 'std_acf'}];


% windowchoice: 1 - 24point. 2 - 48point. 3 - 120point. %%
%               4 - 240point. 5 - 360point. 6 - 480point.
windowchoice = 4;
array = zeros(1001, n+4);
for i = 1:n
    array(:,i) = branching(i).z;
end
stats = stats_ACFandPSE(branching);
array(:,n+1) = stats(windowchoice).mPSE;
array(:,n+2) = stats(windowchoice).sPSE;
array(:,n+3) = stats(windowchoice).mACF;
array(:,n+4) = stats(windowchoice).sACF;

csvwrite_with_headers('branching_model_data.csv',...
    array,headers);

