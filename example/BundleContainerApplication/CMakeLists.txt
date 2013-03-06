project(BundleContainerApplication)

add_executable(bundle-container src/BundleContainerApplication.cpp)

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(bundle-container ${Poco_LIBRARIES})

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bundles)
set(POCO_BUNDLE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bundles PARENT_SCOPE)

install(TARGETS bundle-container RUNTIME DESTINATION bin)