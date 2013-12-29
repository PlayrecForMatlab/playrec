function[path] = find_folder(base,name,contents,recurse)
%FIND_FOLDER searches for folders that match set criteria.
%
%  [path] = find_folder(base,name)
%  [path] = find_folder(base,name,contents)
%  [path] = find_folder(base,name,contents,recurse)
%
% base:     the base path where searching starts
% name:     the name of the folder to find (can include * wildcards)
% contents: names of files and folders that a matching folder must contain
%           (cell array of strings, or single string).
% recurse:  specifies if a recursive search down through the folder 
%           hierarchy should occur:
%            >0 the maximum number of folders to descend;
%             0 no recursion;
%            <0 no limit to recursion depth;
%
%Robert Humphrey, December 2007

path = '';

if (nargin < 2) || isempty(base)
    return
end

if nargin < 3
    contents = '';
end

if nargin < 4
    recurse = 0;
end

if ~strcmp(base(end), '/') && ~strcmp(base(end), '\')
    base = [base, '/'];
end

dir_list = dir(resolve_paths(base, ''));

if ~isempty(dir_list)
    %There's at least one entry in the directory list
    for k=1:length(dir_list)
        if (dir_list(k).isdir == 1) ...
            && ~strcmp(dir_list(k).name, '.') ...
            && ~strcmp(dir_list(k).name, '..') ...
            && ~isempty(regexpi(dir_list(k).name, name))
            
            folder = [base, dir_list(k).name, '/'];
            valid = 1;
           
            if iscell(contents)
                for n=1:length(contents)
                    % Need to check 'file' and 'dir' to work in Octave
                    if exist(resolve_paths(folder, cell2mat(contents(n))), 'file')==0 ...
                        && exist(resolve_paths(folder, cell2mat(contents(n))), 'dir')==0
                    
                        valid = 0;
                    end
                end
            elseif ~isempty(contents)
                % Need to check 'file' and 'dir' to work in Octave
                if exist(resolve_paths(folder, contents), 'file')==0 ...
                   && exist(resolve_paths(folder, contents), 'dir')==0
               
                    valid = 0;
                end
            end

            if valid
                path = resolve_paths(folder, '');
                return
            end
        end
    end
end

dir_list = dir(resolve_paths(base, ''));
folder_list = dir_list([dir_list.isdir] == 1);

if ~isempty(folder_list) && (recurse ~= 0)
    if recurse < 0
        next_recurse = recurse;
    else
        next_recurse = recurse - 1;
    end
    
    %There's at least one subfolder, and we're recursing
    for k=1:length(folder_list)
        if ~strcmp(folder_list(k).name, '.') && ~strcmp(folder_list(k).name, '..')
            path = find_folder([base, folder_list(k).name, '/'], name, contents, next_recurse);
            if ~isempty(path)
                return
            end
        end
    end
end
