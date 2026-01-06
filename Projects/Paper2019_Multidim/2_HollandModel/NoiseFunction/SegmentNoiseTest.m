
Mvals = [100 10 1]
N=100;
figure
for fignum = 1:3
    M = Mvals(fignum);
    
    x = linspace(0,3,100)';
    y = zeros(size(x));
    
    for index = 1:size(x,1)
        PSEs = zeros(M,1);
        for i = 1:M
            %noise = noise_generator(N,x(index)/0.75);
            noise = noiseGen2(N,x(index),0.01);
            PSEs(i) = PSE_new(noise');
        end
        y(index) = mean(PSEs);
        clear PSEs noise i
    end
    clear index
    
    %%
    p = polyfit(x,y,1);
    fit = polyval(p,x);
    
    v = var(y-x);
    
    
    ax = subplot(3,1,fignum);
    hold on
    plot(x,y)
    plot(x,fit)
    str = {['Tests for each value: ',num2str(M)],...
        ['Variance from expected = ',num2str(v)]};
    text(0.2,2.8,str)
    
    ylim([0,3])
    
    xlabel('Input to noise\_generator function')
    ylabel('Actual PS-value of noise')
    
    clear p v fit M x y
    
end

