#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::Core5Compat" for configuration "RelWithDebInfo"
set_property(TARGET Qt6::Core5Compat APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(Qt6::Core5Compat PROPERTIES
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/lib/libQt6Core5Compat.lib.so"
  IMPORTED_SONAME_RELWITHDEBINFO "libQt6Core5Compat.lib.so"
  )

list(APPEND _IMPORT_CHECK_FILES_FOR_Qt6::Core5Compat "${_IMPORT_PREFIX}/lib/libQt6Core5Compat.lib.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
