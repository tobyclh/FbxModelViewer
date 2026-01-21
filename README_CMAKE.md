# Building FbxModelViewer with CMake

This document describes how to build the FbxModelViewer project using CMake.

## New Feature: Automatic Dependency Fetching

**Good news!** CMake now automatically downloads and builds DirectXTK, DirectXTex, and Effects11 for you. You only need to manually install the FBX SDK.

## Prerequisites

### Required Software

1. **CMake** (version 3.15 or higher)
   - Download from: https://cmake.org/download/

2. **Visual Studio 2015 Update 3** or compatible compiler
   - The project is configured for Visual Studio 2015 (v140 toolset)
   - Visual Studio 2017/2019/2022 can also be used with the v140 toolset installed

3. **Windows SDK 8.1** or higher
   - Includes DirectX 11.1, Direct2D, DirectWrite

4. **Git** (for automatic dependency fetching)
   - Download from: https://git-scm.com/download/win
   - Only needed if using automatic dependency fetching (default)

### Required Dependencies

#### Option A: Automatic Dependency Fetching (Recommended - Default)

**Only manually install:**

1. **Autodesk FBX SDK 2020.3.2** (or compatible version)
   - Download from: https://www.autodesk.com/products/fbx/overview
   - Install to default location: `C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2`
   - Or set environment variable: `FBXSDK_ROOT` to your installation path

**Automatically fetched by CMake:**
- DirectXTK (from GitHub)
- DirectXTex (from GitHub)
- Compact Effects11 (from GitHub)
- DDSTextureLoader files (automatically copied)

When you run CMake, these dependencies will be automatically downloaded from GitHub and built as part of your project. This happens only once; subsequent builds will reuse the already-fetched dependencies.

#### Option B: Manual Dependency Management (Advanced)

To disable automatic fetching and use manually built dependencies:

```cmd
cmake -DFETCH_DEPENDENCIES=OFF ..
```

Then you need to build and install the following dependencies:

1. **Autodesk FBX SDK 2020.3.2** (or compatible version)
   - Download from: https://www.autodesk.com/products/fbx/overview
   - Install to default location: `C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2`
   - Or set environment variable: `FBXSDK_ROOT` to your installation path

2. **DirectXTK** (DirectX Tool Kit) - 2016-04-26 version or compatible
   - Clone from: https://github.com/microsoft/DirectXTK
   - Build the library for your platform (Win32/x64) in both Debug and Release configurations
   - Set environment variable: `DIRECTXTK_ROOT` to the cloned directory

3. **DirectXTex** - 2016-04-26 version or compatible
   - Clone from: https://github.com/microsoft/DirectXTex
   - Build the library for your platform (Win32/x64) in both Debug and Release configurations
   - Set environment variable: `DIRECTXTEX_ROOT` to the cloned directory

4. **Compact Effects11** (or Effects11)
   - Clone from: https://github.com/sygh-JP/CompactEffects11
   - Or use the original: https://github.com/Microsoft/FX11
   - Build the library for your platform (Win32/x64) in both Debug and Release configurations
   - Set environment variable: `EFFECTS11_ROOT` to the cloned directory

5. **Copy DDSTextureLoader files**
   - From DirectXTK or DirectXTex, copy `DDSTextureLoader.h` and `DDSTextureLoader.cpp`
   - Place them in: `SharedUtility/DDSTextureLoader/`

### Setting Up Environment Variables

#### With Automatic Dependency Fetching (Default)

You only need to set the FBX SDK location:

```cmd
setx FBXSDK_ROOT "C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2"
```

Or install FBX SDK to the default location and CMake will find it automatically.

#### With Manual Dependencies (FETCH_DEPENDENCIES=OFF)

Set all environment variables:

```cmd
setx FBXSDK_ROOT "C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2"
setx DIRECTXTK_ROOT "C:\path\to\DirectXTK"
setx DIRECTXTEX_ROOT "C:\path\to\DirectXTex"
setx EFFECTS11_ROOT "C:\path\to\CompactEffects11"
```

Alternatively, you can place the dependencies in standard locations:
- `C:\DirectXTK`
- `C:\DirectXTex`
- `C:\CompactEffects11` or `C:\Effects11`

## Building with CMake

### Option 1: Using CMake GUI

