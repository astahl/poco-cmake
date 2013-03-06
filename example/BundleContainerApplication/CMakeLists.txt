project(BundleContainerApplication)

add_executable(bundle-container src/BundleContainerApplication.cpp)

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(bundle-container ${Poco_LIBRARIES})