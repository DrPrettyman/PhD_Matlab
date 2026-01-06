
%% Calculate the first EOF score of the slp and windspeed variables
%  for each cyclone
load('SLP_and_WINDSPEED.mat')
for cyclone_no = 1:size(twoStruct,2)
    X = [twoStruct(cyclone_no).slp, twoStruct(cyclone_no).windspeed];
    twoStruct(cyclone_no).eof1 = EOF1(X);
    clear X        
end

%% Calcualte the Williamson and Lenton eigenvalues for each slp/ws pair
windowSize = 100;
T_end = size(twoStruct(cyclone_no).slp,1);

for cyclone_no = 1:size(twoStruct,2)
    twoStruct(cyclone_no).WL2 = ...
        plot_eigenvals_Jacobian([twoStruct(cyclone_no).slp, twoStruct(cyclone_no).windspeed]...
        , T_end, 100, 1, false);
end

%%
time_axis = (1:size(twoStruct(cyclone_no).WL,1))' - 1101;
all_WLrealvalues = zeros (size(time_axis,1), size(twoStruct,2));
figure
hold on
for cyclone_no = 1:size(twoStruct,2)
    all_WLrealvalues(:,cyclone_no) = twoStruct(cyclone_no).WL2(:,2);
    plot(time_axis, twoStruct(cyclone_no).WL2(:,2))
end

mean_realvals = mean(all_WLrealvalues,2);
std_realvals = std(all_WLrealvalues')';
plot(time_axis, mean_realvals, 'lineWidth', 2, 'color', 'black')
plot(time_axis, mean_realvals-std_realvals, 'lineStyle', '--', 'lineWidth', 1.5, 'color', 'black')
plot(time_axis, mean_realvals+std_realvals, 'lineStyle', '--', 'lineWidth', 1.5, 'color', 'black')

%% Save for grace plots
WL_wsslp = [time_axis, mean_realvals, std_realvals];
save('WL_wsslp2.dat', 'WL_wsslp', '-ascii')

%% Plot Imag parts
figure
hold on
for cyclone_no = 1:size(twoStruct,2)
    plot(time_axis, twoStruct(cyclone_no).WL2(:,3))
end