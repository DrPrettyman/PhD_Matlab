
load('cyclones100')

HurricaneList = [16; 1; 17; 12; 2; 3; 4; 5; 6; 7; 19; 8; 13; 14];
noH = size(HurricaneList,1);


%%

meanIndicatorsArray = cyclones100(21).PS_sensitivity;
wsizes = (40:160)';

fig = plot_sensitivity(meanIndicatorsArray, wsizes, 'PS',0.05,[90,110]);

%%

meanIndicatorsArray = cyclones100(21).ACF1_sensitivity;
wsizes = (40:160)';

fig = plot_sensitivity(meanIndicatorsArray, wsizes, 'ACF1',0.01,[40,120]);

%%

meanIndicatorsArray = cyclones100(21).DFA_sensitivity;
wsizes = (40:160)';

fig = plot_sensitivity(meanIndicatorsArray, wsizes, 'DFA',0.1,[40,120]);

%%

meanIndicatorsArray = cyclones100(21).ACF4_sensitivity;
wsizes = (40:160)';

fig = plot_sensitivity(meanIndicatorsArray, wsizes, 'ACF4',0.01,[40,120]);

