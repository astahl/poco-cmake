cmake_minimum_required (VERSION 2.8.10.2)
if(PocoBundles_INCLUDED)
	#message(AUTHOR_WARNING "PocoBundles.cmake already included, retuning.")
	return()
else()
	#message(AUTHOR_WARNING "Including PocoBundles.cmake.")
	set(PocoBundles_INCLUDED true)
endif()

include(CMakeParseArguments)
#  PocoBundles.cmake 
# The functions in this file enable the seamless integration of POCO Bundles in a cmake based build context.
# The following properties are defined, which are similar to the BUNDLE_* Properties provided by cmake for OS X (CFBundle) bundles.

# -- target properties
# 

define_property(TARGET PROPERTY POCO_BUNDLE 
	BRIEF_DOCS "Read-only indication of whether a target is a POCO OSP bundle." 
	FULL_DOCS "A Boolean property that indicates that a target will be created as a POCO bundle. Defaults to true for targets created with poco_add_bundle().")
define_property(TARGET PROPERTY POCO_BUNDLE_ROOT 
	BRIEF_DOCS "Path to POCO Bundle root directory."
	FULL_DOCS "A directory path that will be the root and working directory during the bundle wrapping process. If this is changed, remember to also reset the LIBRARY_OUTPUT_DIRECTORY and RUNTIME_OUTPUT_DIRECTORY properties, as they should be in the lib or bin directory below bundle root, respectively. This property is initialized by the value of the variable POCO_BUNDLE_ROOT if it is set when a target is created, else defaults to \\\${PROJECT_BINARY_DIR}/\\\${target}_bundle_root when a POCO bundle library target is added.")
define_property(TARGET PROPERTY POCO_BUNDLE_OUTPUT_DIRECTORY
	BRIEF_DOCS "The directory in which the wrapped bundle is placed after creation."
	FULL_DOCS "This directory path indicates, where the bundle creator executable will put the finalized bundle. This property is initialized by the value of the variable POCO_BUNDLE_OUTPUT_DIRECTORY if it is set when a target is created. Else defaults to \\\${PROJECT_BINARY_DIR}/bundles when a POCO bundle library target is added.")
define_property(TARGET PROPERTY POCO_BUNDLE_NAME 
	BRIEF_DOCS "The user readable name of the bundle (not the file name)."
	FULL_DOCS "The full, user readable name of the bundle, which is not equal to the file name. To change the filename, set symbolic name and version properties of the bundle. This property is initialized by the value of the variable POCO_BUNDLE_NAME if it is set when a target is created. Defaults to \\\${target} Bundle when a POCO bundle library target is added.")
define_property(TARGET PROPERTY	POCO_BUNDLE_SYMBOLIC_NAME
	BRIEF_DOCS "The symbolic name of the bundle (first part of the file name)."
	FULL_DOCS "The symbolic name of the bundle, which is equal to the first part of the file name (separated by underscore from the version string). This property is initialized by the value of the variable POCO_BUNDLE_SYMBOLIC_NAME or PROJECT_ID as a fallback if it is set when a target is created. Defaults to \\\${target} when a POCO bundle library target is added.")
define_property(TARGET PROPERTY	POCO_BUNDLE_VERSION 
	BRIEF_DOCS "The version of the bundle (second part of the file name)."
	FULL_DOCS "The version string of the bundle, which is equal to the second part of the file name (separated by underscore). It is of the form MAJOR.MINOR.PATCH. This property is initialized by the value of the variable POCO_BUNDLE_VERSION if it is set when a target is created. Defaults to 0.0.1 when a POCO bundle library target is added.")
define_property(TARGET PROPERTY	POCO_BUNDLE_SPEC
	BRIEF_DOCS "Specify a custom .bndlspec template for a POCO Bundle."
	FULL_DOCS "By default, a poco bundles .bndlspec file is created by configuring a template called PocoBundleSpec.bndlspec.in located in the CMakeModules directory. This property specifies an alternative template file name which may be a full path. The following target properties may be set to specify content to be configured into the file. TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_VENDOR
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_COPYRIGHT
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_ACTIVATOR_LIBRARY
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_ACTIVATOR_CLASS
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_LAZY_START
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_RUN_LEVEL
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")

define_property(TARGET PROPERTY	POCO_BUNDLE_LIBRARIES
	BRIEF_DOCS "TODO"
	FULL_DOCS "TODO")
# -- source file properties
#
define_property(SOURCE PROPERTY POCO_BUNDLE_LOCATION
	BRIEF_DOCS "Place a source file inside a POCO Bundle"
	FULL_DOCS "Files that have this property set will be copied to the bundle tree during creation. It specifies the path relative to the bundle root where this file will be placed during finalization. Setting this property to location '.' will copy it to the bundle root (e.g. extensions.xml files).")

define_property(SOURCE PROPERTY POCO_BUNDLE_PUBLIC_HEADER_LOCATION
	BRIEF_DOCS "Mark a source file as a public header to a POCO Bundle"
	FULL_DOCS "Files that have this property set may be installed alongside the bundle. It specifies the path relative to the PUBLIC_HEADER install destination where this file will be placed during install. Setting this property to location '.' will install it to the PUBLIC_HEADER destination directory.")

set(POCO_BUNDLE_PROPERTIES
	POCO_BUNDLE
	POCO_BUNDLE_ROOT
	POCO_BUNDLE_NAME
	POCO_BUNDLE_SYMBOLIC_NAME
	POCO_BUNDLE_VERSION
	POCO_BUNDLE_SPEC
	POCO_BUNDLE_VENDOR
	POCO_BUNDLE_COPYRIGHT
	POCO_BUNDLE_ACTIVATOR_CLASS 
	POCO_BUNDLE_ACTIVATOR_LIBRARY 
	POCO_BUNDLE_LAZY_START
	POCO_BUNDLE_RUN_LEVEL
	POCO_BUNDLE_DEPENDENCY 
	POCO_BUNDLE_EXTENDS
	POCO_BUNDLE_CODE
	POCO_BUNDLE_FILES
	POCO_BUNDLE_LIBRARIES
	POCO_BUNDLE_IMPORTED
	POCO_BUNDLE_IMPORTED_LOCATION
	POCO_BUNDLE_OUTPUT_DIRECTORY
	POCO_BUNDLE_OUTPUT_NAME
)
foreach(Config ${CMAKE_CONFIGURATION_TYPES})
	string(TOUPPER ${Config} CONFIG)
	list(APPEND POCO_BUNDLE_PROPERTIES POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG})
	list(APPEND POCO_BUNDLE_PROPERTIES POCO_BUNDLE_OUTPUT_NAME_${CONFIG})
	list(APPEND POCO_BUNDLE_PROPERTIES POCO_BUNDLE_LIBRARIES_${CONFIG})
