# FbxModelMonitor - Main application
project(FbxModelMonitor)

# Collect source files
file(GLOB FBXMODELMONITOR_SOURCES
    "*.cpp"
)

file(GLOB FBXMODELMONITOR_HEADERS
    "*.h"
    "*.hpp"
)

file(GLOB FBXMODELMONITOR_MYMFCCTRLS_SOURCES
    "MyMfcCtrls/*.cpp"
)

file(GLOB FBXMODELMONITOR_MYMFCCTRLS_HEADERS
    "MyMfcCtrls/*.h"
    "MyMfcCtrls/*.hpp"
)

file(GLOB FBXMODELMONITOR_MYMFCUTILS_SOURCES
    "MyMfcUtils/*.cpp"
)

file(GLOB FBXMODELMONITOR_MYMFCUTILS_HEADERS
    "MyMfcUtils/*.h"
    "MyMfcUtils/*.hpp"
)

# Create executable
add_executable(FbxModelMonitor WIN32
    ${FBXMODELMONITOR_SOURCES}
    ${FBXMODELMONITOR_HEADERS}
    ${FBXMODELMONITOR_MYMFCCTRLS_SOURCES}
    ${FBXMODELMONITOR_MYMFCCTRLS_HEADERS}
    ${FBXMODELMONITOR_MYMFCUTILS_SOURCES}
    ${FBXMODELMONITOR_MYMFCUTILS_HEADERS}
    FbxModelMonitor.rc
)

# Include directories
target_include_directories(FbxModelMonitor PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/MyMfcCtrls
    ${CMAKE_CURRENT_SOURCE_DIR}/MyMfcUtils
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyApp
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyFbx
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyMisc
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyUtils
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyD3D
    ${CMAKE_SOURCE_DIR}/SharedUtility/MyDX
    ${FBXSDK_INCLUDE_DIR}
    ${DirectXTK_INCLUDE_DIR}
    ${DirectXTex_INCLUDE_DIR}
    ${Effects11_INCLUDE_DIR}
)

# Preprocessor definitions
target_compile_definitions(FbxModelMonitor PRIVATE
    WIN32
    _WINDOWS
    UNICODE
    _UNICODE
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# Compiler options
target_compile_options(FbxModelMonitor PRIVATE
    /W3
    /Zi
    /Zm132
    $<$<CONFIG:Debug>:/Od>
    $<$<CONFIG:Debug>:/RTC1>
    $<$<CONFIG:Release>:/O2>
    $<$<CONFIG:Release>:/Oi>
)

# Set precompiled header
target_precompile_headers(FbxModelMonitor PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/stdafx.h"
)

# Use MFC as a shared DLL
set_target_properties(FbxModelMonitor PROPERTIES
    MFC_FLAG 2  # 1 = static, 2 = shared
    FOLDER "Applications"
)

# Linker settings
set_target_properties(FbxModelMonitor PROPERTIES
    LINK_FLAGS "/SUBSYSTEM:WINDOWS"
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/bin/${CMAKE_GENERATOR_PLATFORM}/$<CONFIG>"
)

# Link libraries - order matters!
target_link_libraries(FbxModelMonitor PRIVATE
    SharedUtility
    MyWpfGraphLibMfc
    ${FBXSDK_LIBRARIES}
    ${DirectXTK_LIBRARIES}
    ${DirectXTex_LIBRARIES}
    ${Effects11_LIBRARIES}
    ${DIRECTX_LIBRARIES}
    winmm.lib
    comctl32.lib
)

# Install targets
install(TARGETS FbxModelMonitor
    RUNTIME DESTINATION bin
)

# Copy DLLs to output directory for debugging
# This includes FBX SDK DLLs and any other runtime dependencies
add_custom_command(TARGET FbxModelMonitor POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Build completed. Remember to copy necessary DLLs to the output directory."
    COMMENT "Post-build reminder for DLL dependencies"
)
