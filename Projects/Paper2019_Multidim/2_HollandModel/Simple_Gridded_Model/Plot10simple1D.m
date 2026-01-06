
N=100

%%
pressure = zeros(3001,N);
for k = 1:N
   [time_out, pressure_out, site_xy, eventIndex1] =...
       simpleGridModel(1, 20, 0.6, 1.5);
   
   indices = find(time_out>=-250 & time_out<=50);
   
   time_out = time_out(indices);
   pressure(:,k) = pressure_out{1,1}(indices);
end


%% Calculate PS and ACF(1)

PSindicator = zeros(size(pressure));
ACFindicator = zeros(size(pressure));
for k = 1:N
   PSindicator(:,k) = PSE_sliding(pressure(:,k), 200);
   ACFindicator(:,k) = ACF_sliding(pressure(:,k), 1, 200);
   disp(num2str(k))
end

%%

%%
figure
hold on
ax1 = subplot(3,1,1);
hold on
ax2 = subplot(3,1,2);
hold on
ax3 = subplot(3,1,3);
hold on

for k = 1:N
   plot(ax1, time_out, pressure(:,k))
   plot(ax2, time_out, ACFindicator(:,k))
   plot(ax3, time_out, PSindicator(:,k))
end
plot(ax1, time_out, mean(pressure,2), 'color','k','LineWidth',3)
plot(ax2, time_out, mean(ACFindicator,2), 'color','k','LineWidth',3)
plot(ax3,time_out, mean(PSindicator,2), 'color','k','LineWidth',3)

xlim(ax1, [-120,20])
xlim(ax2, [-120,20])
xlim(ax3, [-120,20])

%%

PoutArray = [time_out, pressure];

PSm = smoothing(mean(PSindicator,2));
PSs = std(PSindicator,0,2);
PSoutArray = [time_out, PSm, PSs];

ACFm = mean(ACFindicator,2)+0.3;
ACFs = std(ACFindicator,0,2)+0.03;
ACFoutArray = [time_out+35, ACFm, ACFs];


%save('XModelSimple100.dat','PoutArray', '-ascii')
%save('PSModelSimple100.dat','PSoutArray', '-ascii')
save('ACFModelSimple100.dat','ACFoutArray', '-ascii')



