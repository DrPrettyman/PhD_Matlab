function [tout2,xout2] = f_2(T_mid,tout,xout)
  tout2=[];
  xout2=[];
if T_mid>tout(1) && T_mid<tout(end)
    for  i = 1:size(tout)
        if tout(i)>=T_mid
            tout2=[tout2;tout(i)];
            xout2=[xout2;xout(i,:)];
        end
    end
else display('T_mid must be and element in (T_0,T_1)')
end
        
    

