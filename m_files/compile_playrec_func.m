function [failed] = compile_playrec_func(debug, verbose, case_insensitive, use_alsa, use_asihpi, use_asio, use_coreaudio, use_dsound, use_jack, use_oss, use_wasapi, use_wdmks, use_wmme, asio_path, dsound_path, pa_path, sdk_path)

failed = 1;

if ~isempty(asio_path) && ~strcmp(asio_path(end), '/') && ~strcmp(asio_path(end), '\')
    %Only append if not empty so subsequent checks for empty string still work
    asio_path = [asio_path, '/'];
end

if ~isempty(dsound_path) && ~strcmp(dsound_path(end), '/') && ~strcmp(dsound_path(end), '\')
    %Only append if not empty so subsequent checks for empty string still work
    dsound_path = [dsound_path, '/'];
end

if ~isempty(pa_path) && ~strcmp(pa_path(end), '/') && ~strcmp(pa_path(end), '\')
    %Only append if not empty so subsequent checks for empty string still work
    pa_path = [pa_path, '/'];
end

if ~isempty(sdk_path) && ~strcmp(sdk_path(end), '/') && ~strcmp(sdk_path(end), '\')
    %Only append if not empty so subsequent checks for empty string still work
    sdk_path = [sdk_path, '/'];
end

%Assemble the required files and include directories
%-start with empty cell arrays
compiler_flags = {};
link_libs = {};
lib_dirs = {};
extra_flags = {};

mfilepath = mfilename('fullpath');
mfilepath = [mfilepath(1:end-length(mfilename)), '../'];

%-always need these
main_files = resolve_paths([mfilepath, 'src/'], {'mex_dll_core.c',...
                                                'pa_dll_playrec.c'});

main_include_dirs = resolve_paths([mfilepath, 'src'], {''});

%-common PortAudio
pa_include_dirs = {'src/common',...
                   'src/hostapi/alsa',...
                   'src/hostapi/asihpi',...
                   'src/hostapi/asio',...
                   'src/hostapi/coreaudio',...
                   'src/hostapi/dsound',...
                   'src/hostapi/jack',...
                   'src/hostapi/oss',...
                   'src/hostapi/wasapi',...
                   'src/hostapi/wdmks',...
                   'src/hostapi/wmme',...
                   'src/os/mac_osx',...
                   'src/os/unix',...
                   'src/os/win',...
                   'include'};      %just include all possibilities!
pa_common_files = {'src/common/pa_allocation.c',...
                   'src/common/pa_converters.c',...
                   'src/common/pa_cpuload.c',...
                   'src/common/pa_debugprint.c',...
                   'src/common/pa_dither.c',...
                   'src/common/pa_front.c',...
                   'src/common/pa_process.c',...
                   'src/common/pa_ringbuffer.c',...
                   'src/hostapi/skeleton/pa_hostapi_skeleton.c',...
                   'src/common/pa_stream.c',...
                   'src/common/pa_trace.c'};
pa_os_specific_files = {};
pa_api_specific_files = {};

%-create empty cells for api stuff
api_files = {};
api_include_dirs = {};
api_link_libs = {};

%-platform /api specific
if is_os('MAC')
    pa_os_specific_files = [pa_os_specific_files, ...
                            {'src/os/mac_osx/pa_mac_hostapis.c', ...
                             'src/os/unix/pa_unix_util.c'}];
    if use_asio
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/asio/pa_asio.cpp'}];
        api_include_dirs = [api_include_dirs, ...
                            resolve_paths(asio_path,...
                                {'common',...
                                 'host',...
                                 'host/mac'})];
        api_files = [api_files,...
                     resolve_paths(asio_path,...
                         {'host/asiodrivers.cpp',...
                          'host/mac/asioshlib.cpp',...
                          'host/mac/codefragements.cpp'})];

        compiler_flags = [compiler_flags, {'PA_USE_ASIO'}];
    end

    if use_coreaudio
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/coreaudio/pa_mac_core.c',...
                                  'src/hostapi/coreaudio/pa_mac_core_utilities.c',...
                                  'src/hostapi/coreaudio/pa_mac_core_blocking.c'}];

        compiler_flags = [compiler_flags, {'PA_USE_COREAUDIO'}];    
    end
    
    if use_jack
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/jack/pa_jack.c'}];
                                       
        compiler_flags = [compiler_flags, {'PA_USE_JACK'}];
    end        
elseif is_os('WIN')
    compiler_flags = [compiler_flags, {'WIN32'}];
    link_libs = [link_libs, {'user32.lib', 'ole32.lib', ...
                             'advapi32.lib', 'winmm.lib'}];

    pa_os_specific_files = [pa_os_specific_files, ...
                            {'src/os/win/pa_win_coinitialize.c',...
                            'src/os/win/pa_win_hostapis.c',...
                            'src/os/win/pa_win_util.c',...
                            'src/os/win/pa_win_waveformat.c',...                            
                            'src/os/win/pa_x86_plain_converters.c'}];
                        
    if ~isempty(sdk_path)
       api_include_dirs = [api_include_dirs,...
                           resolve_paths(sdk_path, {'include', 'lib'})];
       % Add library path, not using -L for backward compatibility,
       % apart from with octave that needs to use it
       lib_dirs = [lib_dirs, resolve_paths(sdk_path, {'lib'})];
    end

    if use_asio
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/asio/pa_asio.cpp'}];
        api_include_dirs = [api_include_dirs, ...
                            resolve_paths(asio_path,...
                                {'common',...
                                 'host',...
                                 'host/pc'})];

        api_files = [api_files,...
                     resolve_paths(asio_path,...            
                        {'common/asio.cpp',...
                         'host/asiodrivers.cpp',...
                         'host/pc/asiolist.cpp'})];

        compiler_flags = [compiler_flags, {'PA_USE_ASIO'}];
    end

    if use_dsound
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/dsound/pa_win_ds.c',...
                                  'src/hostapi/dsound/pa_win_ds_dynlink.c'}];

        api_include_dirs = [api_include_dirs, ...
                            resolve_paths(dsound_path, {'include'})];
        api_link_libs = [api_link_libs, {'dsound.lib'}];

        % Add library path, not using -L for backward compatibility,
        % apart from with octave that needs to use it
        if exist(resolve_paths(dsound_path, {'lib/x64'}),'dir')
            lib_dirs = [lib_dirs, resolve_paths(dsound_path, {'lib/x64'})];
        else
            lib_dirs = [lib_dirs, resolve_paths(dsound_path, {'lib/x86'})];
        end

        compiler_flags = [compiler_flags, {'PA_USE_DS'}];
    end

    if use_wasapi
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/wasapi/pa_win_wasapi.c'}];
        link_libs = [link_libs, {'uuid.lib'}];
        
        compiler_flags = [compiler_flags, {'PA_USE_WASAPI'}];
    end

    if use_wdmks
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/wdmks/pa_win_wdmks.c'}];
        pa_os_specific_files = [pa_os_specific_files,...
                                {'src/os/win/pa_win_wdmks_utils.c'}];
        link_libs = [link_libs, {'setupapi.lib'}];
        
        compiler_flags = [compiler_flags, {'PA_USE_WDMKS'}];
    end

    if use_wmme
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/wmme/pa_win_wmme.c'}];

        compiler_flags = [compiler_flags, {'PA_USE_WMME'}];
    end
