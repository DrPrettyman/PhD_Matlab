
load('fourteen2D');

%% For EOF PS

meanIndicatorsArray = fourteen2D(15).WeightSensitivityPS';
wsizes = linspace(0,1,100)';

fig = plotfun_WeightSensitivity(meanIndicatorsArray, wsizes, 'PS',0.2,[0,1]);

%% For EOF ACF1

meanIndicatorsArray = fourteen2D(15).WeightSensitivityACF1';
wsizes = linspace(0,1,100)';

fig = plotfun_WeightSensitivity(meanIndicatorsArray, wsizes, 'ACF1',0.05,[0,1]);

%% For Williamson & Lenton real part

meanIndicatorsArray = fourteen2D(2).WeightSensitivity_WLre';
wsizes = linspace(0,1,100)';

fig = plotfun_WeightSensitivity(meanIndicatorsArray, wsizes, 'Eigen value - real part',0.05,[0,1]);

%% For Williamson & Lenton iumaginary part

meanIndicatorsArray = fourteen2D(15).WeightSensitivity_WLim';
wsizes = linspace(0,1,100)';

fig = plotfun_WeightSensitivity(meanIndicatorsArray, wsizes, 'Eigen value - imaginary part',0.05,[0,1]);
