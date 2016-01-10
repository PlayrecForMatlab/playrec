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

include_directories(${MATLAB_INCLUDE_DIRS} ${PORTAUDIO_INCLUDE_DIRS})
link_directories(${MATLAB_LIBRARY_DIRS})

add_library(playrec SHARED ${PLAYREC_SOURCE_FILES})
target_link_libraries(playrec ${MATLAB_LIBRARIES} ${PORTAUDIO_LIBRARIES})
set_target_properties(playrec PROPERTIES SUFFIX ${MATLAB_MEX_SUFFIX} 
                                         PREFIX "") 
if (NOT ${MATLAB_COMP_FLAGS} MATCHES "")
  set_target_properties(playrec PROPERTIES COMP_FLAGS ${MATLAB_COMP_FLAGS}) 
endif (NOT ${MATLAB_COMP_FLAGS} MATCHES "")
if (MATLAB_LINK_FLAGS)
  set_target_properties(playrec PROPERTIES LINK_FLAGS ${MATLAB_LINK_FLAGS}) 
endif (MATLAB_LINK_FLAGS)

install(TARGETS playrec DESTINATION .)
#INSTALL(FILES playrec.m DESTINATION .)
