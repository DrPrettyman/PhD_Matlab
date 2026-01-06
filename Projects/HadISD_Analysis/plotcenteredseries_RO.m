%% run plotcenteredseries.m first to load H and station_no into the workspace

plotACF = true;
plotDFA = false;
plotSEX = false;
smooth_data = false;

plotMean = false;
%% set up the line colours and x axis needed for the plots
%line_colours = rand(size(H,2),3);
line_colours = [[0,0,1];[1,0,1];[0,1,1];[0,1,0];[0,0,0];[1,0.5,0.2]];
xaxis = (1:size(H(1).slp_data_RO12,1))'-(floor((size(H(1).slp_data,1)+240)/2)+1);

% plot the slp data
figure
ax1 = subplot(1,2,1);
hold on
for i = 1:size(H,2)
%for i = 4:7
    col = line_colours(1+mod(i,6),:);
    plot(ax1, xaxis(241:end-140), H(i).slp_data_RO12(241:end-140), 'color', col);
    disp(['plotted slp ', H(i).h_name])
    LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end

if plotMean
    slp_array = [];
    for i = 1:size(H,2)
        slp_array = [slp_array, H(i).slp_data_RO12];
    end
    
    Mean_slp_data = mean(slp_array, 2);
   
    plot(ax1, xaxis(241:end-140), Mean_slp_data(241:end-140), 'LineWidth', 2 );
    clear slp_array
    LegendInfo{i+1} = 'Mean of all series';
    
end


%legend(LegendInfo, 'Location', 'southoutside');
%title(ax1,['All the storms, as recorded at station ', num2str(station_no), ' with 12-hoir oscilations removed from data'])
title(ax1,['All the storms'])
legend(LegendInfo, 'Location', 'southwest');
ylabel(ax1, 'de-seasonalised Sea Level Pressure');
xlim(ax1, [-200, 50]);
clear LegendInfo

if plotACF
    
    lag = 1;
    %return
    % plot the ACF-1 indicators, 240 point window
    ax2 = subplot(1,2,2);
    hold on
    for i = 1:size(H,2)
        %for i = 4:7
        col = line_colours(1+mod(i,6),:);
        H(i).sacf = ACF_sliding(H(i).slp_data_RO12, lag, 240, false);
        plot(ax2, xaxis(241:end-140), H(i).sacf(241:end-140), 'color', col, 'LineWidth', 0.3);
        disp(['plotted acf ', H(i).h_name])
        LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
    end
    
    
    if plotMean
        acf_array = [];
        for i = 1:size(H,2)
            acf_array = [acf_array, H(i).sacf];
        end
        m = mean(acf_array, 2);
        plot(ax2, xaxis(241:end-140), m(241:end-140), 'LineWidth', 2.5 );
        clear m acf_array
        LegendInfo{i+1} = 'Mean of all series';
        
        
        sacf = ACF_sliding(Mean_slp_data, lag, 240, false);
        plot(ax2, xaxis(241:end-140), sacf(241:end-140), 'color', 'k','LineStyle', ':','LineWidth', 2.5 );
        
    end

    %legend(LegendInfo, 'Location', 'southwest');
    ylabel(ax2, 'ACF-1 indicator');
    xlabel(ax2, 'Time since event (hours)');
    xlim(ax2, [-240, 0]);
    ylim(ax2, [0.9, 1]);
    clear LegendInfo sacf
    
    
    
elseif plotDFA
    
    % set the polynomial order for the DFA detrending
    order = 2;
    indices = (120:floor(120/6):size(H(1).slp_data,1))'-(floor((size(H(1).slp_data,1)+240)/2)+1);
    

    % plot the DFA indicators, 120 point window
    ax2 = subplot(1,2,2);
    hold on
    for i = 1:size(H,2)
        %for i = 4:7
        col = line_colours(1+mod(i,6),:);
        if ~isfield(H(i), 'dfa')
            H(i).dfa = DFA_sliding(H(i).slp_data_RO12, order, 120, false);
            disp(size(indices))
            disp(size(H(i).dfa))
        end
        plot(ax2, indices, H(i).dfa, 'color', col);
        %plot(ax2, dfa, 'color', col);
        disp(['plotted dfa ', H(i).h_name])
        LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
    end
    
    if plotMean
        dfa_array = [];
        for i = 1:size(H,2)
            dfa_array = [dfa_array, H(i).dfa];
        end
        m = mean(dfa_array, 2);
        plot(ax2, indices, m, 'LineWidth', 2.5 );
        clear m dfa_array
        LegendInfo{i+1} = 'Mean of all series';
        
        
        sdfa = DFA_sliding(Mean_slp_data, order, 120, false);
        plot(ax2, indices, sdfa, 'color', 'k','LineStyle', ':','LineWidth', 2.5 );
        
    end
    
    
    %legend(LegendInfo, 'Location', 'southwest');
    ylabel(ax2, 'DFA indicator');
    xlabel(ax2, 'Time since event (hours)');
    xlim(ax2, [-200, 0]);
    title(ax2, 'DFA indicator, 120 point window')
    %ylim(ax2, [0.9 1]);
    clear LegendInfo order indices sdfa
    
    
elseif plotSEX
    
    
    
    %return
    % plot the ACF-1 indicators, 240 point window
    ax2 = subplot(1,2,2);
    hold on
    for i = 1:size(H,2)
        
        if smooth_data
            % smooth the signal
            X = [[1:size(H(1).slp_data_RO12, 1)]', H(1).slp_data_RO12];
            Y = gauss_smoother(X, 12, false);
            H(i).smooth_slp = Y(:,2);
            H(i).noise = H(i).slp_data_RO12 - Y(:,2);
            
            clear X Y
        else
            H(i).noise = H(i).slp_data_RO12;
        end
        
        
        col = line_colours(1+mod(i,6),:);
        H(i).ssex = SEX_sliding(H(i).noise, 120, true, false);
        plot(ax2, xaxis(241:end-140), H(i).ssex(241:end-140), 'color', col, 'LineWidth', 0.3);
        disp(['plotted sex ', H(i).h_name])
        LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
    end
    
    
    if plotMean
        sex_array = [];
        for i = 1:size(H,2)
            sex_array = [sex_array, H(i).ssex];
        end
        m = mean(sex_array, 2);
        plot(ax2, xaxis(241:end-140), m(241:end-140), 'LineWidth', 2.5 );
        clear m sex_array
        LegendInfo{i+1} = 'Mean of all series';
        
        if smooth_data
            %smooth the Mean_slp_data
            X = [[1:size(Mean_slp_data, 1)]', Mean_slp_data];
            Y = gauss_smoother(X, 12, false);
            Mean_slp_data_noise = Mean_slp_data - Y(:,2);
            clear X Y
        else
            Mean_slp_data_noise = Mean_slp_data;
        end
        
        ssex = SEX_sliding(Mean_slp_data_noise, 240, true, false);
        plot(ax2, xaxis(241:end-140), ssex(241:end-140), 'color', 'k','LineStyle', ':','LineWidth', 2.5 );
        
    end

    %legend(LegendInfo, 'Location', 'southwest');
    ylabel(ax2, 'Power Spectrum Scaling Exponent');
    xlabel(ax2, 'Time since event (hours)');
    xlim(ax2, [-150, 0]);
    %ylim(ax2, [0.8 1]);
    clear LegendInfo ssex
    
    
end