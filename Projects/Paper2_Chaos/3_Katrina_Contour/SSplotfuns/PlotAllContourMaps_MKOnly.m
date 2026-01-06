for i = 1:size(SuperStruct,1)
    hurricaneName = SuperStruct(i).name;
    SSplotContour_MKOnly(hurricaneName)
end