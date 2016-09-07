cmake_minimum_required(VERSION 3.5)
project(Actividad3)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp main2.cpp)
add_executable(Actividad3 ${SOURCE_FILES})