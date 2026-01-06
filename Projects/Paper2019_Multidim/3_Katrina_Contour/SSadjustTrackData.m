for i = 1:size(SuperStruct,1)
    
    TD_old = SuperStruct(i).trackData;
    TD_new = zeros(size(TD_old,1), 3);
    
    for t = 1:size(TD_old,1)
        d = datetime(TD_old(t,1),'ConvertFrom','yyyymmdd')...
            +TD_old(t,2)/2400;
        TD_new(t,1) = datenum(d);
    end
    
    TD_new(:,2) = TD_old(:,3);
    TD_new(:,3) = -TD_old(:,4);
    
    SuperStruct(i).trackDataNew = TD_new;
end