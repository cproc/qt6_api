#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::WebEngineQuick" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::WebEngineQuick APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::WebEngineQuick PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELWITHDEBINFO "Qt6::Qml"
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libQt6WebEngineQuick.lib.so"
  IMPORTED_SONAME_RELWITHDEBINFO "libQt6WebEngineQuick.lib.so"
  )

list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::WebEngineQuick "${_IMPORT_PREFIX}/lib/libQt6WebEngineQuick.lib.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
