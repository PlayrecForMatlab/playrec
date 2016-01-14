#  Try to find Octave
#  This will define
#
#  OCTAVE_INCLUDE_DIRS: include path for mex.h
#  OCTAVE_LIBRARY_DIRS: include path for mex.h
#  OCTAVE_LIBRARIES:   required libraries: libmex, libmx
#  OCTAVE_MEX_SUFFIX: mexw32, mexw64, mexmaci64, mexglx or mexa64
if (OCTAVE_LIBRARIES AND OCTAVE_INCLUDE_DIRS AND OCTAVE_MEX_SUFFIX)
    # in cache already
    set(OCTAVE_FOUND TRUE)
else (OCTAVE_LIBRARIES AND OCTAVE_INCLUDE_DIRS AND OCTAVE_MEX_SUFFIX)
    if( "$ENV{OCTAVE_ROOT}" STREQUAL "" )
        MESSAGE(STATUS "OCTAVE_ROOT environment variable not set" )
        MESSAGE(STATUS "...Trying the usual paths" )
    endif("$ENV{OCTAVE_ROOT}" STREQUAL "" )
          
        find_path(OCTAVE_INCLUDE_DIR
        NAMES mex.h
        PATHS
        $ENV{OCTAVE_ROOT}/include/octave-3.8.1/octave
        $ENV{OCTAVE_ROOT}/include/octave-4.0.0/octave
        /usr/local/include/octave-3.8.1/octave
        /usr/local/include/octave-4.0.0/octave
        /usr/include/octave-3.8.1/octave
        /usr/include/octave-4.0.0/octave)
        set(OCTAVE_INCLUDE_DIRS ${OCTAVE_INCLUDE_DIR})
        
        if (WIN32 AND (NOT MINGW)) #Windows seems to have problems with find_library
            find_path(OCTAVE_LIBRARY_DIR
            NAMES
            liboctave.lib           
            PATHS
            $ENV{OCTAVE_ROOT}/lib/octave/3.8.1
	    $ENV{OCTAVE_ROOT}/lib/octave/4.0.0)

            set(OCTAVE_LIBRARIES 
                liboctave 
                liboctinterp)
            #set(OCTAVE_COMP_FLAGS_RELEASE "")
            #set(OCTAVE_COMP_FLAGS_DEBUG "")
            #set(OCTAVE_LINK_FLAGS_RELEASE "/EXPORT:mexFunction")
            #set(OCTAVE_LINK_FLAGS_DEBUG "/debug /nologo /manifest /EXPORT:mexFunction")
        else (WIN32 AND (NOT MINGW))
            find_path(OCTAVE_LIBRARY_DIR
            NAMES
            liboctave.lib liboctave.dylib liboctave.so liboctave.dll           
            PATHS
            $ENV{OCTAVE_ROOT}/lib/octave/4.0.0
            /usr/local/lib/octave/3.8.1
            /usr/local/lib/octave/4.0.0
	    /usr/lib/x86_64-linux-gnu)
            set(OCTAVE_LIBRARIES
                octave 
                octinterp)        
            set(OCTAVE_COMP_FLAGS_RELEASE "-O3 -D_THREAD_SAFE -pthread -D_REENTRANT   -I.")
            set(OCTAVE_COMP_FLAGS_DEBUG "-O0 -D_THREAD_SAFE -pthread -D_REENTRANT   -I.")
            set(OCTAVE_LINK_FLAGS_DEBUG "-g")
        endif (WIN32 AND (NOT MINGW))
        set(OCTAVE_LIBRARY_DIRS ${OCTAVE_LIBRARY_DIR})
        
        if (CMAKE_BUILD_TYPE MATCHES RELEASE)
            set(OCTAVE_COMP_FLAGS ${OCTAVE_COMP_FLAGS_RELEASE})
            set(OCTAVE_LINK_FLAGS ${OCTAVE_LINK_FLAGS_RELEASE})
        else (CMAKE_BUILD_TYPE MATCHES RELEASE)
            set(OCTAVE_COMP_FLAGS ${OCTAVE_COMP_FLAGS_DEBUG})
            set(OCTAVE_LINK_FLAGS ${OCTAVE_LINK_FLAGS_DEBUG})
        endif (CMAKE_BUILD_TYPE MATCHES RELEASE)

        set (OCTAVE_MEX_SUFFIX ".mex")
        
        if (OCTAVE_INCLUDE_DIRS AND OCTAVE_LIBRARY_DIRS)
            set(OCTAVE_FOUND TRUE)
        endif (OCTAVE_INCLUDE_DIRS AND OCTAVE_LIBRARY_DIRS)
        
        if (OCTAVE_FOUND)
            if (NOT Octave_FIND_QUIETLY)
                message(STATUS "Found Octave libraries for building mex:")
                message(STATUS "   include dir: ${OCTAVE_INCLUDE_DIRS}")
                message(STATUS "   library dir: ${OCTAVE_LIBRARY_DIRS}")
                message(STATUS "     libraries: ${OCTAVE_LIBRARIES}")
                message(STATUS "    mex suffix: ${OCTAVE_MEX_SUFFIX}")
                message(STATUS "    comp flags: ${OCTAVE_COMP_FLAGS}")
                message(STATUS "    link flags: ${OCTAVE_LINK_FLAGS}")
            endif (NOT Octave_FIND_QUIETLY)
        else (OCTAVE_FOUND)
            if (Matlab_FIND_REQUIRED)
                message(FATAL_ERROR "Could not find Octave, bailing out")
            endif (Matlab_FIND_REQUIRED)
        endif (OCTAVE_FOUND)        
    mark_as_advanced(
        OCTAVE_LIBRARIES 
        OCTAVE_MEX_SUFFIX
        OCTAVE_INCLUDE_DIRS
        OCTAVE_LIBRARY_DIRS
        OCTAVE_COMP_FLAGS
        OCTAVE_LINK_FLAGS)
endif (OCTAVE_LIBRARIES AND OCTAVE_INCLUDE_DIRS AND OCTAVE_MEX_SUFFIX)
