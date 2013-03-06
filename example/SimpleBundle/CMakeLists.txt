project(SimpleBundle)

include(PocoBundles)

poco_add_single_library_bundle(SimpleLibrary com.example.simple 
	VERSION 1.0.0 ACTIVATOR_CLASS SimpleBundleActivator
	src/SimpleBundleActivator.h src/SimpleBundleActivator.cpp)

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(SimpleLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.simple)