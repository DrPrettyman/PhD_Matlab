function output = Add_ACFandPSE(in_CycloneStruct)
%% ADD_ACFANDPSE Add ACF and PSE fields at 24/48/120 window sizes
%
% Computes sliding ACF(lag=1) and PSE on cyclone SLP data at three
% window sizes and adds the results as new fields to the structure.
%
% Syntax:
%     output = Add_ACFandPSE(in_CycloneStruct)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data_RO12' field
%
% Outputs:
%     output - Structure with added fields:
%              ACF24, ACF48, ACF120, PSE24, PSE48, PSE120
%
% See also: Add_ACFandPSE240, Add_ACF, Add_PSE

    CycloneStruct = in_CycloneStruct;

NumCyclones = size(CycloneStruct,2);

for i = 1:NumCyclones
    CycloneStruct(i).ACF24 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 24);
    CycloneStruct(i).PSE24 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 24);
end

for i = 1:NumCyclones
    CycloneStruct(i).ACF48 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 48);
    CycloneStruct(i).PSE48 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 48);
end

for i = 1:NumCyclones
    CycloneStruct(i).ACF120 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 120);
    CycloneStruct(i).PSE120 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 120);
end

output = CycloneStruct;
end



