# MyWpfGraphLibMfc - C++/CLI wrapper library for WPF components
project(MyWpfGraphLibMfc)

# Note: This is a C++/CLI project that bridges native C++ and .NET WPF
# CMake support for C++/CLI is limited. This configuration may need
# manual adjustments or building through Visual Studio for full functionality.

# Collect source files
file(GLOB MYWPFGRAPHLIBMFC_SOURCES
    "*.cpp"
)

file(GLOB MYWPFGRAPHLIBMFC_HEADERS
    "*.h"
    "*.hpp"
)

file(GLOB MYWPFGRAPHLIBMFC_WRAPPERS_SOURCES
    "Wrappers/*.cpp"
)

file(GLOB MYWPFGRAPHLIBMFC_WRAPPERS_HEADERS
    "Wrappers/*.hpp"
)

# Create shared library (DLL)
add_library(MyWpfGraphLibMfc SHARED
    ${MYWPFGRAPHLIBMFC_SOURCES}
    ${MYWPFGRAPHLIBMFC_HEADERS}
    ${MYWPFGRAPHLIBMFC_WRAPPERS_SOURCES}
    ${MYWPFGRAPHLIBMFC_WRAPPERS_HEADERS}
    MyWpfGraphLibMfc.rc
)

# Include directories
target_include_directories(MyWpfGraphLibMfc PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/Wrappers
)

# Preprocessor definitions
target_compile_definitions(MyWpfGraphLibMfc PRIVATE
    WIN32
    _WINDOWS
    _AFXEXT
    UNICODE
    _UNICODE
    $<$<CONFIG:Debug>:_DEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# Enable C++/CLI support (requires special handling)
# This sets the /clr flag for C++/CLI compilation
set_target_properties(MyWpfGraphLibMfc PROPERTIES
    COMMON_LANGUAGE_RUNTIME "netcore"  # or "" for older .NET Framework
    VS_DOTNET_TARGET_FRAMEWORK_VERSION "v4.5.2"
    FOLDER "Libraries"
)

# For files that should NOT be compiled as managed code
set_source_files_properties(
    dllmain.cpp
    PROPERTIES
    COMPILE_FLAGS "/clr-"
)

# Compiler options
target_compile_options(MyWpfGraphLibMfc PRIVATE
    /W3
    /Zi
    $<$<CONFIG:Debug>:/Od>
    $<$<CONFIG:Release>:/O2>
    $<$<CONFIG:Release>:/Oi>
)

# Set precompiled header
target_precompile_headers(MyWpfGraphLibMfc PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/stdafx.h"
)

# Use MFC as a shared DLL
set_target_properties(MyWpfGraphLibMfc PROPERTIES
    MFC_FLAG 2  # 1 = static, 2 = shared
)

# Module definition file
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/MyWpfGraphLibMfc.def")
    target_sources(MyWpfGraphLibMfc PRIVATE MyWpfGraphLibMfc.def)
endif()

# .NET references - these need to be added for C++/CLI projects
# Note: CMake's native support for this is limited
set_property(TARGET MyWpfGraphLibMfc PROPERTY VS_DOTNET_REFERENCES
    "PresentationCore"
    "PresentationFramework"
    "System"
    "System.Xaml"
    "WindowsBase"
)

# Link dependencies
# Note: The C# project MyWpfGraphLibrary would need to be built first
# and its DLL referenced here
target_link_libraries(MyWpfGraphLibMfc PRIVATE
)

# Install targets
install(TARGETS MyWpfGraphLibMfc
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

# Note: Building C++/CLI projects with CMake has limitations.
# For production builds, consider using MSBuild or Visual Studio directly
# for the MyWpfGraphLibMfc and MyWpfGraphLibrary projects.
