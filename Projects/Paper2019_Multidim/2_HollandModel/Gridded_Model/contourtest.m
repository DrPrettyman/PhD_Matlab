

P = [[3 4 5];[10 12 7];[2 7 9]];

figure
hold on
contourf(P);
for i = 1:3
    for j = 1:3
        text(j,i,num2str(P(i,j)))
        
        
    end
end
set(gca,'ydir','reverse')