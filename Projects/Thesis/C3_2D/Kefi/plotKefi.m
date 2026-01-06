function [outputArg1] = plotKefi(Z,t)

n = size(Z,1);

c = @(x)((-0.3*x+0.4)*[1 0 1]+[0 0.7 0]);

z = Z(:,:,t);

fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,15,15];
fig1.Resize = 'off';
hold on



for p = [-1,0,1]
    col = c(p);
    [i,j] = find(z==p);
    scatter(i,j,200,col, 'filled');
end

%yticks();

xlabel({'i'},'interpreter', 'latex')
ylabel({'j'},'interpreter', 'latex')


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



end

