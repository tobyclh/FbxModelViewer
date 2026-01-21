cmake_minimum_required(VERSION 3.15)

project(FbxModelViewer
    VERSION 1.0.0
    LANGUAGES CXX C)

# Set C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set policies
if(POLICY CMP0091)
    cmake_policy(SET CMP0091 NEW)
endif()

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Multi-config generators (like Visual Studio)
foreach(CONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CONFIG} CONFIG_UPPER)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/bin/${CMAKE_GENERATOR_PLATFORM}/${CONFIG})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/bin/${CMAKE_GENERATOR_PLATFORM}/${CONFIG})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/bin/${CMAKE_GENERATOR_PLATFORM}/${CONFIG})
endforeach()

# Add cmake modules directory
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Options
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)
option(FETCH_DEPENDENCIES "Automatically fetch and build DirectXTK, DirectXTex, and Effects11" ON)

# Platform checks
if(NOT WIN32)
    message(FATAL_ERROR "This project is only supported on Windows")
endif()

# Include FetchContent module for downloading dependencies
include(FetchContent)

# Find or fetch dependencies
if(FETCH_DEPENDENCIES)
    message(STATUS "Fetching dependencies automatically...")
    include(cmake/FetchDependencies.cmake)
else()
    message(STATUS "Using manually installed dependencies...")
    find_package(DirectXTK REQUIRED)
    find_package(DirectXTex REQUIRED)
    find_package(Effects11 REQUIRED)
endif()

# FBX SDK must still be installed manually
find_package(FBXSDK REQUIRED)

# Find DirectX components (usually included with Windows SDK)
# Direct3D 11, Direct2D, DirectWrite are part of Windows SDK
set(DIRECTX_LIBRARIES
    d3d11.lib
    dxgi.lib
    dxguid.lib
    d2d1.lib
    dwrite.lib
    WindowsCodecs.lib
)

# Add subdirectories in dependency order
add_subdirectory(SharedUtility)
add_subdirectory(MyWpfGraphLibMfc)
add_subdirectory(FbxModelMonitor)

# Print configuration summary
message(STATUS "")
message(STATUS "=== FbxModelViewer Configuration ===")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Platform: ${CMAKE_GENERATOR_PLATFORM}")
message(STATUS "FBX SDK: ${FBXSDK_INCLUDE_DIR}")
message(STATUS "DirectXTK: ${DirectXTK_INCLUDE_DIR}")
message(STATUS "DirectXTex: ${DirectXTex_INCLUDE_DIR}")
message(STATUS "Effects11: ${Effects11_INCLUDE_DIR}")
message(STATUS "===================================")
message(STATUS "")
