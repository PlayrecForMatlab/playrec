function [ret_val] = is_os(required_os)
% IS_OS Tests if the Operating System is that specified
%
% This function can be used to test the current Operating system,
% and should function regardless of the application (Matlab or Octave)
% and version.  Additionally, Macs should only return true for 'MAC'
% and not for 'UNIX', which differs from isunix.
%
% Valid values of required_os are: WIN, MAC, UNIX.

ret_val = 0;

if strcmpi(required_os, 'WIN')
    % This should always be able to use ispc
    ret_val = ispc;
elseif strcmpi(required_os, 'MAC')
    % Older versions of Matlab don't have 'ismac', so assume
    % if ismac doesn't exist then it's not a mac!
    if exist('ismac')
    	ret_val = ismac;
    end
elseif strcmpi(required_os, 'UNIX')
    % UNIX should not be true if it's a mac.
    ret_val = isunix;
    if exist('ismac')
        if ismac
            ret_val = 0;
        end
    end
else
    error ('Invalid required_os supplied to is_os');
end
