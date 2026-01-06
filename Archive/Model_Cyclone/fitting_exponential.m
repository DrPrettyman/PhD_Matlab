%load('cyclones100.mat')
indices = [1:8,12,13,14,16,17,19];
NumCyclones = size(indices,2);
event_index = cyclones100(1).event_index;

length = 100;

xaxis = (-length:0)';
AllCyclones48 = zeros(NumCyclones, length+1);
for i = 1:NumCyclones
    AllCyclones48(i,:) =...
        cyclones100(indices(i)).slp_data_RO12((event_index-length):event_index);
end
MeanCyclone48 = mean(AllCyclones48)';


figure
ax1 = subplot(1,1,1);
hold on


all_ab_values = zeros(NumCyclones,2);

for i = 1:NumCyclones
    
    m = AllCyclones48(i,:)';
    
    log_m = log(max(m)+0.001-m);
    p = polyfit(xaxis, log_m, 1);
    v = polyval(p, xaxis);
    exp_model_fn = @(x)(max(m)+0.001 - exp(polyval(p, x)));
    
    power = 12;
    poly_model_fn = @(x)(m(1)+m(end)*((x/length).^power));
    
    f = fit(xaxis,m,'exp1');
    
    all_ab_values(i,1) = f.a;
    all_ab_values(i,2) = f.b;

%plot(xaxis, m, 'LineStyle','--', 'Color',0.7*[1,1,1])
%plot(xaxis, model, 'LineStyle','-', 'Color',0.2*[1,1,1])

    exp_var = var(m - exp_model_fn(xaxis));
    poly_var = var(m - poly_model_fn(xaxis));
    exp_fit_var = var(m - f(xaxis));
    disp([num2str(exp_var),' vs. ',num2str(poly_var),' vs. ',num2str(exp_fit_var)])
    plot(xaxis,  m - f(xaxis))
end
