function [ret_val] = is_octave
%IS_OCTAVE Tests if the script is being run in Octave

if exist('OCTAVE_VERSION', 'builtin')
    ret_val = 1;
else
    ret_val = 0;
end

