function varargout = compile_playrec_gui(varargin)
% COMPILE_PLAYREC_GUI is a graphical user interface which takes much of the
% pain out of compiling the playrec audio I/O interface for matlab.
%
% It uses matlab's 'mex' command to compile a mex file which is compatible
% with your version of matlab.  However, for this to work properly you must
% have configured matlab to use the 'mex' command.  For help on how to do
% this see the documentation.
%
% To use this GUI, simply locate the required directories and press
% compile.  
%
% Playrec
% Copyright (c) 2007-2008 Robert Humphrey, Alastair Moore
%
% Permission is hereby granted, free of charge, to any person
% obtaining a copy of this software and associated documentation
% files (the "Software"), to deal in the Software without
% restriction, including without limitation the rights to use,
% copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following
% conditions:
%
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.
%

% Last Modified by GUIDE v2.5 16-Dec-2007 14:22:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compile_playrec_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @compile_playrec_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1}) && (~isempty(varargin{1}))
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before compile_playrec_gui is made visible.
function compile_playrec_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compile_playrec_gui (see VARARGIN)

% Choose default command line output for compile_playrec_gui
handles.output = hObject;

% Check which platform we are on and fill in API menu options 
api_alsa = 0;
api_asihpi = 0;
api_asio = 0;
api_coreaudio = 0;
api_dsound = 0;
api_jack = 0;
api_oss = 0;
api_wasapi = 0;
api_wdmks = 0;
api_wmme = 0;

if length(varargin) >= 2
    set(handles.api_asio_path_textbox,'String', varargin{2});
end

if length(varargin) >= 3
    set(handles.api_dsound_path_textbox,'String', varargin{3});
end

if length(varargin) >= 4
    set(handles.pa_path_textbox,'String', varargin{4});
end

if length(varargin) >= 5
    set(handles.sdk_path_textbox,'String', varargin{5});
end


if is_os('WIN')
    api_asio = 1;
    api_dsound = 1;
    api_wasapi = 1;
    api_wdmks = 1;
    api_wmme = 1;   
    
    set(handles.platform_sdk_path_textbox,'Enable','on');
    set(handles.platform_sdk_browse_button,'Enable','on');
    set(handles.platform_sdk_directory_text,'Enable','on');
    set(handles.case_insensitive_checkbox,'Enable','on');
elseif is_os('MAC')
    api_asio = 1;
    api_coreaudio = 1;
    api_jack = 1;
    
    set(handles.platform_sdk_path_textbox,'Enable','off');
    set(handles.platform_sdk_browse_button,'Enable','off');
    set(handles.platform_sdk_directory_text,'Enable','off');
    set(handles.case_insensitive_checkbox,'Enable','off');
else
    api_alsa = 1;
    api_asihpi = 1;
    api_jack = 1;
    api_oss = 1;
    
    set(handles.platform_sdk_path_textbox,'Enable','off');
    set(handles.platform_sdk_browse_button,'Enable','off');
    set(handles.platform_sdk_directory_text,'Enable','off');
    set(handles.case_insensitive_checkbox,'Enable','off');
end

if (api_alsa)
    set(handles.api_alsa_checkbox,'Enable','on');
    set(handles.api_alsa_checkbox,'Value', 1);
else
    set(handles.api_alsa_checkbox,'Enable','off');
    set(handles.api_alsa_checkbox,'Value', 0);
end

if (api_asihpi)
    set(handles.api_asihpi_checkbox,'Enable','on');
    set(handles.api_asihpi_checkbox,'Value', 1);
else
    set(handles.api_asihpi_checkbox,'Enable','off');
    set(handles.api_asihpi_checkbox,'Value', 0);
end

if (api_asio)
    set(handles.api_asio_checkbox,'Enable','on');
    set(handles.api_asio_checkbox,'Value', 1);
    set(handles.api_asio_path_textbox,'Enable','on');
    set(handles.api_asio_browse_button,'Enable','on');
