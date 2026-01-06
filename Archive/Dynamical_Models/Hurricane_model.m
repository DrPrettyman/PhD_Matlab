N = 251;

daily_oscillation = sin(12*(1:N)');

sudden_drop = zeros(N,1);
sudden_drop(end-47:end) = 0.01*-((1:48)').^2;

pink_noise = rednoise(N,2);
white_noise = randn(N,1);

model =...
    0*daily_oscillation +...
    1*sudden_drop +...
    2*pink_noise +...
    0.3*white_noise;


figure
plot(model)
