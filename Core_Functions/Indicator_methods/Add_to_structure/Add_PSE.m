function output = Add_PSE(in_CycloneStruct, windowSize, RO12)
%% ADD_PSE Add sliding PSE field to cyclone structure
%
% Computes sliding power spectral exponent on cyclone SLP data and adds
% the result as a new field to the structure.
%
% Syntax:
%     output = Add_PSE(in_CycloneStruct, windowSize)
%     output = Add_PSE(in_CycloneStruct, windowSize, RO12)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data' or 'slp_data_RO12'
%     windowSize       - Size of sliding window
%     RO12             - If true, use RO12-detrended data (default: true)
%
% Outputs:
%     output - Structure with added PSE[windowSize] or PSE[windowSize]_RO12 field
%
% See also: PSE_sliding, Add_ACF, Add_VAR

    if nargin < 3 || isempty(RO12)
        RO12 = true;
    end

    if RO12
    dataString = 'slp_data_RO12';
    FieldString = ['PSE',num2str(windowSize),'_RO12'];
else
    dataString = 'slp_data';
    FieldString = ['PSE',num2str(windowSize)];
end

CycloneStruct = in_CycloneStruct;

NumCyclones = size(CycloneStruct,2);

for i = 1:NumCyclones
    CycloneStruct(i).(FieldString) = PSE_sliding(...
        CycloneStruct(i).(dataString), windowSize, false);
end

output = CycloneStruct;
end



