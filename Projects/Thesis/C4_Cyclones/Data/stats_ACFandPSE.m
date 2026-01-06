function output = stats_ACFandPSE(CycloneStruct, indices)
%% STATS_ACFANDPSE Compute statistics across cyclone ACF and PSE fields
%
% See also: Add_ACFandPSE, Add_ACFandPSE240

    if nargin < 2 || isempty(indices)
        indices = 1:size(CycloneStruct, 2);
    end

% Function takes a cyclone structure and returns statistics
% in a structure with 3 indices (for 24, 48 and 120 point windows)
% and fields:
%       aACF / aPSE :: all ACF/PSE series in an array
%       mACF / mPSE :: mean of all ACF/PSE series
%       sACF / sPSE :: standard deviation of all ACF/PSE series

NumCyclones = size(indices,2);
StatStruct = struct;

StatStruct(1).window = 24;
StatStruct(2).window = 48;
StatStruct(3).window = 120;
StatStruct(4).window = 240;
StatStruct(5).window = 360;
StatStruct(6).window = 480;

StatStruct(1).aACF = zeros(NumCyclones, size(CycloneStruct(1).slp_data_RO12,1));
StatStruct(2).aACF = zeros(size(StatStruct(1).aACF));
StatStruct(3).aACF = zeros(size(StatStruct(1).aACF));
StatStruct(4).aACF = zeros(size(StatStruct(1).aACF));
StatStruct(5).aACF = zeros(size(StatStruct(1).aACF));
StatStruct(6).aACF = zeros(size(StatStruct(1).aACF));
StatStruct(1).aPSE = zeros(size(StatStruct(1).aACF));
StatStruct(2).aPSE = zeros(size(StatStruct(1).aACF));
StatStruct(3).aPSE = zeros(size(StatStruct(1).aACF));
StatStruct(4).aPSE = zeros(size(StatStruct(1).aACF));
StatStruct(5).aPSE = zeros(size(StatStruct(1).aACF));
StatStruct(6).aPSE = zeros(size(StatStruct(1).aACF));

for i = 1:NumCyclones
    StatStruct(1).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF24;
    StatStruct(2).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF48;
    StatStruct(3).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF120;
    StatStruct(4).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF240;
    StatStruct(5).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF360;
    StatStruct(6).aACF(i,:) = ...
        CycloneStruct(indices(i)).ACF480;
    StatStruct(1).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE24;
    StatStruct(2).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE48;
    StatStruct(3).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE120;
    StatStruct(4).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE240;
    StatStruct(5).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE360;
    StatStruct(6).aPSE(i,:) = ...
        CycloneStruct(indices(i)).PSE480;
    
end

for i = 1:6
    StatStruct(i).mACF = mean(StatStruct(i).aACF);
    StatStruct(i).mPSE = mean(StatStruct(i).aPSE);
    StatStruct(i).sACF = std(StatStruct(i).aACF);
    StatStruct(i).sPSE = std(StatStruct(i).aPSE);
end

output = StatStruct;
end