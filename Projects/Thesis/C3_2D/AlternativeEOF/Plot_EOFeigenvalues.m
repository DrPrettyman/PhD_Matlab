%%
%load('AltEOF_comp')
numberOfSystems = 3;

%% Plot
strings = {'a', 'b', 'c'};


for j = 1:numberOfSystems
    figure

    ax1 = polaraxes;
    hold on
    for i = 1:AltEOF_comp(j).N
        polarplot(ax1,[0, AltEOF_comp(j).eigenTheta_reg(i)], [0,1],...
            'color','b', 'LineWidth',1);
        polarplot(ax1,[0, AltEOF_comp(j).eigenTheta_alt(i)], [0,1],...
            'color','r', 'LineWidth',1);
    end
    ax1.RTick = [];

    ann = annotation('textbox',...
        'String',strings{j},...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    
    disp(['means ',num2str(j),': ', num2str(AltEOF_comp(j).meanTheta_reg), ', ', num2str(AltEOF_comp(j).meanTheta_alt)])
end
