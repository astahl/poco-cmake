project(ConsumerBundle)

include(PocoBundles)

poco_add_single_library_bundle(ConsumerLibrary com.example.consumer 
	VERSION 1.0.0 ACTIVATOR_CLASS ConsumerBundleActivator FOLDER Consumer
	src/ConsumerBundleActivator.h src/ConsumerBundleActivator.cpp)

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS} ../ServiceBundle/src)
target_link_libraries(ConsumerLibrary ${Poco_LIBRARIES})

poco_add_bundle_dependency(com.example.consumer com.example.service)

poco_finalize_bundle(com.example.consumer COPY_TO bundle-container)
poco_install_bundle(TARGETS com.example.consumer 
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include
)