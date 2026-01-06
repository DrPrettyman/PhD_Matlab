
%%
counter = 1;
MassiveArray = zeros(10001,120);
MassiveArrayPS = zeros(10001,120);
for i = 1:10
    for j = 3:6
        for k = 8:10
            MassiveArray(:,counter) = MassivePressure{i,1}{k,j};
            MassiveArrayPS(:,counter) = MassivePS{i,1}{k,j};
            counter = counter+1;
        end
    end
end

%%
meanMassivePS = mean(MassiveArrayPS,2);
meanMassiveArray = mean(MassiveArray,2);

stdMassivePS = std(MassiveArrayPS')';
stdMassiveArray = std(MassiveArray')';

%%
figure 
hold on
plot(time,meanMassivePS)
plot(time,meanMassivePS+stdMassivePS)
plot(time,meanMassivePS-stdMassivePS)
xlim([-150,0])
figure 
hold on
plot(time,meanMassiveArray)
plot(time,meanMassiveArray+stdMassiveArray)
plot(time,meanMassiveArray-stdMassiveArray)
xlim([-150,0])