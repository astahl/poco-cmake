cmake_minimum_required(VERSION 2.8.10.2)

project(poco-cmake-examples)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/)
list(APPEND CMAKE_INCLUDE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/)

add_subdirectory(BundleContainerApplication)
add_subdirectory(SimpleBundle)