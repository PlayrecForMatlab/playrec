#!/bin/bash

TARGET_DIR=$1

if test "x$2" == "x--debug-build";
then
export CFLAGS=-O0
export CPPFLAGS=-O0
export CXXFLAGS=-O0
else
export CFLAGS=-O3
export CPPFLAGS=-O3
export CXXFLAGS=-O3
fi

portaudio_release_url=http://www.portaudio.com/archives
#portaudio_tgz=pa_stable_v19_20140130.tgz #Latest stable
portaudio_tgz=pa_snapshot.tgz #Latest snapshot
steinberg_asio_url=http://www.steinberg.net/sdk_downloads
steinberg_asio_zip=asiosdk2.3.zip

build_dir=build

function eexit {
   echo $1
   exit 1
}

# Fetch portaudio release.
if ! test -f $portaudio_tgz;
then
  wget $portaudio_release_url/$portaudio_tgz \
  || eexit "wget of portaudio failed"
fi

if test -d portaudio;
then
  rm -rf portaudio
fi
tar -xzf $portaudio_tgz \
|| eexit "portaudio tar.gz extraction failed"


if ! test -f $steinberg_asio_zip;
then
  wget $steinberg_asio_url/$steinberg_asio_zip \
  || eexit "wget of Steinberg ASIO SDK failed"
fi

if test -d ASIOSDK2.3;
then
  rm -rf ASIOSDK2.3
fi
unzip $steinberg_asio_zip \
|| eexit "Steinberg ASIO SDK extraction failed"

if test "x$1" == "x"
then
   install_prefix=$PWD
else
   install_prefix=$1
fi

mkdir -p $build_dir
cd $build_dir

../portaudio/configure --enable-static --prefix=$install_prefix
make -j8 || eexit "Building portaudio failed"
#make install || eexit "Install of portaudio failed"

# For compiling playrec in all platforms (Mac OS X, Linux, MinGW-MSYS)
# export PKG_CONFIG_PATH=$install_prefix/lib/pkgconfig:$PKG_CONFIG_PATH

# You may need to set
# export LD_LIBRARY_PATH=$install_prefix/lib:$LD_LIBRARY_PATH in Linux
# export DYLD_LIBRARY_PATH=$install_prefix/lib:$DYLD_LIBRARY_PATH in Mac

# And in Windows add $install_prefix/bin to the "PATH" Environment Variable

