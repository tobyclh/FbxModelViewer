# FindEffects11.cmake
# Finds the Effects11 library (Compact Effects11)
#
# This module defines:
#  Effects11_FOUND - System has Effects11
#  Effects11_INCLUDE_DIR - The Effects11 include directory
#  Effects11_LIBRARIES - The libraries needed to use Effects11

# Determine platform
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(EFFECTS11_ARCH "x64")
else()
    set(EFFECTS11_ARCH "Win32")
endif()

# Search paths
set(EFFECTS11_SEARCH_PATHS
    "$ENV{EFFECTS11_ROOT}"
    "$ENV{EFFECTS11_DIR}"
    "${CMAKE_SOURCE_DIR}/../CompactEffects11"
    "${CMAKE_SOURCE_DIR}/../../CompactEffects11"
    "${CMAKE_SOURCE_DIR}/../Effects11"
    "${CMAKE_SOURCE_DIR}/../../Effects11"
    "C:/CompactEffects11"
    "C:/Effects11"
    "C:/Libraries/CompactEffects11"
    "C:/Libraries/Effects11"
    "C:/Program Files/Effects11"
    "C:/Program Files (x86)/Effects11"
)

# Find include directory
find_path(Effects11_INCLUDE_DIR
    NAMES d3dx11effect.h
    PATHS ${EFFECTS11_SEARCH_PATHS}
    PATH_SUFFIXES
        Inc
        include
        Binary/Effects11/Inc
)

# Find library - for Desktop_2015 (VS2015)
find_library(Effects11_LIBRARY_RELEASE
    NAMES Effects11
    PATHS ${EFFECTS11_SEARCH_PATHS}
    PATH_SUFFIXES
        "Binary/Desktop_2015/${EFFECTS11_ARCH}/Release"
        "Desktop_2015/${EFFECTS11_ARCH}/Release"
        "Bin/Desktop_2015/${EFFECTS11_ARCH}/Release"
        "Binary/Desktop_2013/${EFFECTS11_ARCH}/Release"
        "Desktop_2013/${EFFECTS11_ARCH}/Release"
        "lib/${EFFECTS11_ARCH}/Release"
        "${EFFECTS11_ARCH}/Release"
)

find_library(Effects11_LIBRARY_DEBUG
    NAMES Effects11
    PATHS ${EFFECTS11_SEARCH_PATHS}
    PATH_SUFFIXES
        "Binary/Desktop_2015/${EFFECTS11_ARCH}/Debug"
        "Desktop_2015/${EFFECTS11_ARCH}/Debug"
        "Bin/Desktop_2015/${EFFECTS11_ARCH}/Debug"
        "Binary/Desktop_2013/${EFFECTS11_ARCH}/Debug"
        "Desktop_2013/${EFFECTS11_ARCH}/Debug"
        "lib/${EFFECTS11_ARCH}/Debug"
        "${EFFECTS11_ARCH}/Debug"
)

# Set libraries based on configuration
if(Effects11_LIBRARY_DEBUG AND Effects11_LIBRARY_RELEASE)
    set(Effects11_LIBRARIES
        optimized ${Effects11_LIBRARY_RELEASE}
        debug ${Effects11_LIBRARY_DEBUG}
    )
elseif(Effects11_LIBRARY_RELEASE)
    set(Effects11_LIBRARIES ${Effects11_LIBRARY_RELEASE})
elseif(Effects11_LIBRARY_DEBUG)
    set(Effects11_LIBRARIES ${Effects11_LIBRARY_DEBUG})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Effects11
    REQUIRED_VARS Effects11_INCLUDE_DIR Effects11_LIBRARIES
)

# Create imported target
if(Effects11_FOUND AND NOT TARGET Effects11::Effects11)
    add_library(Effects11::Effects11 UNKNOWN IMPORTED)
    set_target_properties(Effects11::Effects11 PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Effects11_INCLUDE_DIR}"
    )

    if(Effects11_LIBRARY_RELEASE)
        set_property(TARGET Effects11::Effects11 APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE
        )
        set_target_properties(Effects11::Effects11 PROPERTIES
            IMPORTED_LOCATION_RELEASE "${Effects11_LIBRARY_RELEASE}"
        )
    endif()

    if(Effects11_LIBRARY_DEBUG)
        set_property(TARGET Effects11::Effects11 APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG
        )
        set_target_properties(Effects11::Effects11 PROPERTIES
            IMPORTED_LOCATION_DEBUG "${Effects11_LIBRARY_DEBUG}"
        )
    endif()
endif()

mark_as_advanced(
    Effects11_INCLUDE_DIR
    Effects11_LIBRARY_RELEASE
    Effects11_LIBRARY_DEBUG
)
