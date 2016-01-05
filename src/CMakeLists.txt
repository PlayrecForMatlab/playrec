# compile mex
cmake_minimum_required(VERSION 2.8)

set(PLAYREC_SOURCE_FILES  
   pa_dll_playrec.c 
   mex_dll_core.c 
  )  
set(PLAYREC_HEADER_FILES  
   pa_dll_playrec.h 
   mex_dll_core.h
  )  

include_directories(${MATLAB_INCLUDE_DIR} ${PORTAUDIO_INCLUDE_DIRS})

add_library(playrec SHARED ${PLAYREC_SOURCE_FILES})
target_link_libraries(playrec ${MATLAB_MEX_LINK_FLAGS} ${PORTAUDIO_LIBRARIES})
SET_TARGET_PROPERTIES(playrec PROPERTIES SUFFIX ${MATLAB_MEX_SUFFIX} PREFIX "") 

install(TARGETS playrec DESTINATION .)
#INSTALL(FILES playrec.m DESTINATION .)
