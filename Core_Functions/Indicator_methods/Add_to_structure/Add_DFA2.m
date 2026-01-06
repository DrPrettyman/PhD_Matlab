function output = Add_DFA2(in_CycloneStruct, windowSize)
%% ADD_DFA2 Add sliding DFA (order 2) field to cyclone structure
%
% Computes sliding DFA with polynomial order 2 on cyclone SLP data
% and adds the result as a new field to the structure.
%
% Syntax:
%     output = Add_DFA2(in_CycloneStruct, windowSize)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data' field
%     windowSize       - Size of sliding window
%
% Outputs:
%     output - Structure with added DFA2_[windowSize] field
%
% See also: DFA_sliding, Add_ACF, Add_PSE

    CycloneStruct = in_CycloneStruct;
    NumCyclones = size(CycloneStruct, 2);
    FieldString = ['DFA2_', num2str(windowSize)];

    for i = 1:NumCyclones
        CycloneStruct(i).(FieldString) = DFA_sliding(...
            CycloneStruct(i).slp_data, 2, windowSize);
    end

    output = CycloneStruct;
end



