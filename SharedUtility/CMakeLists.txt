# SharedUtility static library
project(SharedUtility)

# Collect all source files
file(GLOB_RECURSE SHARED_UTILITY_SOURCES
    "*.cpp"
)

file(GLOB_RECURSE SHARED_UTILITY_HEADERS
    "*.h"
    "*.hpp"
)

# Remove dllmain.cpp as this is a static library
list(REMOVE_ITEM SHARED_UTILITY_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/dllmain.cpp")

# Create static library
add_library(SharedUtility STATIC
    ${SHARED_UTILITY_SOURCES}
    ${SHARED_UTILITY_HEADERS}
)

# Include directories
target_include_directories(SharedUtility PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/MyApp
    ${CMAKE_CURRENT_SOURCE_DIR}/MyFbx
    ${CMAKE_CURRENT_SOURCE_DIR}/MyMisc
    ${CMAKE_CURRENT_SOURCE_DIR}/MyUtils
    ${CMAKE_CURRENT_SOURCE_DIR}/MyD3D
    ${CMAKE_CURRENT_SOURCE_DIR}/MyDX
    ${CMAKE_CURRENT_SOURCE_DIR}/MyOGL
    ${CMAKE_CURRENT_SOURCE_DIR}/MyGLSL
    ${CMAKE_CURRENT_SOURCE_DIR}/MyHLSL
    ${CMAKE_CURRENT_SOURCE_DIR}/PublicInclude
    ${CMAKE_CURRENT_SOURCE_DIR}/DDSTextureLoader
    ${FBXSDK_INCLUDE_DIR}
    ${DirectXTK_INCLUDE_DIR}
    ${DirectXTex_INCLUDE_DIR}
    ${Effects11_INCLUDE_DIR}
)

# Preprocessor definitions
target_compile_definitions(SharedUtility PRIVATE
    WIN32
    _WINDOWS
    _USRDLL
    SHAREDUTILITY_EXPORTS
    UNICODE
    _UNICODE
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# Compiler options
target_compile_options(SharedUtility PRIVATE
    /W3
    /Zi
    /Zm132
    $<$<CONFIG:Debug>:/Od>
    $<$<CONFIG:Release>:/O2>
    $<$<CONFIG:Release>:/Oi>
)

# Set precompiled header
target_precompile_headers(SharedUtility PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/stdafx.h"
)

# Link libraries
target_link_libraries(SharedUtility PUBLIC
    ${FBXSDK_LIBRARIES}
    ${DirectXTex_LIBRARIES}
    ${DIRECTX_LIBRARIES}
    wininet.lib
)

# Set output name
set_target_properties(SharedUtility PROPERTIES
    OUTPUT_NAME "SharedUtility"
    FOLDER "Libraries"
)

# Install targets
install(TARGETS SharedUtility
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)
