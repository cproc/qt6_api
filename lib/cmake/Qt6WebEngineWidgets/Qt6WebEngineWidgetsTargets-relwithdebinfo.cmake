#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::WebEngineWidgets" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::WebEngineWidgets APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::WebEngineWidgets PROPERTIES
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libQt6WebEngineWidgets.lib.so"
  IMPORTED_SONAME_RELWITHDEBINFO "libQt6WebEngineWidgets.lib.so"
  )

list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::WebEngineWidgets "${_IMPORT_PREFIX}/lib/libQt6WebEngineWidgets.lib.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
