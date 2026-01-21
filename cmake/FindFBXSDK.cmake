# FindFBXSDK.cmake
# Finds the Autodesk FBX SDK
#
# This module defines:
#  FBXSDK_FOUND - System has FBX SDK
#  FBXSDK_INCLUDE_DIR - The FBX SDK include directory
#  FBXSDK_LIBRARIES - The libraries needed to use FBX SDK
#  FBXSDK_LIBRARY_DIR - The directory containing FBX SDK libraries

# Determine Visual Studio version
if(MSVC_VERSION EQUAL 1900)
    set(FBXSDK_VS_VERSION "vs2015")
elseif(MSVC_VERSION EQUAL 1800)
    set(FBXSDK_VS_VERSION "vs2013")
elseif(MSVC_VERSION EQUAL 1700)
    set(FBXSDK_VS_VERSION "vs2012")
else()
    set(FBXSDK_VS_VERSION "vs2015")  # Default to vs2015
endif()

# Determine platform
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(FBXSDK_ARCH "x64")
else()
    set(FBXSDK_ARCH "x86")
endif()

# Search for FBX SDK installation
# Common installation paths
set(FBXSDK_SEARCH_PATHS
    "$ENV{FBXSDK_ROOT}"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.3.2"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.3.1"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.3"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.2"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.1"
    "C:/Program Files/Autodesk/FBX/FBX SDK/2020.0"
)

# Find include directory
find_path(FBXSDK_INCLUDE_DIR
    NAMES fbxsdk.h
    PATHS ${FBXSDK_SEARCH_PATHS}
    PATH_SUFFIXES include
)

# Find library directory
find_path(FBXSDK_LIBRARY_DIR
    NAMES libfbxsdk.lib
    PATHS ${FBXSDK_SEARCH_PATHS}
    PATH_SUFFIXES
        "lib/${FBXSDK_VS_VERSION}/${FBXSDK_ARCH}/release"
        "lib/${FBXSDK_VS_VERSION}/${FBXSDK_ARCH}/debug"
)

# Determine configuration-specific library
if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(FBXSDK_CONFIG_SUFFIX "debug")
else()
    set(FBXSDK_CONFIG_SUFFIX "release")
endif()

# Find the library
find_library(FBXSDK_LIBRARY_RELEASE
    NAMES libfbxsdk-md libfbxsdk
    PATHS ${FBXSDK_SEARCH_PATHS}
    PATH_SUFFIXES
        "lib/${FBXSDK_VS_VERSION}/${FBXSDK_ARCH}/release"
)

find_library(FBXSDK_LIBRARY_DEBUG
    NAMES libfbxsdk-md libfbxsdk
    PATHS ${FBXSDK_SEARCH_PATHS}
    PATH_SUFFIXES
        "lib/${FBXSDK_VS_VERSION}/${FBXSDK_ARCH}/debug"
)

# Set the library variable based on configuration
if(FBXSDK_LIBRARY_DEBUG AND FBXSDK_LIBRARY_RELEASE)
    set(FBXSDK_LIBRARIES
        optimized ${FBXSDK_LIBRARY_RELEASE}
        debug ${FBXSDK_LIBRARY_DEBUG}
    )
elseif(FBXSDK_LIBRARY_RELEASE)
    set(FBXSDK_LIBRARIES ${FBXSDK_LIBRARY_RELEASE})
elseif(FBXSDK_LIBRARY_DEBUG)
    set(FBXSDK_LIBRARIES ${FBXSDK_LIBRARY_DEBUG})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FBXSDK
    REQUIRED_VARS FBXSDK_INCLUDE_DIR FBXSDK_LIBRARIES
    VERSION_VAR FBXSDK_VERSION
)

# Create imported target
if(FBXSDK_FOUND AND NOT TARGET FBXSDK::FBXSDK)
    add_library(FBXSDK::FBXSDK UNKNOWN IMPORTED)
    set_target_properties(FBXSDK::FBXSDK PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${FBXSDK_INCLUDE_DIR}"
    )

    if(FBXSDK_LIBRARY_RELEASE)
        set_property(TARGET FBXSDK::FBXSDK APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE
        )
        set_target_properties(FBXSDK::FBXSDK PROPERTIES
            IMPORTED_LOCATION_RELEASE "${FBXSDK_LIBRARY_RELEASE}"
        )
    endif()

    if(FBXSDK_LIBRARY_DEBUG)
        set_property(TARGET FBXSDK::FBXSDK APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG
        )
        set_target_properties(FBXSDK::FBXSDK PROPERTIES
            IMPORTED_LOCATION_DEBUG "${FBXSDK_LIBRARY_DEBUG}"
        )
    endif()
endif()

mark_as_advanced(
    FBXSDK_INCLUDE_DIR
    FBXSDK_LIBRARY_DIR
    FBXSDK_LIBRARY_RELEASE
    FBXSDK_LIBRARY_DEBUG
)
