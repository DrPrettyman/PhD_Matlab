%load('fourteen2D')
%load('indicators1D')

%%
weights = 0.5*[1,1];
for cy = 1:14
    X = [fourteen2D(cy).slp , fourteen2D(cy).windspeed];
    [T, W] = EOF1(X,true,weights);
    fourteen2D(cy).eof = T;
end

