function csvwrite_with_headers(filename, m, headers, r, c)
%% CSVWRITE_WITH_HEADERS Write matrix to CSV file with column headers
%
% Works like built-in csvwrite but allows a row of headers to be inserted.
%
% Syntax:
%     csvwrite_with_headers(filename, m, headers)
%     csvwrite_with_headers(filename, m, headers, r, c)
%
% Inputs:
%     filename - Output filename (string)
%     m        - Array of data (must not be a cell array)
%     headers  - Cell array of strings for column headers
%     r        - Row offset of data (optional, default: 0)
%     c        - Column offset of data (optional, default: 0)
%
% Notes:
%     - Same limitations as csvwrite apply to the data structure
%     - Number of headers must match number of columns in m
%
% See also: csvwrite, dlmwrite

%% initial checks on the inputs
if ~ischar(filename)
    error('FILENAME must be a string');
end

% the r and c inputs are optional and need to be filled in if they are
% missing
if nargin < 4
    r = 0;
end
if nargin < 5
    c = 0;
end

if ~iscellstr(headers)
    error('Header must be cell array of strings')
end

 
if length(headers) ~= size(m,2)
    error('number of header entries must match the number of columns in the data')
end

%% write the header string to the file

%turn the headers into a single comma separated string if it is a cell
%array, 
header_string = headers{1};
for i = 2:length(headers)
    header_string = [header_string,',',headers{i}];
end
%if the data has an offset shifting it right then blank commas must
%be inserted to match
if r>0
    for i=1:r
        header_string = [',',header_string];
    end
end

%write the string to a file
fid = fopen(filename,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);

%% write the append the data to the file

%
% Call dlmwrite with a comma as the delimiter
%
dlmwrite(filename, m, '-append', 'delimiter', ',', 'roffset', r, 'coffset', c);
end
