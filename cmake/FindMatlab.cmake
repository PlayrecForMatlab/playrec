#  Try to find Matlab
#  This will define
#
#  MATLAB_INCLUDE_DIRS: include path for mex.h
#  MATLAB_LIBRARY_DIRS: include path for mex.h
#  MATLAB_LIBRARIES:   required libraries: libmex, libmx
#  MATLAB_MEX_SUFFIX: mexw32, mexw64, mexmaci64, mexglx or mexa64
if (MATLAB_LIBRARIES AND MATLAB_INCLUDE_DIRS AND MATLAB_MEX_SUFFIX)
    # in cache already
    set(MATLAB_FOUND TRUE)
else (MATLAB_LIBRARIES AND MATLAB_INCLUDE_DIRS AND MATLAB_MEX_SUFFIX)
    if( "$ENV{MATLAB_ROOT}" STREQUAL "" )
        MESSAGE(STATUS "MATLAB_ROOT environment variable not set." )
        MESSAGE(STATUS "In Linux: export MATLAB_ROOT=/usr/local/MATLAB/R2014b" )
        MESSAGE(STATUS "In Mac OS X: export MATLAB_ROOT=/Applications/MATLAB_R2014b.app" )
        MESSAGE(STATUS "Windows: add system variable, e.g:" )
        MESSAGE(STATUS "MATLAB_ROOT=C:\\Program Files\\MATLAB\\R2014b" )
    else("$ENV{MATLAB_ROOT}" STREQUAL "" )
        message(STATUS "You say that matlab is in: $ENV{MATLAB_ROOT} ... let's see")

        find_path(MATLAB_INCLUDE_DIR
        NAMES mex.h
        PATHS
        $ENV{MATLAB_ROOT}/extern/include
        NO_DEFAULT_PATH)
        set(MATLAB_INCLUDE_DIRS ${MATLAB_INCLUDE_DIR})
        
  
        if (WIN32 AND (NOT MINGW)) #Windows seems to have problems with find_library
            find_path(MATLAB_LIBRARY_DIR
            NAMES
            libmex.lib           
            PATHS
            $ENV{MATLAB_ROOT}/extern/lib/win64/microsoft
            $ENV{MATLAB_ROOT}/extern/lib/win32/microsoft)

            set(MATLAB_LIBRARIES 
                libmx 
                libmex 
                libmat)
            set(MATLAB_COMP_FLAGS_RELEASE "/O2 /Oy- /DNDEBUG /MD /DMX_COMPAT_32 /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE")
            set(MATLAB_COMP_FLAGS_DEBUG "/Z7 /MD /DMX_COMPAT_32 /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE")
            set(MATLAB_LINK_FLAGS_RELEASE "/nologo /manifest /EXPORT:mexFunction")
            set(MATLAB_LINK_FLAGS_DEBUG "/debug /nologo /manifest /EXPORT:mexFunction")
        else (WIN32 AND (NOT MINGW))
            find_path(MATLAB_LIBRARY_DIR
            NAMES
            libmex.lib libmex.dylib libmex.so libmex.dll           
            PATHS
            $ENV{MATLAB_ROOT}/bin/glnxa64 
            $ENV{MATLAB_ROOT}/bin/glnx86
            $ENV{MATLAB_ROOT}/bin/maci64
            $ENV{MATLAB_ROOT}/bin/win64
            $ENV{MATLAB_ROOT}/bin/win32)
            set(MATLAB_LIBRARIES 
                mx 
                mex 
                mat)        
            set(MATLAB_COMP_FLAGS_RELEASE "-O3 -DMATLAB_MEX_FILE")
            set(MATLAB_COMP_FLAGS_DEBUG "-O0 -g -DMATLAB_MEX_FILE")
            set(MATLAB_LINK_FLAGS_DEBUG "-g")
        endif (WIN32 AND (NOT MINGW))
        set(MATLAB_LIBRARY_DIRS ${MATLAB_LIBRARY_DIR})
        
        if (CMAKE_BUILD_TYPE MATCHES RELEASE)
            set(MATLAB_COMP_FLAGS ${MATLAB_COMP_FLAGS_RELEASE})
            set(MATLAB_LINK_FLAGS ${MATLAB_LINK_FLAGS_RELEASE})
        else (CMAKE_BUILD_TYPE MATCHES RELEASE)
            set(MATLAB_COMP_FLAGS ${MATLAB_COMP_FLAGS_DEBUG})
            set(MATLAB_LINK_FLAGS ${MATLAB_LINK_FLAGS_DEBUG})
        endif (CMAKE_BUILD_TYPE MATCHES RELEASE)

        STRING(REGEX MATCH glnxa64
            MATLAB_ARCH_GLNXA64 ${MATLAB_LIBRARY_DIR})        
        STRING(REGEX MATCH glnx86
            MATLAB_ARCH_GLNX86 ${MATLAB_LIBRARY_DIR})        
        STRING(REGEX MATCH maci64
            MATLAB_ARCH_MACI64 ${MATLAB_LIBRARY_DIR})        
        STRING(REGEX MATCH win64
            MATLAB_ARCH_WIN64 ${MATLAB_LIBRARY_DIR})        
        STRING(REGEX MATCH win32
            MATLAB_ARCH_WIN32 ${MATLAB_LIBRARY_DIR})        
        if (MATLAB_ARCH_GLNXA64)
            set (MATLAB_MEX_SUFFIX ".mexa64")
        endif (MATLAB_ARCH_GLNXA64)
        if (MATLAB_ARCH_GLNX86)
            set (MATLAB_MEX_SUFFIX ".mexglx")
        endif (MATLAB_ARCH_GLNX86)
        if (MATLAB_ARCH_MACI64)
            set (MATLAB_MEX_SUFFIX ".mexmaci64")
        endif (MATLAB_ARCH_MACI64)
        if (MATLAB_ARCH_WIN64)
            set (MATLAB_MEX_SUFFIX ".mexw64")
        endif (MATLAB_ARCH_WIN64)
        if (MATLAB_ARCH_WIN32)
            set (MATLAB_MEX_SUFFIX ".mexw32")
        endif (MATLAB_ARCH_WIN32)
        
        if (MATLAB_INCLUDE_DIRS AND MATLAB_LIBRARY_DIRS)
            set(MATLAB_FOUND TRUE)
        endif (MATLAB_INCLUDE_DIRS AND MATLAB_LIBRARY_DIRS)
        
        if (MATLAB_FOUND)
            if (NOT Matlab_FIND_QUIETLY)
                message(STATUS "Found Matlab libraries for building mex:")
                message(STATUS "   include dir: ${MATLAB_INCLUDE_DIRS}")
                message(STATUS "   library dir: ${MATLAB_LIBRARY_DIRS}")
                message(STATUS "     libraries: ${MATLAB_LIBRARIES}")
                message(STATUS "    mex suffix: ${MATLAB_MEX_SUFFIX}")
                message(STATUS "    comp flags: ${MATLAB_COMP_FLAGS}")
                message(STATUS "    link flags: ${MATLAB_LINK_FLAGS}")
            endif (NOT Matlab_FIND_QUIETLY)
        else (MATLAB_FOUND)
            if (Matlab_FIND_REQUIRED)
                message(FATAL_ERROR "Could not find Matlab, bailing out")
            endif (Matlab_FIND_REQUIRED)
        endif (MATLAB_FOUND)        
    mark_as_advanced(
        MATLAB_LIBRARIES 
        MATLAB_MEX_SUFFIX
        MATLAB_INCLUDE_DIRS
        MATLAB_LIBRARY_DIRS
        MATLAB_COMP_FLAGS
        MATLAB_LINK_FLAGS)
    endif("$ENV{MATLAB_ROOT}" STREQUAL "" )
endif (MATLAB_LIBRARIES AND MATLAB_INCLUDE_DIRS AND MATLAB_MEX_SUFFIX)
