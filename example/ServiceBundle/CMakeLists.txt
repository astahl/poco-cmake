project(ServiceBundle)

include(PocoBundles)
include(GenerateExportHeader)

# WARNING
# this next line is not supported for gcc, it sets the -fvisibility to hidden, 
# effectively hiding the pocoBuildManifest function (it is not declared 
# visibility("default") in ClassLibrary.h, maybe file a bug with Appinf?)
#add_compiler_export_flags()

set(PRIVATE_HEADER src/ServiceBundleActivator.h)
set(EXPORT_HEADER ${PROJECT_BINARY_DIR}/servicelibrary_export.h)
set(PUBLIC_HEADER src/AdditionService.h ${EXPORT_HEADER})
set(SOURCES 
	src/ServiceBundleActivator.cpp 
	src/AdditionService.cpp 
	${PUBLIC_HEADER}
	${PRIVATE_HEADER}
)

poco_add_single_library_bundle(ServiceLibrary com.example.service
	VERSION 1.0.0 ACTIVATOR_CLASS ServiceBundleActivator FOLDER Service
	LIBRARY_SOURCES ${SOURCES}
)

set_target_properties(com.example.service PROPERTIES POCO_BUNDLE_RUN_LEVEL 100)

set_source_files_properties(${PUBLIC_HEADER} PROPERTIES 
	POCO_BUNDLE_PUBLIC_HEADER_LOCATION "example/service"
)
set_source_files_properties(${EXPORT_HEADER} PROPERTIES 
	GENERATED true
)
generate_export_header(ServiceLibrary)

find_package(Poco REQUIRED Foundation Util OSP)
include_directories(${Poco_INCLUDE_DIRS} ${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/src/)
target_link_libraries(ServiceLibrary ${Poco_LIBRARIES})

poco_finalize_bundle(com.example.service COPY_TO bundle-container)
poco_export_bundle(TARGETS com.example.service FILE service-bundle.cmake)
poco_install_bundle(TARGETS com.example.service EXPORT example-exports
	BUNDLE DESTINATION bin/bundles 
	LIBRARY DESTINATION lib
	RUNTIME DESTINATION lib
	DEBUG_SYMBOLS DESTINATION lib
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include
)