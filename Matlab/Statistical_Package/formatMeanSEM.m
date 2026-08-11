function outStr = formatMeanSEM(T, precision)
% formatMeanSEM formats Mean ± SEM from a table
%
% Inputs:
%   T          - table with variables 'Mean' and 'StdErr'
%   precision  - number of decimal places (default = 2)
%
% Output:
%   outStr     - cell array of formatted strings

    if nargin < 2
        precision = 2;
    end

    % Extract values
    mu  = T.Mean;
    sem = T.StdErr;

    % Build format string (e.g., %.2f)
    fmt = ['%.' num2str(precision) 'f'];

    % Generate formatted strings
    outStr = cell(height(T),1);
    for i = 1:height(T)
        outStr{i} = sprintf([fmt ' ± ' fmt], mu(i), sem(i));
    end
end