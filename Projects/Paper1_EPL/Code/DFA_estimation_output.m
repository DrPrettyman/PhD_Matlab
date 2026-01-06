function [DFApoints, alpha, s, F] = DFA_estimation_output(data,  order, view)

s_min = 5;
s_max = floor(size(data, 1)/4);
N_s = 20;
 
s = floor( 10.^(...
    ( log10(s_min):...
    ((log10(s_max)-log10(s_min))/(N_s+1)):...
    log10(s_max) )'...
    ) );

F = zeros(size( s, 1 ), 1);

for i = 1:size(F,1) 
    F(i) = DFA(data, s(i), order);
              
    % Scaling (a la Kantelhardt)
    F(i) = F(i) / sqrt(s(i));
end

DFApoints = cat(2, s, F);



linearfit = polyfit(log(s),log(F),1);

alpha = linearfit(1)+0.5;




if view == true
    fit = exp(linearfit(2))*s.^alpha;
    figure
    loglog(s, F, '-o')
    hold on
    loglog(s, fit)
end




return