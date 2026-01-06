%% adds normalised EOF to the "twoStruct" structure

% for the slp, windspeed and the combined first EOF score, for each cyclone
windowSize = 100;
for cyclone_no = 1:size(twoStruct,2)
    twoStruct(cyclone_no).eof1NORM = ...
        EOF1([twoStruct(cyclone_no).slp, twoStruct(cyclone_no).windspeed]...
        ,true);
end