else
    set(handles.api_asio_checkbox,'Enable','off');
    set(handles.api_asio_checkbox,'Value', 0);
    set(handles.api_asio_path_textbox,'Enable','off');
    set(handles.api_asio_browse_button,'Enable','off');
end

if (api_coreaudio)
    set(handles.api_coreaudio_checkbox,'Enable','on');
    set(handles.api_coreaudio_checkbox,'Value', 1);
else
    set(handles.api_coreaudio_checkbox,'Enable','off');
    set(handles.api_coreaudio_checkbox,'Value', 0);
end

if (api_dsound)
    set(handles.api_dsound_checkbox,'Enable','on');
    set(handles.api_dsound_checkbox,'Value', 1);
    set(handles.api_dsound_path_textbox,'Enable','on');
    set(handles.api_dsound_browse_button,'Enable','on');
else
    set(handles.api_dsound_checkbox,'Enable','off');
    set(handles.api_dsound_checkbox,'Value', 0);
    set(handles.api_dsound_path_textbox,'Enable','off');
    set(handles.api_dsound_browse_button,'Enable','off');
end

if (api_jack)
    set(handles.api_jack_checkbox,'Enable','on');
    set(handles.api_jack_checkbox,'Value', 1);
else
    set(handles.api_jack_checkbox,'Enable','off');
    set(handles.api_jack_checkbox,'Value', 0);
end

if (api_oss)
    set(handles.api_oss_checkbox,'Enable','on');
    set(handles.api_oss_checkbox,'Value', 1);
else
    set(handles.api_oss_checkbox,'Enable','off');
    set(handles.api_oss_checkbox,'Value', 0);
end

if (api_wasapi)
    set(handles.api_wasapi_checkbox,'Enable','on');
    set(handles.api_wasapi_checkbox,'Value', 1);
else
    set(handles.api_wasapi_checkbox,'Enable','off');
    set(handles.api_wasapi_checkbox,'Value', 0);
end

if (api_wdmks)
    set(handles.api_wdmks_checkbox,'Enable','on');
    set(handles.api_wdmks_checkbox,'Value', 1);
else
    set(handles.api_wdmks_checkbox,'Enable','off');
    set(handles.api_wdmks_checkbox,'Value', 0);
end

if (api_wmme)
    set(handles.api_wmme_checkbox,'Enable','on');
    set(handles.api_wmme_checkbox,'Value', 1);
else
    set(handles.api_wmme_checkbox,'Enable','off');
    set(handles.api_wmme_checkbox,'Value', 0);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes compile_playrec_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = compile_playrec_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pa_browse_button.
function pa_browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to pa_browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get current dir from pa_path_textbox
start_dir = get(handles.pa_path_textbox,'String');
if isempty(start_dir)
    start_dir = mfilename('fullpath');
    start_dir = start_dir(1:end-length(mfilename));
end
%display folder select box
directory_name = uigetdir(start_dir,'Select the root directory of the PortAudio installation...');
if directory_name
    set(handles.pa_path_textbox, 'String', directory_name);
end

guidata(hObject, handles);

% --- Executes on button press in api_asio_browse_button.
function api_asio_browse_button_Callback(hObject, eventdata, handles)
%get current directroy from api_asio_path_textbox
start_dir = get(handles.api_asio_path_textbox,'String');
if isempty(start_dir)
    start_dir = mfilename('fullpath');
    start_dir = start_dir(1:end-length(mfilename));
end
%display folder select box
directory_name = uigetdir(start_dir,'Select the root directory of the ASIO api installation...');
if directory_name
    set(handles.api_asio_path_textbox, 'String', directory_name);
end

guidata(hObject, handles);

