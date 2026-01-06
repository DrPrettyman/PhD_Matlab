%%

% Yucatan
latLims = [16, 23];
lonLims = [-92, -85];

% Florida
latLims = [24, 30 ];
lonLims = [-83, -79];

% Texas
latLims = [24, 30 ];
lonLims = [-100, -93];

%%
rawList = dlmread('HadisdStationList.txt', ' ');
newList = zeros(size(rawList,1),4);
for i = 1:size(rawList,1)
    
    indices = find(rawList(i,:)~=0,4);
    if size(indices,2) < 4
        indices = [indices, 10,11,12,13];
        indices = indices(1:4);
    end
    newList(i,:) = rawList(i,indices);
    clear indices
    
end
clear rawList

%%
stationIndices = find(...
    newList(:,3)>=latLims(1) &...
    newList(:,3)<=latLims(2) &...
    newList(:,4)>=lonLims(1) &...
    newList(:,4)<=lonLims(2) );

for i = 1:size(stationIndices,1)
    index = stationIndices(i);
    part1 = num2str(newList(index,1));
    part2 = num2str(newList(index,2));
    part2 = part2(2:end);
    
    stationNumber = [part1, part2];
    disp([stationNumber, ';'])
end
    