function [F, plotableF, plotableB] = DFA(data, segment_len, order)
%% DFA Detrended Fluctuation Analysis
%
% Computes the DFA fluctuation function F(s) for a given segment length.
% DFA is used to detect long-range correlations in time series data.
%
% Syntax:
%     F = DFA(data, segment_len, order)
%     [F, plotableF, plotableB] = DFA(data, segment_len, order)
%
% Inputs:
%     data        - Time series data, column vector [N x 1]
%     segment_len - Length of segments for detrending (s)
%     order       - Polynomial order for detrending (typically 1 or 2)
%
% Outputs:
%     F         - DFA fluctuation value F(s)
%     plotableF - Forward polynomial fits (for visualization)
%     plotableB - Backward polynomial fits (for visualization)
%
% Algorithm:
%     1. Compute cumulative sum (profile) of data
%     2. Divide into non-overlapping segments of length s
%     3. Fit polynomial of given order to each segment
%     4. Compute RMS of residuals
%
% Reference:
%     Peng et al. (1994) "Mosaic organization of DNA nucleotides"
%
% See also: DFA_sliding, DFA_estimation

% Turn off this warning, it is not important here.
warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');

% The DFA procedure consists of four steps.

% Step 1

N = size(data,1);
Y = cumsum(data);

plotableF = zeros(N,1);
plotableB = zeros(N,1);

% Step 2

Ns = floor(N/segment_len);

Fs_Forward = zeros(Ns,1);
Fs_Backward = zeros(Ns,1);

% Forwards
for nu = 1:Ns
    segment_indices = ((nu-1)*segment_len+1:nu*segment_len)';
    
    poly = polyfit( segment_indices, Y(segment_indices), order );
    p_nu = polyval( poly, segment_indices );
    
    plotableF(segment_indices) = p_nu;
    
    Ys = Y(segment_indices) - p_nu;
    
    Fs_Forward(nu) = (1/segment_len)*sum(Ys.^2);
    

end
clear segment_indices poly p_nu Ys

% Backwards
for nu = 1:Ns
    segment_indices = ( N - (nu*segment_len) +1 : N - (nu-1)*segment_len  )';
    poly = polyfit( segment_indices, Y(segment_indices), order );
    p_nu = polyval( poly, segment_indices );
    plotableB(segment_indices) = p_nu;
    Ys = Y(segment_indices) - p_nu;
    Fs_Backward(nu) = (1/segment_len)*sum(Ys.^2);
    
end
clear segment_indices poly p_nu Ys

Sum_Fs = sum(Fs_Forward) + sum(Fs_Backward);
F = sqrt( Sum_Fs / (2*Ns) );

% Reset the warning message and return
warning('on','MATLAB:polyfit:RepeatedPointsOrRescale');
return
