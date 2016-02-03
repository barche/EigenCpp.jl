project(Examples)

cmake_minimum_required(VERSION 3.1)

set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

list(APPEND CMAKE_CXX_FLAGS "-std=c++11")

find_package(CppWrapper)

include_directories("${CMAKE_CURRENT_BINARY_DIR}/../../src/eigen/include/eigen3")

add_library(eigen_wrapper SHARED wrap_eigen.cpp)
target_link_libraries(eigen_wrapper CppWrapper::cpp_wrapper)

install(TARGETS
  eigen_wrapper
LIBRARY DESTINATION lib)
