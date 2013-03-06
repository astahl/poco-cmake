poco-cmake
==========

CMake scripts and support files for POCO and the POCO Open Service Platform (OSP).

Examples
--------

To build the examples, use cmake on the command line
	cd examples
	mkdir out
	cd out
	cmake .. [-G Xcode | -G Ninja | ... ]
	make [xcodebuild | ninja | ... ]
or point the cmake gui to the examples folder as source location.

After the build has finished, copy the bundles from the individual folders to the "bundles" folder in the BundleContainerApplication binary directory. 