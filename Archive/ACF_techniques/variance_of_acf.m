ws = 240;

for i = 1:size(H,2)
    
    v = zeros(size(H(i).sacf));
    for windowstart = (241 + ws):size(H(i).sacf,1)
        v(windowstart) = var(H(i).sacf((windowstart-ws):windowstart) );
    end
    H(i).sacfvar = v;
    
    
end

figure
hold on
for i = 1:size(H,2)
    
   plot(H(i).sacfvar)
   LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end
legend(LegendInfo, 'Location', 'northwest');