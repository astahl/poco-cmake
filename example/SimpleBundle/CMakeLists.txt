project(SimpleBundle)

include(PocoBundles)

poco_add_single_library_bundle(SimpleLibrary com.example.simple 
	VERSION 1.0.0 ACTIVATOR_CLASS SimpleBundleActivator FOLDER Simple
	src/SimpleBundleActivator.h src/SimpleBundleActivator.cpp)

find_package(Poco REQUIRED Foundation Util OSP)
set_source_files_properties(src/SimpleBundleActivator.h PROPERTIES POCO_BUNDLE_PUBLIC_HEADER_LOCATION "simple")

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(SimpleLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.simple COPY_TO bundle-container)
poco_install_bundle(TARGETS com.example.simple 
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include
)