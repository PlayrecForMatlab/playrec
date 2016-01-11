Playrec is a Matlab and Octave utility (MEX file) that provides simple yet 
versatile access to soundcards using PortAudio, a free, open-source audio 
I/O library. It can be used on different platforms (Windows, Macintosh, 
Unix) and access the soundcard via different host API including ASIO, WMME 
and DirectSound under Windows.

Playrec's main features include:

### Non-blocking soundcard access.

All samples are buffered so Matlab can continue with other processing 
whilst output and recording occur.

### Continuous play and record with no glitches.

All new output samples are automatically appended to any remaining samples. 
This makes it possible for the audio data to be generated as required, the 
only limit being the processing power of the computer. Recording in 
multiple sections without missed samples can also easily be achieved.

### Minimal configuration.

A list of all available devices can be easily obtained. Configuration then 
just requires the sample rate and the unique id of the device(s) to be used 
for output and/or recording. There is no need to specify how much buffering 
is required as this is all handled dynamically.

### No imposed sample count restrictions.

There is no limit imposed to restrict the minimum or maximum number of 
samples that can be passed to the utility at any one time, the only 
restrictions are those due to limitations in available memory or processing 
power.

### Multi-channel soundcard support.

The utility was specifically designed to simplify working with soundcards 
with any number of channels: output samples only need to be provided for 
those channels which are not zero, and samples will only be recorded on 
channels specified. This reduces memory usage and makes accessing arbitrary 
channels on the device very simple. Additionally because this information 
is provided with the samples, different sets of channels can be used without 
the need for reconfiguration.

### Multiple platform and host API support.

By using PortAudio to access the soundcard, Playrec should function on all 
platforms and with all host APIs that PortAudio supports.

### Download and compilation with cmake
cmake based build will install playrec.mex to the top level of
playrec source directory. It can be moved from there to desired location.

Clone the playrec repository from github
```
% git clone git@github.com:hbe72/playrec.git
```
####Compilation with system's installation of portaudio

#####Ubuntu:
```
% sudo apt-get install cmake 
% sudo apt-get install portaudio19-dev
% export MATLAB_ROOT=/opt/MATLAB/R2015b
```

#####Mac: 
  Install homebrew install homebrew (see. brew.sh)
```
% brew install cmake
% brew install portaudio
% export MATLAB_ROOT=/Applications/MATLAB_R2015b.app 
```

#####Compile:
```

% cd playrec 
% mkdir build; cd build 
% cmake .. 
% make 
% make install 
```
#### Compilation from scratch from portaudio sources:
##### Ubuntu, Mac & MinGW
```
% mkdir portaudio; cd portaudio
% ../playrec/compile_portaudio.sh [installation directory]
```

See further instructions from the end of compile_portaudio.sh for setting the
environment variables
```
% export PKG_CONFIG_PATH=<absolute path to portaudio installation directory>/lib/pkgconfig:$PKG_CONFIG_PATH
% export MATLAB_ROOT=/Applications/MATLAB_R2015b.app  
% cd ../playrec 
% mkdir build; cd build 
% cmake .. 
% make 
% make install 
```
##### Windows with Visual Studio
Suggested directory structure for FindPortaudio.cmake 
```
----- portaudio  ----- portaudio
     |                           |
     |                           -- ASIOSDK2.3
     |                           |
     |                           -- build
     |                           -- lib
     |                           -- bin
     |                           -- include
      -- playrec
```
Thus download and uncompress portaudio and asiosdk accordingly from
http://www.portaudio.com/archives/pa_snapshot.tgz and http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip

Open "VS<version> x64 Cross Tools Command Prompt" and browse to
portaudio subdirectory
###### Build portaudio
```
> mkdir build
> cd build
> cmake -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=<portaudio_install_dir> -DCMAKE_BUILD_TYPE=Release ../portaudio
> nmake /f Makefile
> nmake /f Makefile install
```
Thus installation is done to lib, bin and include subdirectories of
portaudio_install_dir. portaudio_install_dir has to be absolute path
to the portaudio subdirectory beside playrec subdirectory for
FindPortaudio.cmake to find it.

###### Build playrec
> cd ../../playrec
> mkdir build
> cd build
> cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ..
> nmake /f Makefile
> nmake /f Makefile install

#### Test the installation

On Matlab command prompt at playrec directory:
```
>> playrec('about')
```

Clone playrec-examples from
```
% git clone git@github.com:PlayrecForMatlab/playrec-examples.git
```

Add playrec to Matlab path and execute test_playrec.m from
playrec-examples directory
```
>> test_playrec
```
