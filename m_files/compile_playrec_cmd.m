function compile_playrec_cmd(asio_path, dsound_path, pa_path, sdk_path)

if nargin < 1
    asio_path = '';
end

if nargin < 2
    dsound_path = '';
end

if nargin < 3
    pa_path = '';
end

if nargin < 4
    sdk_path = '';
end

% Set defaults
debug = 1;
verbose = 1;
case_insensitive = 0;

use_alsa = 0;
use_asihpi = 0;
use_asio = 0;
use_coreaudio = 0;
use_dsound = 0;
use_jack = 0;
use_oss = 0;
use_wasapi = 0;
use_wdmks = 0;
use_wmme = 0;

% Check which platform we are on and fill in API menu options 
ask_alsa = 0;
ask_asihpi = 0;
ask_asio = 0;
ask_coreaudio = 0;
ask_dsound = 0;
ask_jack = 0;
ask_oss = 0;
ask_wasapi = 0;
ask_wdmks = 0;
ask_wmme = 0;

ask_sdk_path = 0;

if is_os('WIN')
    ask_asio = 1;
    ask_dsound = 1;
    ask_wasapi = 1;
    ask_wdmks = 1;
    ask_wmme = 1;   

    ask_sdk_path = 1;
elseif is_os('MAC')
    ask_asio = 1;
    ask_coreaudio = 1;
    ask_jack = 1;
else
    ask_alsa = 1;
    ask_asihpi = 1;
    ask_jack = 1;
    ask_oss = 1;
end

disp ('Please select the options required when compiling Playrec:');

pa_path = get_string_input('PortAudio installation directory', pa_path);

debug   = get_yes_no_input('Use debug mode', debug);
verbose = get_yes_no_input('Use verbose mode', verbose);
case_insensitive = get_yes_no_input('Use case insensitive function names', case_insensitive);

if ask_alsa
    use_alsa = get_yes_no_input('Use Advanced Linux Sound Architecture (ALSA)', use_alsa);
end

if ask_asihpi
    use_asihpi = get_yes_no_input('Use AudioScience HPI', use_asihpi);
end

if ask_asio
    use_asio = get_yes_no_input('Use ASIO', use_asio);
    if use_asio
        asio_path = get_string_input('ASIO path', asio_path);
    end
end

if ask_coreaudio
    use_coreaudio = get_yes_no_input('Use Core Audio', use_coreaudio);
end

if ask_dsound
    use_dsound = get_yes_no_input('Use Direct Sound', use_dsound);
    if use_dsound
        dsound_path = get_string_input('Direct Sound path', dsound_path);
    end
end

if ask_jack
    use_jack = get_yes_no_input('Use Jack Audio Connection Kit (JACK)', use_jack);
end

if ask_oss
    use_oss = get_yes_no_input('Use Open Sound System (OSS)', use_oss);
end

if ask_wasapi
    use_wasapi = get_yes_no_input('Use Windows Audio Session API (WASAPI)', use_wasapi);
end

if ask_wdmks
    use_wdmks = get_yes_no_input('Use Windows Driver Model with Kernel Support (WDMKS)', use_wdmks);
end

if ask_wmme
    use_wmme = get_yes_no_input('Use Windows MultiMedia Extension (WMME)', use_wmme);
end

if ask_sdk_path
    sdk_path = get_string_input('Platform SDK directory (containing lib and include directories)', sdk_path);
end
%compile_playrec_func(1,1,1,0,0,1,0,0,0,0,0,0,0,'C:\Programming\matlab\playrec_2_1_0\lib\asiosdk2','','C:\Programming\matlab\playrec_2_1_0\lib\portaudio\portaudio_v19','')
if compile_playrec_func(debug, ...
                        verbose, ...
                        case_insensitive, ...
                        use_alsa, ...
                        use_asihpi, ...
                        use_asio, ...
                        use_coreaudio, ...
                        use_dsound, ...
                        use_jack, ...
                        use_oss, ...
                        use_wasapi, ...
                        use_wdmks, ...
                        use_wmme, ...
                        asio_path, ...
                        dsound_path, ...
                        pa_path, ...
                        sdk_path)

    disp ('Compiling Playrec failed, see the Command Window for more information.');
end

function [ret_val] = get_string_input(msg, default)
if is_octave
    ret_val = input([msg, ' [', default, ']: '], 's');
else
    ret_val = input([msg, ' [', regexprep(default, '(\\|%)', '$1$1'), ']: '], 's');
end

if isempty(ret_val)
    ret_val = default;
end

function [ret_val] = get_yes_no_input(msg, default)
if default
    default_string = 'Y';
else
    default_string = 'N';
end

ret_string = input([msg, ' [', default_string, ']: '], 's');

if isempty(ret_string)
    ret_val = default;
elseif strncmpi(ret_string, 'y', 1)
    ret_val = 1;
else
    ret_val = 0;
end
