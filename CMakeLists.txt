cmake_minimum_required(VERSION 2.8)
project(PLAYREC)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

#CMake 'debug' build does an optimized build?
#TODO: Q&D now -check for compiler, and move to a separate file
SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g")
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g")

IF(CMAKE_BUILD_TYPE MATCHES Debug)
  message(STATUS "configuring DEBUG build...")
  SET(CMAKE_BUILD_TYPE DEBUG)
ELSE(CMAKE_BUILD_TYPE MATCHES Debug)
  message(STATUS "configuring RELEASE build...")
  SET(CMAKE_BUILD_TYPE RELEASE)
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug)

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

find_package(Matlab REQUIRED)
find_package(Portaudio REQUIRED)
 
IF(MATLAB_FOUND AND PORTAUDIO_FOUND)
   set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})
   message(STATUS "All found, Playrec will be compiled.")
   #FILE(GLOB matlab_stuff "*.m")
   #INSTALL(FILES ${matlab_stuff} DESTINATION .)
   add_subdirectory(src)
 ELSE(MATLAB_FOUND AND PORTAUDIO_FOUND)
  MESSAGE("Nothing will be built.")
ENDIF(MATLAB_FOUND AND PORTAUDIO_FOUND)