% --- Executes on button press in api_dsound_browse_button.
function api_dsound_browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to api_dsound_browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get current directroy from api_dsound_path_textbox
start_dir = get(handles.api_dsound_path_textbox,'String');
if isempty(start_dir)
    start_dir = mfilename('fullpath');
    start_dir = start_dir(1:end-length(mfilename));
end
%display folder select box
directory_name = uigetdir(start_dir,'Select the root directory of the DirectX api installation...');
if directory_name
    set(handles.api_dsound_path_textbox, 'String', directory_name);
end

guidata(hObject, handles);

% --- Executes on button press in platform_sdk_browse_button.
function platform_sdk_browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to platform_sdk_browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get current dir from pa_path_textbox
start_dir = get(handles.platform_sdk_path_textbox,'String');
if isempty(start_dir)
    start_dir = mfilename('fullpath');
    start_dir = start_dir(1:end-length(mfilename));
end
%display folder select box
directory_name = uigetdir(start_dir,'Select the lib directory of the platform sdk installation...');
if directory_name
    set(handles.platform_sdk_path_textbox, 'String', directory_name);
end

guidata(hObject, handles);

% --- Executes on button press in compile_button.
function compile_button_Callback(hObject, eventdata, handles)
% hObject    handle to compile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Disable compile button until complete
set(handles.compile_button, 'Enable', 'off');

drawnow;

%compile
if compile_playrec_func (get(handles.debug_checkbox,'Value'),             ... % debug
                         get(handles.verbose_checkbox,'Value'),           ... % verbose
                         get(handles.case_insensitive_checkbox, 'Value'), ... % case_insensitive
                         get(handles.api_alsa_checkbox,'Value'),          ... % use_alsa
                         get(handles.api_asihpi_checkbox,'Value'),        ... % use_asihpi
                         get(handles.api_asio_checkbox,'Value'),          ... % use_asio
                         get(handles.api_coreaudio_checkbox,'Value'),     ... % use_coreaudio
                         get(handles.api_dsound_checkbox,'Value'),        ... % use_dsound
                         get(handles.api_jack_checkbox,'Value'),          ... % use_jack
                         get(handles.api_oss_checkbox,'Value'),           ... % use_oss
                         get(handles.api_wasapi_checkbox,'Value'),        ... % use_wasapi
                         get(handles.api_wdmks_checkbox,'Value'),         ... % use_wdmks
                         get(handles.api_wmme_checkbox,'Value'),          ... % use_wmme
                         get(handles.api_asio_path_textbox,'String'),     ... % asio_path
                         get(handles.api_dsound_path_textbox,'String'),   ... % dsound_path
                         get(handles.pa_path_textbox,'String'),           ... % pa_path
                         get(handles.platform_sdk_path_textbox,'String')  ... % sdk_path
                        )

    % returns non-zero if failed
    msgbox('Compiling Playrec failed, see the Command Window for more information.', 'Compilation Failed','error');
else
    msgbox('Compiling Playrec completed successfully.', 'Compilation Complete');
end

set(handles.compile_button, 'Enable', 'on');


% --- Executes on button press in api_asio_checkbox.
function api_asio_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to api_asio_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of api_asio_checkbox
if(get(handles.api_asio_checkbox,'Value'))
    set(handles.api_asio_path_textbox,'Enable','on');
    set(handles.api_asio_browse_button,'Enable','on');
else
    set(handles.api_asio_path_textbox,'Enable','off');
    set(handles.api_asio_browse_button,'Enable','off');    
end

guidata(hObject, handles);

% --- Executes on button press in api_dsound_checkbox.
function api_dsound_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to api_dsound_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of api_dsound_checkbox
if(get(handles.api_dsound_checkbox,'Value'))
    set(handles.api_dsound_path_textbox,'Enable','on');
    set(handles.api_dsound_browse_button,'Enable','on');
else
    set(handles.api_dsound_path_textbox,'Enable','off');
    set(handles.api_dsound_browse_button,'Enable','off');    
end

guidata(hObject, handles);