endforeach()


macro(POCO_IS_BUNDLE var target)
	if(TARGET ${target})
		get_property(is_bundle TARGET ${target} PROPERTY POCO_BUNDLE SET)
		set(${var} ${is_bundle} PARENT_SCOPE)
	else()
		set(${var} false PARENT_SCOPE)
	endif()
endmacro()

macro(POCO_ASSERT_BUNDLE)
	foreach(arg ${ARGN})
		poco_is_bundle(is_bundle ${arg})
		if(NOT is_bundle)
			message(FATAL_ERROR "Assertion failed: ${arg} is not a valid bundle target.")
		endif()
	endforeach()
endmacro()

# sets a variable to a value depending on the evaluation of an if expression
# similar to the tertiary assignment operator var = bool ? a : b
macro(IF_THEN_SET expression var_result val_true val_false)
	if(${expression})
		set(${var_result} "${val_true}")
	else()
		set(${var_result} "${val_false}")
	endif()
endmacro()

macro(POCO_PARSE_BUNDLE_PROPERTIES target var)
	unset(${var})
    POCO_ASSERT_BUNDLE(${target})
    foreach(prop ${POCO_BUNDLE_PROPERTIES})
    	get_property(is_set TARGET ${target} PROPERTY ${prop} SET)
    	if(is_set)
	    	get_property(${target}_${prop} TARGET ${target} PROPERTY ${prop})
    		set(${target}_${prop} ${${target}_${prop}} PARENT_SCOPE)
    		list(APPEND ${var} "${prop} \"${${target}_${prop}}\"")
    	endif()
    endforeach()
endmacro()

macro(write_config_lines target)
	get_target_property(config_file ${target} _CONFIG_FILE)
	foreach(line ${ARGN})
		file(APPEND ${config_file} "${line}\n")
	endforeach()
endmacro()

macro(POCO_OUTPUT_DIR_GENERATOR_EXPRESSION target var)
	# we need to extract the different build configuration dependent 
	# destinations. This is easiest done by generator expression magic.
	# what it does is check if each defined configuration is the 
	# current one during build ($<CONFIG:${Config}>) and on that condition 
	# selects the respective target property.
	foreach(Config ${CMAKE_CONFIGURATION_TYPES})
		string(TOUPPER ${Config} CONFIG)
		set(DIR_GENERATOR "${DIR_GENERATOR}$<$<CONFIG:${Config}>:$<TARGET_PROPERTY:${target},POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG}>>")
	endforeach()
	if(NOT DIR_GENERATOR)
		set(DIR_GENERATOR "$<TARGET_PROPERTY:${target},POCO_BUNDLE_OUTPUT_DIRECTORY>")
	endif()
	set(${var} ${DIR_GENERATOR})
endmacro()

macro(POCO_OUTPUT_NAME_GENERATOR_EXPRESSION target var)
	set(${var} "$<TARGET_PROPERTY:${target},POCO_BUNDLE_SYMBOLIC_NAME>_$<TARGET_PROPERTY:${target},POCO_BUNDLE_VERSION>.bndl")
endmacro()

#  poco_get_bundle_file_name
# composes a bundle's bundle-creator output filename
# usage: 	poco_get_bundle_file_name(<var> TARGET <poco_target>) 
#			poco_get_bundle_file_name(<var> SYMBOLIC_NAME <name> VERSION <version>)
# 
macro(poco_get_bundle_file_name target var_name)
	POCO_ASSERT_BUNDLE(${target})
    get_target_property(name ${target} POCO_BUNDLE_SYMBOLIC_NAME)
	get_target_property(version ${target} POCO_BUNDLE_VERSION)
	set(${var_name} "${name}_${version}.bndl")
endmacro(poco_get_bundle_file_name)

function(POCO_INVOKE_BUNDLE_CREATOR)
	set(options NO_OSARCH NO_OSNAME KEEP_BUNDLE_DIR)
	set(oneValueArgs TARGET SPEC OUTPUT_DIR WORKING_DIRECTORY OSARCH OSNAME EXECUTABLE)
	set(multiValueArgs DEPENDS)
	cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	# find the bundle utility executable
	if(args_EXECUTABLE)
		set(Poco_OSP_Bundle_EXECUTABLE ${args_EXECUTABLE})
	endif()
	if(NOT Poco_OSP_Bundle_EXECUTABLE)
		find_package(Poco REQUIRED OSP)
	endif()
	if(NOT Poco_OSP_Bundle_EXECUTABLE)
		message(FATAL_ERROR "POCO Bundle creation utility could not be found.")
	endif()
	if(NOT args_SPEC)
		message(FATAL_ERROR "No bundle spec defined.")
	endif()
	if(NOT args_OUTPUT_DIR)
		message(FATAL_ERROR "Output directory not found.")
	endif()
	if(NOT args_OSARCH AND NOT args_NO_OSARCH)
		set(OSARCH "${CMAKE_SYSTEM_PROCESSOR}")
		message("WARNING: OSARCH ${OSARCH} is probably invalid for Poco Bundles.")
	endif()
	if(NOT args_OSNAME AND NOT args_NO_OSNAME)
		set(OSNAME "${CMAKE_SYSTEM_NAME}")
		message("WARNING: OSNAME ${OSNAME} is probably invalid for Poco Bundles.")
	endif()
	if(UNIX)
		set(opt --)
	elseif(WIN32)
		set(opt /)
	endif()
	list(APPEND BUNDLE_ARGS	"${opt}output-dir=${args_OUTPUT_DIR}")
	if(NOT args_NO_OSARCH)
		list(APPEND BUNDLE_ARGS ${opt}osarch="${OSARCH}")
	endif()
	if(NOT args_NO_OSNAME)
		list(APPEND BUNDLE_ARGS ${opt}osname="${OSNAME}")
	endif()
	if(args_KEEP_BUNDLE_DIR)
		list(APPEND BUNDLE_ARGS ${opt}keep-bundle-dir)
	endif()
	list(APPEND BUNDLE_ARGS "${args_SPEC}")
	if(args_TARGET)
		add_custom_command(TARGET ${args_TARGET} 
			POST_BUILD
			COMMAND "${Poco_OSP_Bundle_EXECUTABLE}"
			ARGS ${BUNDLE_ARGS}
			DEPENDS ${args_SPEC} ${args_DEPENDS}
			WORKING_DIRECTORY ${args_WORKING_DIRECTORY}
			COMMENT "${args_TARGET}: Creating Bundle, command: ${Poco_OSP_Bundle_EXECUTABLE} args: ${BUNDLE_ARGS}"
		)
	else()
		execute_process(COMMAND "${Poco_OSP_Bundle_EXECUTABLE}" ${BUNDLE_ARGS}
			WORKING_DIRECTORY ${args_WORKING_DIRECTORY}
			COMMENT "${args_TARGET}: Creating Bundle, command: ${Poco_OSP_Bundle_EXECUTABLE} args: ${BUNDLE_ARGS}"
		)
	endif()
