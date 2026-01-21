# FindDirectXTex.cmake
# Finds the DirectXTex library
#
# This module defines:
#  DirectXTex_FOUND - System has DirectXTex
#  DirectXTex_INCLUDE_DIR - The DirectXTex include directory
#  DirectXTex_LIBRARIES - The libraries needed to use DirectXTex

# Determine platform
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(DIRECTXTEX_ARCH "x64")
else()
    set(DIRECTXTEX_ARCH "Win32")
endif()

# Search paths
set(DIRECTXTEX_SEARCH_PATHS
    "$ENV{DIRECTXTEX_ROOT}"
    "$ENV{DIRECTXTEX_DIR}"
    "${CMAKE_SOURCE_DIR}/../DirectXTex"
    "${CMAKE_SOURCE_DIR}/../../DirectXTex"
    "C:/DirectXTex"
    "C:/Libraries/DirectXTex"
    "C:/Program Files/DirectXTex"
    "C:/Program Files (x86)/DirectXTex"
)

# Find include directory
find_path(DirectXTex_INCLUDE_DIR
    NAMES DirectXTex.h
    PATHS ${DIRECTXTEX_SEARCH_PATHS}
    PATH_SUFFIXES
        DirectXTex
        include
)

# Find library
find_library(DirectXTex_LIBRARY_RELEASE
    NAMES DirectXTex
    PATHS ${DIRECTXTEX_SEARCH_PATHS}
    PATH_SUFFIXES
        "DirectXTex/Bin/Desktop_2015/${DIRECTXTEX_ARCH}/Release"
        "DirectXTex/Bin/Desktop_2013/${DIRECTXTEX_ARCH}/Release"
        "Bin/Desktop_2015/${DIRECTXTEX_ARCH}/Release"
        "Bin/Desktop_2013/${DIRECTXTEX_ARCH}/Release"
        "lib/${DIRECTXTEX_ARCH}/Release"
        "${DIRECTXTEX_ARCH}/Release"
)

find_library(DirectXTex_LIBRARY_DEBUG
    NAMES DirectXTex
    PATHS ${DIRECTXTEX_SEARCH_PATHS}
    PATH_SUFFIXES
        "DirectXTex/Bin/Desktop_2015/${DIRECTXTEX_ARCH}/Debug"
        "DirectXTex/Bin/Desktop_2013/${DIRECTXTEX_ARCH}/Debug"
        "Bin/Desktop_2015/${DIRECTXTEX_ARCH}/Debug"
        "Bin/Desktop_2013/${DIRECTXTEX_ARCH}/Debug"
        "lib/${DIRECTXTEX_ARCH}/Debug"
        "${DIRECTXTEX_ARCH}/Debug"
)

# Set libraries based on configuration
if(DirectXTex_LIBRARY_DEBUG AND DirectXTex_LIBRARY_RELEASE)
    set(DirectXTex_LIBRARIES
        optimized ${DirectXTex_LIBRARY_RELEASE}
        debug ${DirectXTex_LIBRARY_DEBUG}
    )
elseif(DirectXTex_LIBRARY_RELEASE)
    set(DirectXTex_LIBRARIES ${DirectXTex_LIBRARY_RELEASE})
elseif(DirectXTex_LIBRARY_DEBUG)
    set(DirectXTex_LIBRARIES ${DirectXTex_LIBRARY_DEBUG})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DirectXTex
    REQUIRED_VARS DirectXTex_INCLUDE_DIR DirectXTex_LIBRARIES
)

# Create imported target
if(DirectXTex_FOUND AND NOT TARGET DirectXTex::DirectXTex)
    add_library(DirectXTex::DirectXTex UNKNOWN IMPORTED)
    set_target_properties(DirectXTex::DirectXTex PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${DirectXTex_INCLUDE_DIR}"
    )

    if(DirectXTex_LIBRARY_RELEASE)
        set_property(TARGET DirectXTex::DirectXTex APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE
        )
        set_target_properties(DirectXTex::DirectXTex PROPERTIES
            IMPORTED_LOCATION_RELEASE "${DirectXTex_LIBRARY_RELEASE}"
        )
    endif()

    if(DirectXTex_LIBRARY_DEBUG)
        set_property(TARGET DirectXTex::DirectXTex APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG
        )
        set_target_properties(DirectXTex::DirectXTex PROPERTIES
            IMPORTED_LOCATION_DEBUG "${DirectXTex_LIBRARY_DEBUG}"
        )
    endif()
endif()

mark_as_advanced(
    DirectXTex_INCLUDE_DIR
    DirectXTex_LIBRARY_RELEASE
    DirectXTex_LIBRARY_DEBUG
)
