function [outputArg1] = plotKefi_animate(Z)
mksz = 200;
n = size(Z,1);
N = size(Z,3);

c = @(x)((-0.3*x+0.4)*[1 0 1]+[0 0.7 0]);

fontsize = 18;

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,15,15];
fig1.Resize = 'off';
hold on

z = Z(:,:,1);
for p = [-1,0,1]
    col = c(p);
    [i,j] = find(z==p);
    scatter(i,j,mksz,col, 'filled');
end

%yticks();

xlim([0,n])
ylim([0,n])

xlabel({'i'},'interpreter', 'latex')
ylabel({'j'},'interpreter', 'latex')


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

drawnow


for t = 1:floor(N/100):N
    t
    z = Z(:,:,t);
    for p = [-1,0,1]
        col = c(p);
        [i,j] = find(z==p);
        scatter(i,j,mksz,col, 'filled');
    end
    drawnow
    pause(0.1)
end

end