endfunction()


# - installs a bundle and included libraries
# 
# poco_install_bundle(TARGETS targets... [EXPORT <export-name>]
#          [[ARCHIVE|LIBRARY|RUNTIME|BUNDLE|PUBLIC_HEADER|DEBUG_SYMBOLS]
#           [DESTINATION <dir>]
#           [CONFIGURATIONS [Debug|Release|...]]
#           [OPTIONAL]
#          ] [...])
#
#
function(POCO_INSTALL_BUNDLE)
	set(options)
    set(oneValueArgs EXPORT)
    set(multiValueArgs TARGETS BUNDLE LIBRARY ARCHIVE RUNTIME PUBLIC_HEADER DEBUG_SYMBOLS)
    set(subOptions OPTIONAL)
    set(subOneValueArgs DESTINATION)
    set(subMultiValueArgs CONFIGURATIONS)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    cmake_parse_arguments(bundle "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_BUNDLE})
    cmake_parse_arguments(library "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_LIBRARY})
    cmake_parse_arguments(archive "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_ARCHIVE})
    cmake_parse_arguments(runtime "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_RUNTIME})
    cmake_parse_arguments(public_header "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_PUBLIC_HEADER})
    cmake_parse_arguments(debug_symbols "${subOptions}" "${subOneValueArgs}" "${subMultiValueArgs}" ${args_DEBUG_SYMBOLS})
    foreach(target ${args_TARGETS})
		POCO_ASSERT_BUNDLE(${target})
		poco_get_bundle_file_name(${target} bundle_file_name)
		foreach(Config ${CMAKE_CONFIGURATION_TYPES})
			set(MULTI_CONFIG true)
			string(TOUPPER ${Config} CONFIG)
			get_target_property(POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG} ${target} POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG})
			install(FILES "${POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG}}/${bundle_file_name}" DESTINATION ${bundle_DESTINATION} CONFIGURATIONS ${Config})
		endforeach()
		if(NOT MULTI_CONFIG)
			get_target_property(POCO_BUNDLE_OUTPUT_DIRECTORY ${target} POCO_BUNDLE_OUTPUT_DIRECTORY)
			install(FILES "${POCO_BUNDLE_OUTPUT_DIRECTORY}/${bundle_file_name}" DESTINATION ${bundle_DESTINATION})
		endif()

    	get_target_property(LIBRARIES ${target} POCO_BUNDLE_LIBRARIES)
		foreach(lib ${LIBRARIES})
			get_target_property(imported ${lib} IMPORTED)
			if(imported)
				get_target_property(imported_location ${lib} IMPORTED_LOCATION)
				get_target_property(imported_location_debug ${lib} IMPORTED_LOCATION_DEBUG)
				if(WIN32)
					get_target_property(imported_implib ${lib} IMPORTED_IMPLIB)
					get_target_property(imported_implib_debug ${lib} IMPORTED_IMPLIB_DEBUG)
					if(imported_location AND args_RUNTIME)
						install(FILES "${imported_location}" DESTINATION ${runtime_DESTINATION})
					endif()
					if(imported_implib AND args_ARCHIVE)
						install(FILES "${imported_implib}" DESTINATION ${archive_DESTINATION})
					endif()
				else()
					if(imported_location AND args_LIBRARY)
						install(FILES "${imported_location}" DESTINATION ${library_DESTINATION})
					endif()
				endif()
			else()
				set(install_args TARGETS ${lib} )
				if(args_EXPORT)
					list(APPEND install_args EXPORT ${args_EXPORT})
				endif()
				if(args_LIBRARY)
					list(APPEND install_args LIBRARY DESTINATION ${library_DESTINATION} CONFIGURATIONS ${library_CONFIGURATIONS})
				endif()
				if(args_ARCHIVE)
		    		list(APPEND install_args ARCHIVE DESTINATION ${archive_DESTINATION} CONFIGURATIONS ${archive_CONFIGURATIONS})
				endif()
				if(args_RUNTIME)
		    		list(APPEND install_args RUNTIME DESTINATION ${runtime_DESTINATION} CONFIGURATIONS ${runtime_CONFIGURATIONS})
				endif()
				install(${install_args})
				# public headers
				get_target_property(FILES ${lib} SOURCES)
				foreach(file ${FILES})
					get_source_file_property(public_header_location ${file} POCO_BUNDLE_PUBLIC_HEADER_LOCATION)
					if(public_header_location)
						install(FILES ${file} DESTINATION ${public_header_DESTINATION}/${public_header_location} CONFIGURATIONS ${public_header_CONFIGURATIONS})
					endif()
				endforeach()
				# debug files -- ignores configurations argument
				if(WIN32 AND args_DEBUG_SYMBOLS)
					get_target_property(debug_dll_location ${lib} LOCATION_Debug)
					string(REPLACE ".dll" ".pdb" pdb_location ${debug_dll_location})
					install(FILES ${pdb_location} DESTINATION ${debug_symbols_DESTINATION} CONFIGURATIONS Debug DEBUG OPTIONAL)
				endif()
			endif()
		endforeach()

		get_target_property(FILES ${target} POCO_BUNDLE_FILES)
		foreach(file ${FILES})
			get_source_file_property(public_header_location ${file} POCO_BUNDLE_PUBLIC_HEADER_LOCATION)
			if(public_header_location)
				install(FILES ${file} DESTINATION ${public_header_DESTINATION}/${public_header_location} CONFIGURATIONS ${public_header_CONFIGURATIONS})
			endif()
		endforeach()
	endforeach()
endfunction()

# - adds a dependency relation between the bundle target and the dependecy.
#
#  add_poco_bundle_dependency(<bundle> <dependency> [VERSION <ver> | 
#   MIN_VERSION <min_ver> MAX_VERSION <max_ver> [MIN_EXCLUSIVE] [MAX_EXCLUSIVE]]
#   [NO_CHECK])
# 
# This command adds a dependency declaration to another bundle in the bundles 
# manifest. <dependency> must be a valid bundle target or a symbolic name.
# If dependency is a valid bundle target, it can be used to extract and validate 
# the version information against the requested version. If that behaviour is 
# not desired, use the NO_CHECK flag. The target will also be used to establish 
# a build-level dependency between the bundles.
# If dependency is a symbolic name, no checks are performed for version or if 
# the bundle actually exists, also the build-level dependency can not be 
# established. Always consider using an imported poco bundle target instead.
function(POCO_ADD_BUNDLE_DEPENDENCY target dependency)
	set(options MIN_EXCLUSIVE MAX_EXCLUSIVE NO_CHECK)
    set(oneValueArgs VERSION MIN_VERSION MAX_VERSION)
    set(multiValueArgs)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    # build the version string
    POCO_ASSERT_BUNDLE(${target})
    if(args_MIN_VERSION OR args_MAX_VERSION AND NOT (args_MIN_VERSION AND args_MAX_VERSION) OR args_MIN_VERSION VERSION_GREATER args_MAX_VERSION)
    	message(FATAL_ERROR "Invalid min/max-version arguments to bundle dependency.")
    endif()
    if(args_VERSION)
    	set(version_string ${args_VERSION})
    elseif(args_MIN_VERSION VERSION_LESS args_MAX_VERSION)
    	IF_THEN_SET(${args_MIN_EXCLUSIVE} min_paren "(" "[")
    	IF_THEN_SET(${args_MAX_EXCLUSIVE} max_paren ")" "]")
    	set(version_string "${min_paren}${args_MIN_VERSION}, ${args_MAX_VERSION}${max_paren}")
    endif()
    if(NOT version_string AND TARGET ${dependency}) 
    	POCO_ASSERT_BUNDLE(${dependency})
    	get_target_property(other_version ${dependency} POCO_BUNDLE_VERSION)
    	if(NOT args_NO_CHECK)
    		if(args_VERSION AND (NOT args_VERSION VERSION_EQUAL other_version))
    			set(fail "VERSION NOT EQUAL")
    		else()
    			if(args_MIN_VERSION AND args_MAX_VERSION)
					if(NOT other_version VERSION_GREATER args_MIN_VERSION)
						if(args_MIN_EXCLUSIVE)
							set(fail "VERSION NOT GREATER THAN EXCLUSIVE MIN")
						elseif(NOT other_version VERSION_EQUAL args_MIN_VERSION)
							set(fail "VERSION NOT GREATER OR EQUAL TO INCLUSIVE MIN")
						endif()
					elseif(NOT other_version VERSION_LESS args_MAX_VERSION)
						if(args_MAX_EXCLUSIVE)
							set(fail "VERSION NOT LESS THAN EXCLUSIVE MAX")
						elseif(NOT other_version VERSION_EQUAL args_MAX_VERSION)
							set(fail "VERSION NOT LESS OR EQUAL TO INCLUSIVE MAX")
						endif()
					endif()
				endif()
			endif()
    		if(fail)
    			message(FATAL_ERROR "Error establishing bundle dependency between ${target} and ${dependency}, version mismatch. Requested: ${version_string}, found: ${other_version}. ${fail}")
    		endif()
    	endif()
    	set_property(TARGET ${target} APPEND PROPERTY _POCO_BUNDLE_TARGET_DEPENDENCIES ${dependency})
    	set_property(TARGET ${target} PROPERTY _POCO_BUNDLE_DEPENDENCY_${dependency}_VERSION ${other_version})
    	get_target_property(symbolic ${dependency} POCO_BUNDLE_SYMBOLIC_NAME)
    	set_property(TARGET ${target} APPEND_STRING PROPERTY POCO_BUNDLE_DEPENDENCY "${symbolic}@${other_version},")
   		add_dependencies(${target} ${dependency})
    else()
    	set_property(TARGET ${target} APPEND_STRING PROPERTY POCO_BUNDLE_DEPENDENCY "${dependency}@${version_string},")
    endif()
endfunction()

function(POCO_TARGET_LINK_BUNDLE_LIBRARIES target)
	foreach(bundle ${ARGN})
		poco_assert_bundle(${bundle})
		get_target_property(LIBRARIES ${bundle} POCO_BUNDLE_LIBRARIES)
		if(LIBRARIES)
	    	target_link_libraries(${target} ${LIBRARIES})
	    else()
	    	message("${bundle} has no libraries to link against.")
	    endif()
	endforeach()
endfunction()

function(EXPORT_POCO_BUNDLE)
 	set(multiValueArgs TARGETS)
    set(oneValueArgs FILE)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if(IS_ABSOLUTE ${args_FILE})
    	set(file ${args_FILE})
    else()
    	set(file ${CMAKE_CURRENT_BINARY_DIR}/${args_FILE})
    endif()
    file(WRITE ${file} "# Bundle export file for Targets ${args_TARGETS}\n")
    # check if all targets are bundles and if all dependend bundle targets are part of the export

    foreach(target ${args_TARGETS})
    	POCO_ASSERT_BUNDLE(${target})	
    	get_target_property(_POCO_BUNDLE_TARGET_DEPENDENCIES ${target} _POCO_BUNDLE_TARGET_DEPENDENCIES)
    	if(_POCO_BUNDLE_TARGET_DEPENDENCIES)
    		foreach(dependency ${_POCO_BUNDLE_TARGET_DEPENDENCIES})
    			list(FIND args_TARGETS ${dependency} found_var)
    			if(found_var EQUAL -1)
    				message(WARNING "Dependent bundle ${dependency} of ${target} not in export list: ${args_TARGETS}.")
    			endif()
    		endforeach()
    	endif()
    endforeach()

    # declare targets
    foreach(target ${args_TARGETS})
   		file(APPEND ${file} "add_custom_target(${target})\n")
   	endforeach()

   	# set target properties
    foreach(target ${args_TARGETS})
   		file(APPEND ${file} "set_target_properties(${target} PROPERTIES\n")
    	poco_parse_bundle_properties(${target} properties)
    	foreach(property ${properties})
    		file(APPEND ${file} " ${property}\n")
    	endforeach()
    	file(APPEND ${file} ")\n")
    endforeach()
endfunction()

# -- 
# writes essential information to target config file to finish
#  up a poco bundle after target configuration
function(POCO_FINALIZE_BUNDLE target)
	set(options FORCE_RENAME_ACTIVATOR KEEP_BUNDLE_DIR)
	set(multiValueArgs TARGETS)
    set(oneValueArgs EXPORT_MAPPING COPY_TO)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    POCO_ASSERT_BUNDLE(${target})

	get_target_property(config_file ${target} _CONFIG_FILE)

	# write properties to config
	poco_parse_bundle_properties(${target} properties)
	foreach(property ${POCO_BUNDLE_PROPERTIES})
		get_target_property(prop ${target} ${property})
		if(prop)
    		file(APPEND ${config_file} "set(${property} \"${prop}\")\n")
    	endif()
    endforeach()

	# get properties needed for config
	get_target_property(BUNDLE_ROOT ${target} POCO_BUNDLE_ROOT)
	get_target_property(BUNDLE_SYMBOLIC_NAME ${target} POCO_BUNDLE_SYMBOLIC_NAME)

	# copy additional resources to bundle target
	get_target_property(SOURCES ${target} SOURCES)
	list(LENGTH SOURCES length)
	if(${length} GREATER 1)
		write_config_lines(${target} " "
			"# copy additional files"
			"message(STATUS \"Bundle-Config ${target}: copy additional files\")"
		)
		foreach(SOURCE_FILE ${SOURCES})
			get_source_file_property(SOURCE_BUNDLE_LOCATION ${SOURCE_FILE} POCO_BUNDLE_LOCATION)
			set(DESTINATION ${BUNDLE_ROOT}/${SOURCE_BUNDLE_LOCATION})
			if(SOURCE_BUNDLE_LOCATION)
				# the source file was assigned to be copied to a certain destination
				write_config_lines(${target} "
#${SOURCE_FILE}
file(INSTALL \"${SOURCE_FILE}\" DESTINATION \"${DESTINATION}\")
get_filename_component(FILENAME \"${SOURCE_FILE}\" NAME)
file(RELATIVE_PATH RELATIVE_PATH \"${BUNDLE_ROOT}\" \"${DESTINATION}/\\\${FILENAME}\")
list(APPEND POCO_BUNDLE_FILES \"\\\${RELATIVE_PATH}\")
				")
			endif()
		endforeach()
	endif()

    # copy libraries to bundle tree
    get_target_property(LIBRARIES ${target} POCO_BUNDLE_LIBRARIES)
    set(DESTINATION ${BUNDLE_ROOT}/lib)
    foreach(lib ${LIBRARIES})
	    write_config_lines(${target} 
"
message(STATUS \"Bundle-Config ${target}: Adding ${lib} from: \\\${${lib}_LOCATION}\")
get_filename_component(${lib}_LOCATION \"\\\${${lib}_LOCATION}\" REALPATH)
get_filename_component(${lib}_FILENAME \"\\\${${lib}_LOCATION}\" NAME)
get_filename_component(${lib}_PATH \"\\\${${lib}_LOCATION}\" PATH)
file(INSTALL \"\\\${${lib}_LOCATION}\" DESTINATION \"${DESTINATION}\")
"
		)
		# handle debug symbols in WIN32
		if(WIN32)
		write_config_lines(${target} 
"
string(REGEX REPLACE .dll .pdb ${lib}_PDB_FILENAME \"\\\${${lib}_FILENAME}\")
find_file(${lib}_pdb_file NAMES \"\\\${${lib}_PDB_FILENAME}\" HINTS \"\\\${${lib}_PATH}\")
message(STATUS \"\\\${${lib}_PDB_FILENAME}: \\\${${lib}_pdb_file}\")
if(${lib}_pdb_file)
	message(STATUS \"\\\${${lib}_pdb_file}\")
	file(INSTALL \"\\\${${lib}_pdb_file}\" DESTINATION \"${DESTINATION}\")
	file(RELATIVE_PATH ${LIB}_PDB_RELATIVE_PATH \"${BUNDLE_ROOT}\" \"${DESTINATION}/\\\${${lib}_PDB_FILENAME}\")
	list(APPEND POCO_BUNDLE_CODE \"\\\${${LIB}_PDB_RELATIVE_PATH}\")
endif()
"
		)	
		endif()
		# handle lib = activator, first rename then setting 
		get_target_property(ACTIVATOR_LIBRARY ${target} POCO_BUNDLE_ACTIVATOR_LIBRARY)
		get_target_property(LIBRARY_OUTPUT_NAME ${lib} LIBRARY_OUTPUT_NAME)
		if(${ACTIVATOR_LIBRARY} STREQUAL ${lib})
			if(WIN32 AND ${args_FORCE_RENAME_ACTIVATOR})
		    	write_config_lines(${target} 
" 
# Handling activator with renaming. See FORCE_RENAME_ACTIVATOR option if not desired.
get_filename_component(${lib}_EXT \"\\\${${lib}_FILENAME}\" EXT)
message(STATUS \"Setting ${lib} as activator, renaming to ${BUNDLE_SYMBOLIC_NAME}(\\\${POSTFIX}\\\${${lib}_EXT})\")
file(RENAME \"${DESTINATION}/\\\${${lib}_FILENAME}\" \"${DESTINATION}/${BUNDLE_SYMBOLIC_NAME}\\\${POSTFIX}\\\${${lib}_EXT}\")
set(${lib}_FILENAME \"${BUNDLE_SYMBOLIC_NAME}\\\${POSTFIX}\\\${${lib}_EXT}\")
set(POCO_BUNDLE_ACTIVATOR_LIBRARY ${BUNDLE_SYMBOLIC_NAME})
"
	    		)
	    	else()
	    		write_config_lines(${target} 
" 
# Handling activator without renaming.
get_filename_component(${lib}_EXT \"\\\${${lib}_FILENAME}\" EXT)
string(REGEX REPLACE d*.dylib|d*.dll|d*.so \"\" ${lib}_FILENAME_WE_WP \"\\\${${lib}_FILENAME}\")
#string(REGEX REPLACE .dylib|.dll|.so \"\" ${lib}_FILENAME_WE_WP \"\\\${${lib}_FILENAME}\")
set(POCO_BUNDLE_ACTIVATOR_LIBRARY \"\\\${${lib}_FILENAME_WE_WP}\")
message(STATUS \"Setting ${lib} as activator, \\\${POCO_BUNDLE_ACTIVATOR_LIBRARY}\")
"
				)
	    	endif()
		endif()
		write_config_lines(${target} " 
file(RELATIVE_PATH ${LIB}_RELATIVE_PATH \"${BUNDLE_ROOT}\" \"${DESTINATION}/\\\${${lib}_FILENAME}\")
list(APPEND POCO_BUNDLE_CODE \"\\\${${LIB}_RELATIVE_PATH}\")
		")
	endforeach()

    # OS X: make the libraries portable by manipulating the install name
    if(APPLE)
    	find_program(INSTALL_NAME_TOOL NAME install_name_tool HINTS /usr/bin)
    	if(INSTALL_NAME_TOOL)
		    foreach(lib ${LIBRARIES})
				write_config_lines(${target} " "
		      		"message(STATUS \"Changing install names for \\\${${lib}_FILENAME}:\")"
			    	"execute_process(COMMAND \"${INSTALL_NAME_TOOL}\""
			    )
			    foreach(dependent_lib ${LIBRARIES})
			    	write_config_lines(${target} 
			      		"  -change \"\\\${${dependent_lib}_LOCATION}\" \"\\\${${dependent_lib}_FILENAME}\""
			     	)
			    endforeach()
		      	write_config_lines(${target} 
			      	"  -id \"\\\${${lib}_FILENAME}\""
			      	"  -add_rpath @rpath"
		      		"  \"${DESTINATION}/\\\${${lib}_FILENAME}\""
		      		")"
		      		"message(STATUS \" id:\\\${${lib}_FILENAME}\")"
				)
				foreach(dependent_lib ${LIBRARIES})
			    	write_config_lines(${target} 
			      		"message(STATUS \" \\\${${dependent_lib}_LOCATION} -> \\\${${dependent_lib}_FILENAME}\")"
			     	)
			    endforeach()
				if(args_EXPORT_MAPPING)
					write_config_lines(${target} " "
				      	"file(APPEND \"${CMAKE_CURRENT_BINARY_DIR}/${args_EXPORT_MAPPING}\" \"set(${lib} \"${DESTINATION}/\\\${${lib}_filename}\"\n\")"
					)
				endif()
			endforeach()
		else()
			message(FATAL_ERROR "install_name_tool not found")
		endif()
	endif()

	# see if a custom specification is defined
	if(NOT POCO_BUNDLE_SPEC)
		get_target_property(POCO_BUNDLE_SPEC ${target} POCO_BUNDLE_SPEC)
	endif()

	if(POCO_BUNDLE_SPEC)
		message(STATUS "Found custom Bundle template specification: ${POCO_BUNDLE_SPEC}")
		# configure the bundle specification configure file
		set(POCO_BUNDLE_SPEC_INPUT ${POCO_BUNDLE_SPEC})
	else()
		# there was no custom bundle specification defined, 
		# we need to configure the default file according to POCO_BUNDLE_XX target properties
		find_file(POCO_BUNDLE_SPEC_CONFIGURE_FILE "PocoBundleSpecConfigure.cmake" HINTS ${CMAKE_MODULE_PATH})
		find_file(POCO_BUNDLE_SPEC_INPUT "PocoBundleSpec.bndlspec.in" HINTS ${CMAKE_MODULE_PATH})
	endif()
	
	write_config_lines(${target} 
"
set(POCO_BUNDLE_SPEC_INPUT \"${POCO_BUNDLE_SPEC_INPUT}\")
include(\"${POCO_BUNDLE_SPEC_CONFIGURE_FILE}\")
"
	)
#	# configure output directory
#	write_config_lines(${target} "
#message(STATUS \"Bundle configuration: \\\${CONFIGURATION}\")
#if(NOT CONFIGURATION OR \"\\\${CONFIGURATION}\" STREQUAL \"Unspecified\")
#  set(output_dir \"\\\${POCO_BUNDLE_OUTPUT_DIRECTORY}\")
#else()
#  string(TOUPPER \"\\\${CONFIGURATION}\" CONFIG)
#  if(POCO_BUNDLE_OUTPUT_DIRECTORY_\\\${CONFIG})
#    set(output_dir \"\\\${POCO_BUNDLE_OUTPUT_DIRECTORY_\\\${CONFIG}}\")
#  else()
#    set(output_dir \"\\\${POCO_BUNDLE_OUTPUT_DIRECTORY}\")
#  endif()
#endif()
#if(NOT output_dir)
#  message(FATAL_ERROR \"No bundle output directory found for configuration \\\${CONFIGURATION}\")
#endif()
#	")

	# write bundle creator invocation to config file
	IF_THEN_SET(WIN32 opt "/" "--")
	if(args_KEEP_BUNDLE_DIR)
		set(bundle_args 
			"${opt}keep-bundle-dir"
		)
	endif()
#	write_config_lines(${target} 
#" 
#execute_process(COMMAND \"${Poco_OSP_Bundle_EXECUTABLE}\" ${opt}output-dir=\\\${output_dir}/ ${bundle_args} \"\\\${POCO_BUNDLE_SPEC_OUTPUT}\"WORKING_DIRECTORY \"${BUNDLE_ROOT}\")
#message(STATUS \"Bundle written to \\\${output_dir}\")
#"	
#	)

	poco_output_dir_generator_expression(${target} DIR_GENERATOR)
	add_custom_command(TARGET ${target} POST_BUILD
		COMMAND ${Poco_OSP_Bundle_EXECUTABLE} 
		ARGS ${opt}output-dir=${DIR_GENERATOR} 
		${bundle_args} 
		${CMAKE_CURRENT_BINARY_DIR}/${target}.dir/${target}.bndlspec
		WORKING_DIRECTORY ${BUNDLE_ROOT}
	)
	if(args_COPY_TO)
		#poco_output_dir_generator_expression(${target} DIR_GENERATOR)
		poco_output_name_generator_expression(${target} NAME_GENERATOR)
			
		if(TARGET ${args_COPY_TO})
			add_custom_command(TARGET ${target} POST_BUILD
				COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:${args_COPY_TO}>/bundles
				COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DIR_GENERATOR}/${NAME_GENERATOR} $<TARGET_FILE_DIR:${args_COPY_TO}>/bundles/
			)
		else()
			add_custom_command(TARGET ${target} POST_BUILD
				COMMAND ${CMAKE_COMMAND} -E make_directory ${args_COPY_TO}
				COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DIR_GENERATOR}/${NAME_GENERATOR} ${args_COPY_TO}/
			)
		endif()
	endif()
endfunction(POCO_FINALIZE_BUNDLE)


macro(POCO_MAKE_BUNDLE_TARGET target)
	set_target_properties(${target} PROPERTIES
		# Poco OSP related properties
		POCO_BUNDLE true
		POCO_BUNDLE_ROOT "${POCO_BUNDLE_ROOT}"
		POCO_BUNDLE_OUTPUT_DIRECTORY "${POCO_BUNDLE_OUTPUT_DIRECTORY}"
		POCO_BUNDLE_NAME "${POCO_BUNDLE_NAME}"
		POCO_BUNDLE_SYMBOLIC_NAME "${POCO_BUNDLE_SYMBOLIC_NAME}"
		POCO_BUNDLE_VERSION "${POCO_BUNDLE_VERSION}"
		POCO_BUNDLE_VENDOR "${POCO_BUNDLE_VENDOR}"
	)
	foreach(Config ${CMAKE_CONFIGURATION_TYPES})
		string(TOUPPER ${Config} CONFIG)
		set_target_properties(${target} PROPERTIES 
			POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG} "${POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG}}"
		)
	endforeach()
endmacro()

function(POCO_BUNDLE_ADD_LIBRARY target library)
	set_property(TARGET ${target} APPEND PROPERTY POCO_BUNDLE_LIBRARIES ${library})
	add_dependencies(${target} ${library})
endfunction()

function(POCO_BUNDLE_SET_ACTIVATOR target activator_library activator_class)
	set_target_properties(${target} PROPERTIES 
		POCO_BUNDLE_ACTIVATOR_LIBRARY ${activator_library}
		POCO_BUNDLE_ACTIVATOR_CLASS ${activator_class}
	)
endfunction()

# - Creates a new Poco OSP Bundle target
# poco_add_bundle(<name> SOURCES <source1 ...> ACTIVATOR_CLASS <class> [VERSION <ver>] [VENDOR <vendor>] )
# poco_add_bundle(<name> [ACTIVATOR_LIBRARY <lib> ACTIVATOR_CLASS <class> | NO_ACTIVATOR] [LIBRARIES <lib1 ...>]  [FILES <file1 ...>])
# poco_add_bundle(<name> IMPORTED <location>)
function(POCO_ADD_BUNDLE target)
	set(options IMPORTED NO_ACTIVATOR)
	set(multiValueArgs LIBRARIES FILES)
    set(oneValueArgs 
    	ACTIVATOR_LIBRARY ACTIVATOR_CLASS 
    	VERSION VENDOR SYMBOLIC_NAME NAME
    )
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
	set(POCO_BUNDLE_SPEC_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.dir/${target}.bndlspec)
    set(config_file ${CMAKE_CURRENT_BINARY_DIR}/${target}.dir/bundle_configure.cmake)

    if(EXISTS "${config_file}")
		file(REMOVE ${config_file})
	endif()

    # perform function arguments sanity checks
	if(args_LIBRARIES AND NOT args_ACTIVATOR_LIBRARY AND NOT args_NO_ACTIVATOR)	
		message(FATAL_ERROR "Cannot create library bundle ${target} without designated activator library. Use NO_ACTIVATOR flag to override.")
	endif()
	if((NOT args_ACTIVATOR_LIBRARY OR NOT args_ACTIVATOR_CLASS) AND NOT args_NO_ACTIVATOR)
		message(FATAL_ERROR "Cannot create active library bundle ${target} without designated activator library AND class. Use NO_ACTIVATOR flag to override.")
	endif()

	# set poco variables to defaults or user parameters
	IF_THEN_SET(args_NAME POCO_BUNDLE_NAME "${args_NAME}" "${POCO_BUNDLE_NAME}")
	IF_THEN_SET(POCO_BUNDLE_NAME POCO_BUNDLE_NAME "${POCO_BUNDLE_NAME}" "${target} Bundle")
	# symbolic name
	IF_THEN_SET(args_SYMBOLIC_NAME POCO_BUNDLE_SYMBOLIC_NAME "${args_SYMBOLIC_NAME}" "${POCO_BUNDLE_SYMBOLIC_NAME}")
	IF_THEN_SET(POCO_BUNDLE_SYMBOLIC_NAME POCO_BUNDLE_SYMBOLIC_NAME "${POCO_BUNDLE_SYMBOLIC_NAME}" "${target}")
	# Version
	IF_THEN_SET(args_VERSION POCO_BUNDLE_VERSION "${args_VERSION}" "${POCO_BUNDLE_VERSION}")
	IF_THEN_SET(POCO_BUNDLE_VERSION POCO_BUNDLE_VERSION "${POCO_BUNDLE_VERSION}" 0.0.1)
	# Vendor
	IF_THEN_SET(args_VENDOR POCO_BUNDLE_VENDOR "${args_VENDOR}" "${POCO_BUNDLE_VENDOR}")
	IF_THEN_SET(POCO_BUNDLE_VENDOR POCO_BUNDLE_VENDOR "${POCO_BUNDLE_VENDOR}" "no vendor information available")
	
	if(NOT TARGET ${target})
		add_custom_target(${target} ALL
			DEPENDS ${POCO_BUNDLE_SPEC_OUTPUT} ${args_FILES}
			SOURCES ${args_FILES}
		)
	endif()
	
	if(args_LIBRARIES OR args_ACTIVATOR_LIBRARY)
		list(APPEND libraries ${args_LIBRARIES} ${args_ACTIVATOR_LIBRARY})
		list(REMOVE_DUPLICATES libraries)
		foreach(library ${libraries})
			if(NOT TARGET ${library})
				message(FATAL_ERROR "Library argument ${library} to bundle ${target} is not a target.")
			endif()
			list(APPEND config_arguments 
				"-D${library}_LOCATION:STRING=$<TARGET_FILE:${library}>"
				"-D${library}_FILENAME:STRING=$<TARGET_FILE_NAME:${library}>"
			)
		endforeach()
	endif()

	add_custom_command(OUTPUT ${POCO_BUNDLE_SPEC_OUTPUT}
		COMMAND ${CMAKE_COMMAND} ARGS 
		-DCONFIGURATION:STRING=$<CONFIGURATION>
		-DPOSTFIX:STRING="$<$<CONFIG:Debug>:d>"
		-DPOCO_BUNDLE_SPEC_OUTPUT:STRING="${POCO_BUNDLE_SPEC_OUTPUT}"
		${config_arguments}
		-P ${config_file}
		DEPENDS ${libraries} ${config_file}
	)

	message(${config_arguments})
	set_target_properties(${target} PROPERTIES _CONFIG_FILE ${config_file})

    if(NOT POCO_BUNDLE_ROOT)
		set(POCO_BUNDLE_ROOT "${CMAKE_CURRENT_BINARY_DIR}/${target}.dir/root")
	endif()
	
	if(NOT POCO_BUNDLE_OUTPUT_DIRECTORY)
		if(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
			set(POCO_BUNDLE_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/bundles")
		else()
			set(POCO_BUNDLE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bundles")
		endif()
	endif()
	foreach(Config ${CMAKE_CONFIGURATION_TYPES})
		string(TOUPPER ${Config} CONFIG)
		if(NOT POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG})
			if(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
				set(POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG} "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${Config}/bundles")
			else()
				set(POCO_BUNDLE_OUTPUT_DIRECTORY_${CONFIG} "${CMAKE_CURRENT_BINARY_DIR}/bundles/${Config}")
			endif()
		endif()
	endforeach()

	if(args_NO_ACTIVATOR)
		set_property(TARGET ${target} PROPERTY POCO_BUNDLE_ACTIVATOR_LIBRARY)
		set_property(TARGET ${target} PROPERTY POCO_BUNDLE_ACTIVATOR_CLASS)
	else()
		set_target_properties(${target} PROPERTIES 
			POCO_BUNDLE_ACTIVATOR_LIBRARY ${args_ACTIVATOR_LIBRARY}
			POCO_BUNDLE_ACTIVATOR_CLASS ${args_ACTIVATOR_CLASS}
		)
	endif()

	poco_make_bundle_target(${target})
	
	foreach(lib ${libraries})
		poco_bundle_add_library(${target} ${lib})
	endforeach()
endfunction()


# -- Add a POCO Bundle to the project using the specified source files.
function(POCO_ADD_SINGLE_LIBRARY_BUNDLE target bundle_id)
	set(options)
	set(multiValueArgs SOURCES)
    set(oneValueArgs 
    	ACTIVATOR_CLASS 
    	VERSION
    	FOLDER
    )
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	add_library(${target} SHARED ${args_UNPARSED_ARGUMENTS})

	set_target_properties(${target}
		PROPERTIES 
		RUNTIME_OUTPUT_NAME ${bundle_id}
		LIBRARY_OUTPUT_NAME ${bundle_id}
		ARCHIVE_OUTPUT_NAME ${target}
		DEBUG_POSTFIX "d"
		PREFIX ""
		BUILD_WITH_INSTALL_RPATH true # this ensures an empty rpath in linux
		INSTALL_NAME_DIR @rpath
	)
	set(POCO_BUNDLE_VERSION ${args_VERSION})
	set(POCO_BUNDLE_ACTIVATOR_CLASS ${args_ACTIVATOR_CLASS}) # redundancy?
	set(POCO_BUNDLE_SYMBOLIC_NAME ${bundle_id})
	set(POCO_BUNDLE_ROOT ${CMAKE_CURRENT_BINARY_DIR}/${bundle_id}.dir/root)
	poco_add_bundle(${bundle_id} ACTIVATOR_LIBRARY ${target} ACTIVATOR_CLASS ${args_ACTIVATOR_CLASS})
	if(args_FOLDER)
		set_property(GLOBAL PROPERTY USE_FOLDERS true)
		set_target_properties(${bundle_id} ${target}
			PROPERTIES 
			FOLDER ${args_FOLDER}
		)
	endif()

endfunction(POCO_ADD_SINGLE_LIBRARY_BUNDLE)
