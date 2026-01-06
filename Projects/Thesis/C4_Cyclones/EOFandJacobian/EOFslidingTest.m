load('fourteen2D')
load('indicators1D')

X = [fourteen2D(1).slp , fourteen2D(1).windspeed];

windowSize = 102;
weights = 0.5*[1,1];

%% EOF, then indicator
[T, W] = EOF1(X,true,weights);
PSout = PSE_sliding(T,windowSize,false);

%% Sliding EOF

EOFout = EOF_sliding(X, windowSize, 'PS', weights);


%%
figure
hold on
plot(PSout)
plot(EOFout)


