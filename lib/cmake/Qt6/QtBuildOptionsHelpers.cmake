# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: BSD-3-Clause

macro(qt_internal_set_default_build_type)
    set(_default_build_type "Release")
    if(FEATURE_developer_build)
        set(_default_build_type "Debug")
    endif()

    # Try to detect if an explicit CMAKE_BUILD_TYPE was set by the user.
    # CMake sets CMAKE_BUILD_TYPE_INIT to Debug on most Windows platforms and doesn't set
    # anything for UNIXes. CMake assigns CMAKE_BUILD_TYPE_INIT to CMAKE_BUILD_TYPE during
    # first project() if CMAKE_BUILD_TYPE has no previous value.
    # We use extra information about the state of CMAKE_BUILD_TYPE before the first
    # project() call that's set in QtAutodetect.
    # STREQUAL check needs to have expanded variables because an undefined var is not equal
    # to an empty defined var.
    # See also qt_internal_force_set_cmake_build_type_conditionally which is used
    # to set the build type when building other repos or tests.
    if("${CMAKE_BUILD_TYPE}" STREQUAL "${CMAKE_BUILD_TYPE_INIT}"
        AND NOT __qt_auto_detect_cmake_build_type_before_project_call
        AND NOT __qt_build_internals_cmake_build_type
        AND NOT CMAKE_CONFIGURATION_TYPES)
      message(STATUS "Setting build type to '${_default_build_type}' as none was specified.")
      set(CMAKE_BUILD_TYPE "${_default_build_type}" CACHE STRING "Choose the type of build." FORCE)
      set_property(CACHE CMAKE_BUILD_TYPE
          PROPERTY STRINGS
          "Debug" "Release" "MinSizeRel" "RelWithDebInfo") # Set the possible values for cmake-gui.
    elseif(CMAKE_CONFIGURATION_TYPES)
        message(STATUS "Building for multiple configurations: ${CMAKE_CONFIGURATION_TYPES}.")
        message(STATUS "Main configuration is: ${QT_MULTI_CONFIG_FIRST_CONFIG}.")
        if(CMAKE_NINJA_MULTI_DEFAULT_BUILD_TYPE)
            message(STATUS
                "Default build configuration set to '${CMAKE_NINJA_MULTI_DEFAULT_BUILD_TYPE}'.")
        endif()
        if(CMAKE_GENERATOR STREQUAL "Ninja")
            message(FATAL_ERROR
                "It's not possible to build multiple configurations with the single config Ninja "
                "generator. Consider configuring with -G\"Ninja Multi-Config\" instead of -GNinja."
            )
        endif()
    else()
        message(STATUS "CMAKE_BUILD_TYPE was set to: '${CMAKE_BUILD_TYPE}'")
    endif()
endmacro()

macro(qt_internal_set_configure_from_ide)
    # QT_INTERNAL_CONFIGURE_FROM_IDE is set to TRUE for the following known IDE applications:
    # - Qt Creator, detected by QTC_RUN environment variable
    # - CLion, detected by CLION_IDE environment variable
    # - Visual Studio Code, detected by VSCODE_CLI environment variable
    if("$ENV{QTC_RUN}" OR "$ENV{CLION_IDE}" OR "$ENV{VSCODE_CLI}")
        set(QT_INTERNAL_CONFIGURE_FROM_IDE TRUE CACHE INTERNAL "Configuring Qt Project from IDE")
    else()
        set(QT_INTERNAL_CONFIGURE_FROM_IDE FALSE CACHE INTERNAL "Configuring Qt Project from IDE")
    endif()
endmacro()

macro(qt_internal_set_sync_headers_at_configure_time)
    set(_qt_sync_headers_at_configure_time_default ${QT_INTERNAL_CONFIGURE_FROM_IDE})

    if(FEATURE_developer_build)
        # Sync headers during the initial configuration of a -developer-build to facilitate code
        # navigation for code editors that use an LSP-based code model.
        set(_qt_sync_headers_at_configure_time_default TRUE)
    endif()

    # Sync Qt header files at configure time
    option(QT_SYNC_HEADERS_AT_CONFIGURE_TIME "Run syncqt at configure time already"
        ${_qt_sync_headers_at_configure_time_default})
    unset(_qt_sync_headers_at_configure_time_default)

    # In static Ninja Multi-Config builds the sync_headers dependencies(and other autogen
    # dependencies are not added to '_autogen/timestamp' targets. See QTBUG-113974.
    if(CMAKE_GENERATOR STREQUAL "Ninja Multi-Config" AND NOT QT_BUILD_SHARED_LIBS)
        set(QT_SYNC_HEADERS_AT_CONFIGURE_TIME TRUE CACHE BOOL "" FORCE)
    endif()
