# FindDirectXTK.cmake
# Finds the DirectX Tool Kit (DirectXTK)
#
# This module defines:
#  DirectXTK_FOUND - System has DirectXTK
#  DirectXTK_INCLUDE_DIR - The DirectXTK include directory
#  DirectXTK_LIBRARIES - The libraries needed to use DirectXTK

# Determine platform
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(DIRECTXTK_ARCH "x64")
else()
    set(DIRECTXTK_ARCH "Win32")
endif()

# Search paths
set(DIRECTXTK_SEARCH_PATHS
    "$ENV{DIRECTXTK_ROOT}"
    "$ENV{DIRECTXTK_DIR}"
    "${CMAKE_SOURCE_DIR}/../DirectXTK"
    "${CMAKE_SOURCE_DIR}/../../DirectXTK"
    "C:/DirectXTK"
    "C:/Libraries/DirectXTK"
    "C:/Program Files/DirectXTK"
    "C:/Program Files (x86)/DirectXTK"
)

# Find include directory
find_path(DirectXTK_INCLUDE_DIR
    NAMES DDSTextureLoader.h SpriteBatch.h
    PATHS ${DIRECTXTK_SEARCH_PATHS}
    PATH_SUFFIXES
        Inc
        include
        Src
)

# Find library
find_library(DirectXTK_LIBRARY_RELEASE
    NAMES DirectXTK
    PATHS ${DIRECTXTK_SEARCH_PATHS}
    PATH_SUFFIXES
        "Bin/Desktop_2015/${DIRECTXTK_ARCH}/Release"
        "Bin/Desktop_2013/${DIRECTXTK_ARCH}/Release"
        "lib/${DIRECTXTK_ARCH}/Release"
        "${DIRECTXTK_ARCH}/Release"
)

find_library(DirectXTK_LIBRARY_DEBUG
    NAMES DirectXTK
    PATHS ${DIRECTXTK_SEARCH_PATHS}
    PATH_SUFFIXES
        "Bin/Desktop_2015/${DIRECTXTK_ARCH}/Debug"
        "Bin/Desktop_2013/${DIRECTXTK_ARCH}/Debug"
        "lib/${DIRECTXTK_ARCH}/Debug"
        "${DIRECTXTK_ARCH}/Debug"
)

# Set libraries based on configuration
if(DirectXTK_LIBRARY_DEBUG AND DirectXTK_LIBRARY_RELEASE)
    set(DirectXTK_LIBRARIES
        optimized ${DirectXTK_LIBRARY_RELEASE}
        debug ${DirectXTK_LIBRARY_DEBUG}
    )
elseif(DirectXTK_LIBRARY_RELEASE)
    set(DirectXTK_LIBRARIES ${DirectXTK_LIBRARY_RELEASE})
elseif(DirectXTK_LIBRARY_DEBUG)
    set(DirectXTK_LIBRARIES ${DirectXTK_LIBRARY_DEBUG})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DirectXTK
    REQUIRED_VARS DirectXTK_INCLUDE_DIR DirectXTK_LIBRARIES
)

# Create imported target
if(DirectXTK_FOUND AND NOT TARGET DirectXTK::DirectXTK)
    add_library(DirectXTK::DirectXTK UNKNOWN IMPORTED)
    set_target_properties(DirectXTK::DirectXTK PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${DirectXTK_INCLUDE_DIR}"
    )

    if(DirectXTK_LIBRARY_RELEASE)
        set_property(TARGET DirectXTK::DirectXTK APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE
        )
        set_target_properties(DirectXTK::DirectXTK PROPERTIES
            IMPORTED_LOCATION_RELEASE "${DirectXTK_LIBRARY_RELEASE}"
        )
    endif()

    if(DirectXTK_LIBRARY_DEBUG)
        set_property(TARGET DirectXTK::DirectXTK APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG
        )
        set_target_properties(DirectXTK::DirectXTK PROPERTIES
            IMPORTED_LOCATION_DEBUG "${DirectXTK_LIBRARY_DEBUG}"
        )
    endif()
endif()

mark_as_advanced(
    DirectXTK_INCLUDE_DIR
    DirectXTK_LIBRARY_RELEASE
    DirectXTK_LIBRARY_DEBUG
)
