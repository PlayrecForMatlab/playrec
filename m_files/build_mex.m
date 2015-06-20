function [failed] = build_mex(name, src_files, include_dirs, compiler_flags, link_libs, lib_dirs, extra_flags, debug, verbose, optionsfile)
%BUILD_MEX function to build a mex file using matlabs mex command
%   Included files and directories are passed in cell arrays
%
%   failed = build_mex(name, src_files, include_dirs)

failed = 1;
abort = 0;

%accumulate the various options into a single arguments list
build_args = {};

if ~is_octave
    build_args = {build_args{:}, '-compatibleArrayDims'};
%    build_args = {build_args{:}, '-largeArrayDims'};
end

%deal with debug argument
if nargin > 7 && ~isempty(debug) && debug
    build_args = {build_args{:}, '-g'};
else
    debug = 0;
end

%deal with verbose argument
if nargin > 8 && ~isempty(verbose) && verbose
    build_args = {build_args{:}, '-v'};
else
    verbose = 0;
end

%use std=c99 as this is needed for portaudio.
%Not sure what systems do need this enabled, as not necessary with:
% Windows with Matlab 2015a & Windows SDK compiler
% Ubuntu with Octave and standard compiler options
%
% If you find this is necessary, please let rob@playrec.co.uk know,
% specifying the exact system you're using and what options you're
% compiling
%build_args = {build_args{:}, 'CFLAGS="\$CFLAGS\ -std=c99"'};

%deal with specified options file
if nargin > 9 && ~isempty(optionsfile) && ischar(optionsfile)
    % -f and option file name go as two seperate arguments
    build_args = {build_args{:}, '-f', optionsfile};
end

% -output and name go as two seperate arguments
if is_octave
    build_args = {build_args{:}, '--output', [name, '.', mexext]};
else
    build_args = {build_args{:}, '-output', name};
end

%deal with compiler flags
if nargin > 3 && ~isempty(compiler_flags)
    for n = 1: length(compiler_flags)
        build_args = {build_args{:}, ['-D',cell2mat(compiler_flags(n))]};
    end
end

%deal with include directories
if nargin > 2 && ~isempty(include_dirs)
    for n = 1:length(include_dirs)
        if exist(cell2mat(include_dirs(n)),'dir')
            build_args = {build_args{:}, ['-I', cell2mat(include_dirs(n))]};
        else
            print_flush('build_mex: Unable to find ''%s''\n', cell2mat(include_dirs(n)));
            abort = 1;
        end
    end
end

%deal with libraries
if nargin > 4 && ~isempty(link_libs)
    for n = 1:length(link_libs)
        %don't use -l prefix to make compatible with more versions of Matlab
        build_args = {build_args{:}, cell2mat(link_libs(n))};
    end
end

%deal with library include directories
if nargin > 5 && ~isempty(lib_dirs)
    for n = 1:length(lib_dirs)
        if exist(cell2mat(lib_dirs(n)),'dir')
            if is_octave
                %use -L prefix in Octave, escaping quotes to get it to work
                build_args = {build_args{:}, ['-L\"', cell2mat(lib_dirs(n)), '\"']};
            elseif ~is_os('WIN')
                %use -L prefix in non-Windows Matlab
                build_args = {build_args{:}, ['-L', cell2mat(lib_dirs(n))]};               
            else
                %don't use -L prefix in Windows Matlab to make compatible with more versions of Matlab
                build_args = {build_args{:}, ['LIB#', cell2mat(lib_dirs(n)), ';$LIB']};
            end
        else
            print_flush('build_mex: Unable to find ''%s''\n', cell2mat(lib_dirs(n)));
            abort = 1;
        end
    end
end

%deal with any extra flags
if nargin > 6 && ~isempty(extra_flags)
    for n = 1: length(extra_flags)
        build_args = {build_args{:}, cell2mat(extra_flags(n))};
    end
end

%deal with source files
for n = 1:length(src_files)
    if exist(cell2mat(src_files(n)),'file')
        build_args = {build_args{:}, cell2mat(src_files(n))};
    else
        print_flush('build_mex: Unable to find ''%s''\n', cell2mat(src_files(n)));
        abort = 1;
    end
end

if abort
   if nargout > 0
       return
   else
       error ('Errors have been found in arguments supplied to build_mex');
   end
end

if verbose   
   %for speed, turn into single string and then display it, ensuring all \
   %and % have been escaped.
   print_flush('Building mex with following arguments:\n');
   for k=1:length(build_args)
       print_flush(['   ', regexprep(build_args{k}, '(\\|%)', '$1$1'), '\n']);
   end
end

%finally evaluate the command, storing the return value, if there is one
%(Matlab only)
if is_octave
    mex(build_args{:});
    failed = 0;
else
    failed = mex(build_args{:});
end

function print_flush(varargin)

fprintf(varargin{:});
if is_octave
    fflush(stdout);
end
