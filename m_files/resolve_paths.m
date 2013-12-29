function[full_paths] = resolve_paths(base,filenames)
%RESOLVE_PATHS prepends the same base path to many filenames
%
%   [full_paths] = resolve_paths(base,filenames);
%
%   base:       base path (string)
%   filenames:  individual filenames (cell array of strings, or single string)
%   full_paths: the resolved filenames (cell array of strings, or single string)
%
%Alastair Moore, November 2007
if iscell(filenames)
    for n = 1:length(filenames)
        temp_path = [base,cell2mat(filenames(n))];
        if is_os('WIN')
            temp_path = strrep(temp_path,'/','\');
        end
        full_paths(n) = {temp_path};
    end
else
    full_paths = [base,filenames];
    if is_os('WIN')
        full_paths = strrep(full_paths,'/','\');
    end
end