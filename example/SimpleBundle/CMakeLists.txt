project(SimpleBundle)

include(PocoBundles)

poco_add_single_library_bundle(SimpleLibrary com.example.simple 
	VERSION 1.0.0 
	ACTIVATOR_CLASS SimpleBundleActivator 
	FOLDER Simple 
	BUNDLE_FILES bundle/payload.txt
	LIBRARY_SOURCES src/SimpleBundleActivator.h src/SimpleBundleActivator.cpp)

set_source_files_properties(bundle/payload.txt PROPERTIES POCO_BUNDLE_LOCATION ".")

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(SimpleLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.simple COPY_TO bundle-container)
poco_install_bundle(TARGETS com.example.simple EXPORT example-exports
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION lib
	ARCHIVE DESTINATION lib
)