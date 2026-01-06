function output = Add_VAR(in_CycloneStruct, windowSize, RO12)
%% ADD_VAR Add sliding variance field to cyclone structure
%
% Computes sliding variance on cyclone SLP data and adds the result
% as a new field to the structure.
%
% Syntax:
%     output = Add_VAR(in_CycloneStruct, windowSize)
%     output = Add_VAR(in_CycloneStruct, windowSize, RO12)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data' or 'slp_data_RO12'
%     windowSize       - Size of sliding window
%     RO12             - If true, use RO12-detrended data (default: false)
%
% Outputs:
%     output - Structure with added VAR[windowSize] or VAR[windowSize]_RO12 field
%
% See also: VAR_sliding, Add_ACF, Add_PSE

    if nargin < 3 || isempty(RO12)
        RO12 = false;
    end

    if RO12
    dataString = 'slp_data_RO12';
    FieldString = ['VAR',num2str(windowSize),'_RO12'];
else
    dataString = 'slp_data';
    FieldString = ['VAR',num2str(windowSize)];
end

CycloneStruct = in_CycloneStruct;

NumCyclones = size(CycloneStruct,2);

for i = 1:NumCyclones
    CycloneStruct(i).(FieldString) = VAR_sliding(...
        CycloneStruct(i).(dataString), windowSize, false);
end

output = CycloneStruct;
end