else
    pa_os_specific_files = [pa_os_specific_files, ...
                            {'src/os/unix/pa_unix_hostapis.c',...
                            'src/os/unix/pa_unix_util.c'}];

    if use_alsa
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/alsa/pa_linux_alsa.c'}];

        extra_flags = [extra_flags, {'-lasound'}];

        compiler_flags = [compiler_flags, {'PA_USE_ALSA'}];
    end

    if use_asihpi
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/asihpi/pa_linux_asihpi.c'}];

        compiler_flags = [compiler_flags, {'PA_USE_ASIHPI'}];
    end

    if use_jack
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/jack/pa_jack.c'}];

        extra_flags = [extra_flags, {'-ljack'}];
                             
        compiler_flags = [compiler_flags, {'PA_USE_JACK'}];
    end
    
    if use_oss
        pa_api_specific_files = [pa_api_specific_files,...
                                 {'src/hostapi/oss/pa_unix_oss.c'}];

        compiler_flags = [compiler_flags, {'PA_USE_OSS'}];

        % OSS needs some system specific defines. Following one work on
        % Linux, but might not work for other UNIX like BSD.
        compiler_flags = [compiler_flags, {'HAVE_SYS_SOUNDCARD_H'}];
        compiler_flags = [compiler_flags, {'HAVE_LINUX_SOUNDCARD_H'}];
    end
end

if case_insensitive
    compiler_flags = [compiler_flags, {'CASE_INSENSITIVE_COMMAND_NAME'}];
end

if debug
    compiler_flags = [compiler_flags, {'DEBUG'}];
end

%-assemble everything together
pa_files = resolve_paths(pa_path, [pa_common_files, ...
                                   pa_api_specific_files, ...
                                   pa_os_specific_files]);
pa_include_dirs = resolve_paths(pa_path, pa_include_dirs);

if ~isempty(api_files)
    api_files = resolve_paths('', api_files);
end
if ~isempty(api_include_dirs)
    api_include_dirs = resolve_paths('', api_include_dirs);
end

all_files = [main_files, pa_files, api_files];
all_include_dirs = [main_include_dirs, pa_include_dirs, api_include_dirs];
all_link_libs = [link_libs, api_link_libs];

failed = build_mex('playrec',all_files,all_include_dirs,compiler_flags,all_link_libs,lib_dirs,extra_flags,debug,verbose);