endmacro()

macro(qt_internal_set_export_compile_commands)
    if(FEATURE_developer_build)
        if(DEFINED QT_CMAKE_EXPORT_COMPILE_COMMANDS)
            set(CMAKE_EXPORT_COMPILE_COMMANDS ${QT_CMAKE_EXPORT_COMPILE_COMMANDS})
        else()
            set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
        endif()
    endif()
endmacro()

macro(qt_internal_setup_build_benchmarks)
    if(FEATURE_developer_build)
        set(__build_benchmarks ON)

        # Disable benchmarks for single configuration generators which do not build
        # with release configuration.
        if(CMAKE_BUILD_TYPE AND CMAKE_BUILD_TYPE STREQUAL Debug)
            set(__build_benchmarks OFF)
        endif()
    else()
        set(__build_benchmarks OFF)
    endif()

    # Build Benchmarks
    option(QT_BUILD_BENCHMARKS "Build Qt Benchmarks" ${__build_benchmarks})
endmacro()

macro(qt_internal_setup_build_tests)
    if(FEATURE_developer_build)
        set(_qt_build_tests_default ON)

        # Tests are not built by default with qmake for iOS and friends, and thus the overall build
        # tends to fail. Disable them by default when targeting uikit.
        if(UIKIT OR ANDROID)
            set(_qt_build_tests_default OFF)
        endif()
    else()
        set(_qt_build_tests_default OFF)
    endif()

    # If benchmarks are explicitly enabled, force tests to also be built, even if they might
    # not work on the platform.
    if(QT_BUILD_BENCHMARKS)
        set(_qt_build_tests_default ON)
    endif()

    ## Set up testing
    option(QT_BUILD_TESTS "Build the testing tree." ${_qt_build_tests_default})
    unset(_qt_build_tests_default)
    option(QT_BUILD_TESTS_BY_DEFAULT
        "Should tests be built as part of the default 'all' target." ON)
    if(QT_BUILD_STANDALONE_TESTS)
        # BuildInternals might have set it to OFF on initial configuration. So force it to ON when
        # building standalone tests.
        set(QT_BUILD_TESTS ON CACHE BOOL "Build the testing tree." FORCE)

        # Also force the tests to be built as part of the default build target.
        set(QT_BUILD_TESTS_BY_DEFAULT ON CACHE BOOL
            "Should tests be built as part of the default 'all' target." FORCE)
    endif()
    set(BUILD_TESTING ${QT_BUILD_TESTS} CACHE INTERNAL "")

    if(WASM)
        set(_qt_batch_tests ON)
    else()
        set(_qt_batch_tests OFF)
    endif()

    if(DEFINED INPUT_batch_tests)
        if (${INPUT_batch_tests})
            set(_qt_batch_tests ON)
        else()
            set(_qt_batch_tests OFF)
        endif()
    endif()

    option(QT_BUILD_TESTS_BATCHED "Link all tests into a single binary." ${_qt_batch_tests})

    if(QT_BUILD_TESTS AND QT_BUILD_TESTS_BATCHED AND CMAKE_VERSION VERSION_LESS "3.19")
        message(FATAL_ERROR
            "Test batching requires at least CMake 3.19, due to requiring per-source "
            "TARGET_DIRECTORY assignments and DEFER calls.")
    endif()

    option(QT_BUILD_MANUAL_TESTS "Build Qt manual tests" OFF)

    if(WASM)
        option(QT_BUILD_MINIMAL_STATIC_TESTS "Build minimal subset of tests for static Qt builds"
            ON)
    else()
        option(QT_BUILD_MINIMAL_STATIC_TESTS "Build minimal subset of tests for static Qt builds"
            OFF)
    endif()

    option(QT_BUILD_MINIMAL_ANDROID_MULTI_ABI_TESTS
        "Build minimal subset of tests for Android multi-ABI Qt builds" OFF)

    include(CTest)
    enable_testing()
