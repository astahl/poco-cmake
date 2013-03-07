project(BundleContainerApplication)

add_executable(bundle-container src/BundleContainerApplication.cpp)

find_package(Poco REQUIRED Foundation Util OSP)

include_directories(${Poco_INCLUDE_DIRS})
target_link_libraries(bundle-container ${Poco_LIBRARIES})

if(WIN32)
	foreach(dll PocoFoundation PocoUtil PocoOSP PocoXML PocoZip)
		find_path(dll_dir
			NAMES ${dll}.dll ${dll}d.dll
			HINTS ${Poco_RUNTIME_LIBRARY_DIRS}
		)
		add_custom_command(TARGET bundle-container POST_BUILD
			COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${dll_dir}/${dll}$<$<CONFIG:Debug>:d>.dll $<TARGET_FILE_DIR:bundle-container>
			COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different $<$<CONFIG:Debug>:${dll_dir}/${dll}d.pdb> $<TARGET_FILE_DIR:bundle-container>
		)
	endforeach()
endif()

install(TARGETS bundle-container RUNTIME DESTINATION bin)