@echo off
REM CMake Build Script for FbxModelViewer
REM This script helps automate the CMake build process

setlocal enabledelayedexpansion

echo ===============================================
echo FbxModelViewer CMake Build Script
echo ===============================================
echo.

REM Check if CMake is installed
where cmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: CMake not found in PATH
    echo Please install CMake from https://cmake.org/download/
    pause
    exit /b 1
)

REM Get platform choice
echo Select platform:
echo 1. Win32 (x86)
echo 2. x64
echo.
set /p PLATFORM_CHOICE="Enter choice (1 or 2): "

if "%PLATFORM_CHOICE%"=="1" (
    set PLATFORM=Win32
) else if "%PLATFORM_CHOICE%"=="2" (
    set PLATFORM=x64
) else (
    echo Invalid choice. Defaulting to x64.
    set PLATFORM=x64
)

REM Get build configuration
echo.
echo Select build configuration:
echo 1. Debug
echo 2. Release
echo 3. Both
echo.
set /p CONFIG_CHOICE="Enter choice (1, 2, or 3): "

if "%CONFIG_CHOICE%"=="1" (
    set BUILD_DEBUG=1
    set BUILD_RELEASE=0
) else if "%CONFIG_CHOICE%"=="2" (
    set BUILD_DEBUG=0
    set BUILD_RELEASE=1
) else if "%CONFIG_CHOICE%"=="3" (
    set BUILD_DEBUG=1
    set BUILD_RELEASE=1
) else (
    echo Invalid choice. Defaulting to Release only.
    set BUILD_DEBUG=0
    set BUILD_RELEASE=1
)

REM Get Visual Studio version
echo.
echo Select Visual Studio version:
echo 1. Visual Studio 2015 (v140)
echo 2. Visual Studio 2017 (v141) with v140 toolset
echo 3. Visual Studio 2019 (v142) with v140 toolset
echo 4. Visual Studio 2022 (v143) with v140 toolset
echo.
set /p VS_CHOICE="Enter choice (1-4): "

if "%VS_CHOICE%"=="1" (
    set GENERATOR=Visual Studio 14 2015
    set TOOLSET=
) else if "%VS_CHOICE%"=="2" (
    set GENERATOR=Visual Studio 15 2017
    set TOOLSET=-T v140
) else if "%VS_CHOICE%"=="3" (
    set GENERATOR=Visual Studio 16 2019
    set TOOLSET=-T v140
) else if "%VS_CHOICE%"=="4" (
    set GENERATOR=Visual Studio 17 2022
    set TOOLSET=-T v140
) else (
    echo Invalid choice. Defaulting to Visual Studio 2015.
    set GENERATOR=Visual Studio 14 2015
    set TOOLSET=
)

REM Create build directory
set BUILD_DIR=build_%PLATFORM%
echo.
echo Creating build directory: %BUILD_DIR%
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Run CMake configure
echo.
echo Running CMake configure...
cd "%BUILD_DIR%"

if "%VS_CHOICE%"=="1" (
    REM VS 2015 uses different syntax
    if "%PLATFORM%"=="Win32" (
        cmake -G "%GENERATOR%" %TOOLSET% ..
    ) else (
        cmake -G "%GENERATOR% Win64" %TOOLSET% ..
    )
) else (
    REM VS 2017 and later use -A flag
    cmake -G "%GENERATOR%" -A %PLATFORM% %TOOLSET% ..
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: CMake configuration failed!
    echo Please check that all dependencies are installed and environment variables are set.
    cd ..
    pause
    exit /b 1
)

REM Build
echo.
echo Building project...

if "%BUILD_DEBUG%"=="1" (
    echo Building Debug configuration...
    cmake --build . --config Debug
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Debug build failed!
        cd ..
        pause
        exit /b 1
    )
)

if "%BUILD_RELEASE%"=="1" (
    echo Building Release configuration...
    cmake --build . --config Release
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Release build failed!
        cd ..
        pause
        exit /b 1
    )
)

cd ..

echo.
echo ===============================================
echo Build completed successfully!
echo ===============================================
echo.
echo Output location:
if "%BUILD_DEBUG%"=="1" (
    echo   Debug:   %BUILD_DIR%\bin\%PLATFORM%\Debug\
)
if "%BUILD_RELEASE%"=="1" (
    echo   Release: %BUILD_DIR%\bin\%PLATFORM%\Release\
)
echo.
echo IMPORTANT: Remember to copy required DLLs to the output directory:
echo   1. libfbxsdk.dll from FBX SDK
echo   2. MyWpfGraphLibrary.dll (if using WPF features)
echo.
echo See README_CMAKE.md for more information.
echo.

pause