endmacro()

macro(qt_internal_setup_build_tools)
    # QT_BUILD_TOOLS_WHEN_CROSSCOMPILING -> QT_FORCE_BUILD_TOOLS
    # pre-6.4 compatibility flag (remove sometime in the future)
    if(CMAKE_CROSSCOMPILING AND QT_BUILD_TOOLS_WHEN_CROSSCOMPILING)
        message(WARNING "QT_BUILD_TOOLS_WHEN_CROSSCOMPILING is deprecated. "
            "Please use QT_FORCE_BUILD_TOOLS instead.")
        set(QT_FORCE_BUILD_TOOLS TRUE CACHE INTERNAL "" FORCE)
    endif()

    # When cross-building, we don't build tools by default. Sometimes this also covers Qt apps as
    # well. Like in qttools/assistant/assistant.pro, load(qt_app), which is guarded by a
    # qtNomakeTools() call.
    set(_qt_build_tools_by_default_default ON)
    if(CMAKE_CROSSCOMPILING AND NOT QT_FORCE_BUILD_TOOLS)
        set(_qt_build_tools_by_default_default OFF)
    endif()
    option(QT_BUILD_TOOLS_BY_DEFAULT "Should tools be built as part of the default 'all' target."
           "${_qt_build_tools_by_default_default}")
    unset(_qt_build_tools_by_default_default)
endmacro()

macro(qt_internal_setup_build_examples)
    option(QT_BUILD_EXAMPLES "Build Qt examples" OFF)
    option(QT_BUILD_EXAMPLES_BY_DEFAULT
        "Should examples be built as part of the default 'all' target." ON)
    option(QT_INSTALL_EXAMPLES_SOURCES "Install example sources" OFF)
    option(QT_INSTALL_EXAMPLES_SOURCES_BY_DEFAULT
        "Install example sources as part of the default 'install' target" ON)

    # FIXME: Support prefix builds as well QTBUG-96232
    if(QT_WILL_INSTALL)
        set(_qt_build_examples_as_external OFF)
    else()
        set(_qt_build_examples_as_external ON)
    endif()
    option(QT_BUILD_EXAMPLES_AS_EXTERNAL "Should examples be built as ExternalProjects."
           ${_qt_build_examples_as_external})
    unset(_qt_build_examples_as_external)
endmacro()

macro(qt_internal_set_qt_host_path)
    ## Path used to find host tools, either when cross-compiling or just when using the tools from
    ## a different host build.
    set(QT_HOST_PATH "$ENV{QT_HOST_PATH}" CACHE PATH
        "Installed Qt host directory path, used for cross compiling.")
endmacro()

macro(qt_internal_set_use_ccache)
    option(QT_USE_CCACHE "Enable the use of ccache")
    if(QT_USE_CCACHE)
        find_program(CCACHE_PROGRAM ccache)
        if(CCACHE_PROGRAM)
            set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_OBJC_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_OBJCXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
        else()
            message(FATAL_ERROR "Ccache use was requested, but the program was not found.")
        endif()
    endif()
endmacro()

macro(qt_internal_set_unity_build)
    option(QT_UNITY_BUILD "Enable unity (jumbo) build")
    set(QT_UNITY_BUILD_BATCH_SIZE "32" CACHE STRING "Unity build batch size")
    if(QT_UNITY_BUILD)
        set(CMAKE_UNITY_BUILD ON)
        set(CMAKE_UNITY_BUILD_BATCH_SIZE "${QT_UNITY_BUILD_BATCH_SIZE}")
    endif()
endmacro()

macro(qt_internal_set_allow_symlink_in_paths)
    option(QT_ALLOW_SYMLINK_IN_PATHS "Allows symlinks in paths." OFF)
endmacro()

macro(qt_internal_set_qt_allow_download)
    option(QT_ALLOW_DOWNLOAD "Allows files to be downloaded when building Qt." OFF)
endmacro()
