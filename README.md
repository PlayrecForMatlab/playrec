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

To use this utility it must first be downloaded and compiled.
