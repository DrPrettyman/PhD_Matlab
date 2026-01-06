
T_end = 60;
N=10;
delT = 0.2;
windowsize = 100;

all_EOF_ACF1_series = zeros(301-windowsize, N);
all_EOFsliding_series = zeros(301-windowsize, N);
all_EOFupto_series = zeros(301-windowsize, N);
for trial = 1:N
    % start with x near the center
    x_0 = 0.001*randn(2,1);
    
    % Integrate the system in hopf_fun.m with mu a function
    %  of t which increses from -2.8 to 0.2 as t goes from 0 to 6.
    %  Standard deviation of the noise is 0.01
    [tout, rout]=hopf_fun(0,T_end,x_0,@(t)(-2.9+0.05*t),0.01);
    xout = zeros(size(rout));

    xout(:,1) = rout(:,1).*cos(rout(:,2));
    xout(:,2) = rout(:,1).*sin(rout(:,2));
    
    tout = tout(1:20:end,:);
    xout = xout(1:20:end,:);

    
    % Apply the EOF method to the data and then the ACF1 indicator
    [EOF1score, eigenvector] = EOF1(xout, true);
    ACF_series = ACF_sliding(EOF1score,1,windowsize);
    ACF_series = ACF_series(windowsize+1:end);
    all_EOF_ACF1_series(:,trial) = ACF_series;
    
    EOFsliding_series =...
        EOF_sliding(xout, windowsize, 'ACF1');
    all_EOFsliding_series(:,trial) = EOFsliding_series(windowsize+1:end);
    
    EOFupto_series =...
        EOF_sliding_upto(xout, windowsize, 'ACF1');
    all_EOFupto_series(:,trial) = EOFupto_series(windowsize+1:end);
    
    disp(num2str(trial))
end

%%

mean_EOFACF1 = mean(all_EOF_ACF1_series,2);
std_EOFACF1 = std(all_EOF_ACF1_series,0,2);

mean_EOFsliding = mean(all_EOFsliding_series,2);
std_EOFsliding = std(all_EOFsliding_series,0,2);

mean_EOFupto = mean(all_EOFupto_series,2);
std_EOFupto = std(all_EOFupto_series,0,2);

%% plot result

figure
plot(linspace(0,60,6001), rout(:,1))
figure
plot(linspace(0,60,6001), rout(:,2))

%%
time_axis = (20:0.2:T_end)';
figure
title('Homoclinic-bifurcation, EOF + ACF1')
hold on
plot(time_axis, mean_EOFACF1,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_EOFACF1-std_EOFACF1,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_EOFACF1+std_EOFACF1,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')

figure
title('Homoclinic-bifurcation, EOFsliding-ACF1')
hold on
plot(time_axis, mean_EOFsliding,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_EOFsliding-std_EOFsliding,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_EOFsliding+std_EOFsliding,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')

figure
title('Homoclinic-bifurcation, EOFupto-ACF1')
hold on
plot(time_axis, mean_EOFupto,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_EOFupto-std_EOFupto,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_EOFupto+std_EOFupto,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')


%% organise in a structure

HopfEOFData = struct;

HopfEOFData.notes = ['Hopf bifurcation example, mu = @(t)(-2.9+0.05*t)'];

HopfEOFData.time = time_axis;
HopfEOFData.N = N;
HopfEOFData.delT = delT;
HopfEOFData.windowsize = windowsize;

HopfEOFData.mean_ACF1 = mean_EOFACF1;
HopfEOFData.mean_EOFsliding = mean_EOFsliding;
HopfEOFData.mean_EOFupto = mean_EOFupto;

HopfEOFData.std_ACF1 = std_EOFACF1;
HopfEOFData.std_EOFsliding = std_EOFsliding;
HopfEOFData.std_EOFupto = std_EOFupto;