1. Open CMake GUI
2. Set "Where is the source code" to the FbxModelViewer directory
3. Set "Where to build the binaries" to `FbxModelViewer/build` (or any directory)
4. Click "Configure"
5. Select your generator (e.g., "Visual Studio 14 2015")
6. Select platform (Win32 or x64)
7. **First build only:** Wait while CMake downloads DirectXTK, DirectXTex, and Effects11 from GitHub (this may take a few minutes)
8. Click "Generate"
9. Click "Open Project" to open in Visual Studio
10. Build the solution in Visual Studio

**Note:** To disable automatic dependency fetching, set `FETCH_DEPENDENCIES` to `OFF` in CMake GUI before configuring.

### Option 2: Using Command Line (Automatic Dependencies)

#### For x64 build:

```cmd
cd FbxModelViewer
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -A x64 ..
cmake --build . --config Release
```

**First build will download and build dependencies from GitHub.**

#### For Win32 build:

```cmd
cd FbxModelViewer
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -A Win32 ..
cmake --build . --config Release
```

#### To disable automatic fetching:

```cmd
cmake -G "Visual Studio 14 2015" -A x64 -DFETCH_DEPENDENCIES=OFF ..
```

### Option 3: Using Newer Visual Studio Versions

If you have Visual Studio 2019 or 2022, you can use them with the v140 toolset:

```cmd
cmake -G "Visual Studio 16 2019" -A x64 -T v140 ..
# or
cmake -G "Visual Studio 17 2022" -A x64 -T v140 ..
```

## Build Output

After a successful build, the executables and libraries will be in:
```
build/bin/<Platform>/<Configuration>/
```

For example:
- `build/bin/x64/Release/FbxModelMonitor.exe`
- `build/bin/Win32/Debug/FbxModelMonitor.exe`

## Post-Build Steps

### Copy Required DLLs

You need to copy runtime DLLs to the executable directory:

1. **FBX SDK DLLs**:
   - Copy `libfbxsdk.dll` from FBX SDK installation to the output directory
   - Location: `C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2\lib\vs2015\x64\release\`

2. **MyWpfGraphLibrary.dll** and dependencies (if using WPF components):
   - Build the C# project `MyWpfGraphLibrary.csproj` separately
   - Copy the resulting DLL to the output directory

You can use the F# script for copying DLLs:
```cmd
fsi FSharpUtilScripts/copy_dlls_for_exes.fsx
```

## Known Limitations

### C++/CLI and WPF Projects

The `MyWpfGraphLibMfc` project uses C++/CLI to bridge native C++ and .NET WPF components. CMake's support for C++/CLI is limited, and this part of the build may not work perfectly with CMake alone.

For full functionality:
1. Build the main C++ projects (SharedUtility, FbxModelMonitor) with CMake
2. Build the WPF/C++/CLI projects (MyWpfGraphLibrary, MyWpfGraphLibMfc) using Visual Studio or MSBuild directly

Or use the original Visual Studio solution file (`FbxModelViewer.sln`) for a complete build.

## Troubleshooting

### CMake cannot find dependencies

- Make sure environment variables are set correctly
- Restart your terminal/CMake GUI after setting environment variables
- Check that the dependencies are built for the correct platform (Win32 vs x64)
- Verify that both Debug and Release configurations are built for dependencies

### Link errors

- Ensure all dependencies are built with the same toolset (v140)
- Check that you're building for the correct platform (Win32 vs x64)
- Verify that the runtime library settings match (/MD vs /MT)

### Missing d3dx11effect.h

- Make sure you've built Compact Effects11 or Effects11
- Set the EFFECTS11_ROOT environment variable
- Check that the Inc directory exists in your Effects11 build

### Missing DDSTextureLoader files

- **With automatic fetching (default):** CMake automatically copies these files during configuration
- **With manual dependencies:** Copy `DDSTextureLoader.h` and `DDSTextureLoader.cpp` from DirectXTK or DirectXTex to `SharedUtility/DDSTextureLoader/`

## Alternative: Building with Visual Studio Solution

If you encounter issues with CMake, you can still use the original Visual Studio solution:

1. Set up the global include and library directories in Visual Studio
2. Open `FbxModelViewer.sln`
3. Build the solution

See the original [README.md](README.md) for detailed instructions.

## Additional Resources

- Original Project README: [README.md](README.md)
- CMake Documentation: https://cmake.org/documentation/
- DirectXTK Wiki: https://github.com/microsoft/DirectXTK/wiki
- FBX SDK Documentation: https://help.autodesk.com/view/FBX/2020/ENU/

## License

See [LICENSE.txt](LICENSE.txt) for license information.
