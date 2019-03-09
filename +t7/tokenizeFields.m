function tokens = tokenizeFields(fieldString, fieldPrefixes)
% tokens = tokenizeFields(fieldString, fieldPrefixes) splits a string of
% whitespace-separated field names into a cell array of field names.
% If any of the field tokens do not match tokens in fieldPrefixes, an error
% will occur.
%
% Internal function.

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


tokens = {};

if isstr(fieldPrefixes)
    allowedTokens = {};
    remainder = fieldPrefixes;
    while ~isempty(remainder)
        [allowedTokens{end+1}, remainder] = strtok(remainder);
    end    
else
    allowedTokens = fieldPrefixes;
end

remainder = fieldString;
while any(isletter(remainder))
    [tokens{end+1}, remainder] = strtok(remainder);
end

% validate the fields now

for ff = 1:numel(tokens)
    prefix = tokens{ff}(1:end-1);
    
    ok = 0;
    for tt = 1:numel(allowedTokens)
        if strcmp(allowedTokens{tt}, prefix)
            ok = 1;
        end
    end
    
    if ~ok
        error('Invalid field (%s)', tokens{ff});
    end
end


end
