project(ServiceBundle)

include(PocoBundles)
include(GenerateExportHeader)

add_compiler_export_flags()

poco_add_single_library_bundle(ServiceLibrary com.example.service
	VERSION 1.0.0 ACTIVATOR_CLASS ServiceBundleActivator FOLDER Service
	src/ServiceBundleActivator.h src/ServiceBundleActivator.cpp src/AdditionService.h src/AdditionService.cpp)

generate_export_header(ServiceLibrary)

set_source_files_properties(src/AdditionService.h PROPERTIES POCO_BUNDLE_PUBLIC_HEADER_LOCATION "example/service")

find_package(Poco REQUIRED Foundation Util OSP)
include_directories(${Poco_INCLUDE_DIRS} ${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/src/)
target_link_libraries(ServiceLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.service COPY_TO bundle-container)
poco_install_bundle(TARGETS com.example.service EXPORT example-exports
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION lib
	DEBUG_SYMBOLS DESTINATION lib
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include
)
install(FILES ${PROJECT_BINARY_DIR}/ServiceLibrary_export.h DESTINATION include/example/service)