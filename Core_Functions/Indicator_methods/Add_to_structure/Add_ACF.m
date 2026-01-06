function output = Add_ACF(in_CycloneStruct, windowSize, RO12)
%% ADD_ACF Add sliding ACF field to cyclone structure
%
% Computes sliding ACF(lag=1) on cyclone SLP data and adds the result
% as a new field to the structure.
%
% Syntax:
%     output = Add_ACF(in_CycloneStruct, windowSize)
%     output = Add_ACF(in_CycloneStruct, windowSize, RO12)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data' or 'slp_data_RO12'
%     windowSize       - Size of sliding window
%     RO12             - If true, use RO12-detrended data (default: true)
%
% Outputs:
%     output - Structure with added ACF[windowSize] or ACF[windowSize]_RO12 field
%
% See also: ACF_sliding, Add_PSE, Add_VAR

    if nargin < 3 || isempty(RO12)
        RO12 = true;
    end

    if RO12
    dataString = 'slp_data_RO12';
    FieldString = ['ACF',num2str(windowSize),'_RO12'];
else
    dataString = 'slp_data';
    FieldString = ['ACF',num2str(windowSize)];
end

CycloneStruct = in_CycloneStruct;

NumCyclones = size(CycloneStruct,2);

for i = 1:NumCyclones
    CycloneStruct(i).(FieldString) = ACF_sliding(...
        CycloneStruct(i).(dataString), 1, windowSize, false);
end

output = CycloneStruct;
end



