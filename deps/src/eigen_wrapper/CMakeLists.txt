project(Examples)

cmake_minimum_required(VERSION 3.1)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_DIR}/../")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -march=native")
add_definitions(-DJULIA_ENABLE_THREADING)

find_package(JlCxx)

include_directories("${CMAKE_CURRENT_BINARY_DIR}/../../src/eigen/include/eigen3")

add_library(eigen_wrapper SHARED wrap_eigen.cpp)
target_link_libraries(eigen_wrapper JlCxx::jlcxx)
target_compile_features(eigen_wrapper PRIVATE cxx_generic_lambdas)

install(TARGETS
  eigen_wrapper
LIBRARY DESTINATION lib)
