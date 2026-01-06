function output = Add_ACFandPSE240(in_CycloneStruct)
%% ADD_ACFANDPSE240 Add ACF and PSE fields at 240/360/480 window sizes
%
% Computes sliding ACF(lag=1) and PSE on cyclone SLP data at three
% larger window sizes and adds the results as new fields to the structure.
%
% Syntax:
%     output = Add_ACFandPSE240(in_CycloneStruct)
%
% Inputs:
%     in_CycloneStruct - Structure array with 'slp_data_RO12' field
%
% Outputs:
%     output - Structure with added fields:
%              ACF240, ACF360, ACF480, PSE240, PSE360, PSE480
%
% See also: Add_ACFandPSE, Add_ACF, Add_PSE

    CycloneStruct = in_CycloneStruct;

NumCyclones = size(CycloneStruct,2);

for i = 1:NumCyclones
    CycloneStruct(i).ACF240 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 240);
    CycloneStruct(i).PSE240 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 240);
end

for i = 1:NumCyclones
    CycloneStruct(i).ACF360 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 360);
    CycloneStruct(i).PSE360 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 360);
end

for i = 1:NumCyclones
    CycloneStruct(i).ACF480 = ACF_sliding(...
        CycloneStruct(i).slp_data_RO12, 1, 480);
    CycloneStruct(i).PSE480 = -PSE_sliding(...
        CycloneStruct(i).slp_data_RO12, 480);
end

output = CycloneStruct;
end



