project(ServiceBundle)

include(PocoBundles)

poco_add_single_library_bundle(ServiceLibrary com.example.service
	VERSION 1.0.0 ACTIVATOR_CLASS ServiceBundleActivator FOLDER Service
	src/ServiceBundleActivator.h src/ServiceBundleActivator.cpp src/AdditionService.h src/AdditionService.cpp)

set_source_files_properties(src/AdditionService.h PROPERTIES POCO_BUNDLE_PUBLIC_HEADER_LOCATION "example")

find_package(Poco REQUIRED Foundation Util OSP)
include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(ServiceLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.service COPY_TO bundle-container)
poco_install_bundle(TARGETS com.example.service 
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include
)