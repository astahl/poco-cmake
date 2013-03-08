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

# this is kind of a hack, create a dummy pdb even if not in debug mode, so that copy doesn't fail, but delete it afterwards.
		add_custom_command(TARGET bundle-container POST_BUILD
			COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${dll_dir}/${dll}$<$<CONFIG:Debug>:d>.dll $<TARGET_FILE_DIR:bundle-container>
			COMMAND ${CMAKE_COMMAND} ARGS -E touch ${dll_dir}/${dll}.pdb
			COMMAND ${CMAKE_COMMAND} ARGS -E copy_if_different ${dll_dir}/${dll}$<$<CONFIG:Debug>:d>.pdb $<TARGET_FILE_DIR:bundle-container>
			COMMAND ${CMAKE_COMMAND} ARGS -E remove ${dll_dir}/${dll}.pdb 
			COMMAND ${CMAKE_COMMAND} ARGS -E remove $<TARGET_FILE_DIR:bundle-container>/${dll}.pdb
		)
	endforeach()
endif()
if(UNIX)
	if(NOT APPLE)
		set_target_properties(bundle-container PROPERTIES
			INSTALL_RPATH "\$ORIGIN;\$ORIGIN/../lib;\$ORIGIN/codeCache"
		)
	endif()
endif()
install(TARGETS bundle-container RUNTIME DESTINATION bin)

install(CODE "
	if(APPLE)
		function(gp_item_default_embedded_path_override item default_embedded_path_var)
			set(\${default_embedded_path_var} \"@executable_path\" PARENT_SCOPE)
		endfunction()
	endif()
	include(BundleUtilities)
	find_program(exe NAMES bundle-container bundle-containerd HINTS ${CMAKE_INSTALL_PREFIX}/bin )
	fixup_bundle(\"\${exe}\" \"\" \"${Poco_RUNTIME_LIBRARY_DIRS};/usr/local/lib\")
	if(APPLE)
		execute_process(COMMAND install_name_tool -add_rpath @loader_path/codeCache \${exe})
		execute_process(COMMAND install_name_tool -add_rpath @loader_path \${exe})
		execute_process(COMMAND install_name_tool -add_rpath @loader_path/../lib \${exe})
	endif()
")