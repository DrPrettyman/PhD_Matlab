figure

hold on

for x0 = 0.01:0.001:0.99
    data = quadratic_nth_state(x0, 100);
    scatter(data(:,1),data(:,2),1)
end
