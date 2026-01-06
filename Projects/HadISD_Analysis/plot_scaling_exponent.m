function [] = plot_scaling_exponent(hurricane, windowSize)

% input - Hurricane structure object, e.g. H(1)
%       - Window size of the sliding window for scaling 
%         exponent estimation.
%
% Plots the scaling exponent of the slpdata time series

if nargin<2
    windowSize = 120;
end


SEX_sliding(hurricane.slp_data_RO12, windowSize, true);
title(hurricane.h_name);
xlabel('time (hours)');
