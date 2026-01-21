# FetchDependencies.cmake
# Automatically fetches and builds DirectXTK, DirectXTex, and Effects11

include(FetchContent)

# Set FetchContent base directory
set(FETCHCONTENT_BASE_DIR ${CMAKE_BINARY_DIR}/_deps)

message(STATUS "========================================")
message(STATUS "Fetching external dependencies...")
message(STATUS "========================================")

# ============================================
# DirectXTK
# ============================================
message(STATUS "Fetching DirectXTK from GitHub...")

FetchContent_Declare(
    DirectXTK
    GIT_REPOSITORY https://github.com/microsoft/DirectXTK.git
    GIT_TAG        apr2016  # Using April 2016 tag for compatibility
    GIT_SHALLOW    TRUE
)

# Configure DirectXTK build options
set(BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(BUILD_DXUT OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(DirectXTK)

# Set DirectXTK variables for our project
set(DirectXTK_INCLUDE_DIR ${directxtk_SOURCE_DIR}/Inc CACHE PATH "DirectXTK include directory" FORCE)
set(DirectXTK_LIBRARIES DirectXTK CACHE STRING "DirectXTK library" FORCE)

# Also check for Src directory as some files might be there
if(EXISTS ${directxtk_SOURCE_DIR}/Src)
    list(APPEND DirectXTK_INCLUDE_DIR ${directxtk_SOURCE_DIR}/Src)
endif()

message(STATUS "DirectXTK fetched successfully")
message(STATUS "  Source: ${directxtk_SOURCE_DIR}")
message(STATUS "  Include: ${DirectXTK_INCLUDE_DIR}")

# ============================================
# DirectXTex
# ============================================
message(STATUS "Fetching DirectXTex from GitHub...")

FetchContent_Declare(
    DirectXTex
    GIT_REPOSITORY https://github.com/microsoft/DirectXTex.git
    GIT_TAG        apr2016  # Using April 2016 tag for compatibility
    GIT_SHALLOW    TRUE
)

# Configure DirectXTex build options
set(BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(BUILD_DX11 ON CACHE BOOL "" FORCE)
set(BUILD_DX12 OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(DirectXTex)

# Set DirectXTex variables for our project
set(DirectXTex_INCLUDE_DIR ${directxtex_SOURCE_DIR}/DirectXTex CACHE PATH "DirectXTex include directory" FORCE)
set(DirectXTex_LIBRARIES DirectXTex CACHE STRING "DirectXTex library" FORCE)

message(STATUS "DirectXTex fetched successfully")
message(STATUS "  Source: ${directxtex_SOURCE_DIR}")
message(STATUS "  Include: ${DirectXTex_INCLUDE_DIR}")

# Copy DDSTextureLoader files from DirectXTex to SharedUtility
set(DDS_DEST_DIR ${CMAKE_SOURCE_DIR}/SharedUtility/DDSTextureLoader)
if(EXISTS ${directxtex_SOURCE_DIR}/DDSTextureLoader)
    message(STATUS "Copying DDSTextureLoader files...")
    file(COPY
        ${directxtex_SOURCE_DIR}/DDSTextureLoader/DDSTextureLoader.h
        ${directxtex_SOURCE_DIR}/DDSTextureLoader/DDSTextureLoader.cpp
        DESTINATION ${DDS_DEST_DIR}
    )
    message(STATUS "  DDSTextureLoader files copied to SharedUtility/DDSTextureLoader/")
endif()

# ============================================
# Effects11 (Compact Effects11)
# ============================================
message(STATUS "Fetching CompactEffects11 from GitHub...")

FetchContent_Declare(
    Effects11
    GIT_REPOSITORY https://github.com/sygh-JP/CompactEffects11.git
    GIT_TAG        master
    GIT_SHALLOW    TRUE
)

FetchContent_GetProperties(Effects11)
if(NOT effects11_POPULATED)
    FetchContent_Populate(Effects11)

    # CompactEffects11 doesn't have CMakeLists.txt, so we need to create a target manually
    message(STATUS "Building Effects11 library...")

    # Find all source files
    file(GLOB EFFECTS11_SOURCES
        ${effects11_SOURCE_DIR}/Src/*.cpp
    )

    file(GLOB EFFECTS11_HEADERS
        ${effects11_SOURCE_DIR}/Inc/*.h
        ${effects11_SOURCE_DIR}/Inc/*.inl
    )

    # Create static library
    add_library(Effects11 STATIC
        ${EFFECTS11_SOURCES}
        ${EFFECTS11_HEADERS}
    )

    # Set include directories
    target_include_directories(Effects11 PUBLIC
        ${effects11_SOURCE_DIR}/Inc
    )

    # Set preprocessor definitions
    target_compile_definitions(Effects11 PRIVATE
        WIN32
        _WINDOWS
        UNICODE
        _UNICODE
        $<$<CONFIG:Debug>:_DEBUG>
        $<$<CONFIG:Release>:NDEBUG>
    )

    # Compiler options
    target_compile_options(Effects11 PRIVATE
        /W3
        $<$<CONFIG:Debug>:/Od>
        $<$<CONFIG:Release>:/O2>
    )

    # Link with DirectX libraries
    target_link_libraries(Effects11 PUBLIC
        d3d11.lib
        dxguid.lib
    )

    # Set folder for IDE
    set_target_properties(Effects11 PROPERTIES
        FOLDER "External/Effects11"
    )

    # Set Effects11 variables for our project
    set(Effects11_INCLUDE_DIR ${effects11_SOURCE_DIR}/Inc CACHE PATH "Effects11 include directory" FORCE)
    set(Effects11_LIBRARIES Effects11 CACHE STRING "Effects11 library" FORCE)

    message(STATUS "Effects11 built successfully")
    message(STATUS "  Source: ${effects11_SOURCE_DIR}")
    message(STATUS "  Include: ${Effects11_INCLUDE_DIR}")
endif()

# ============================================
# Set folder properties for external projects
# ============================================
if(TARGET DirectXTK)
    set_target_properties(DirectXTK PROPERTIES FOLDER "External/DirectXTK")
endif()

if(TARGET DirectXTex)
    set_target_properties(DirectXTex PROPERTIES FOLDER "External/DirectXTex")
endif()

message(STATUS "========================================")
message(STATUS "All dependencies fetched successfully!")
message(STATUS "========================================")
message(STATUS "")
