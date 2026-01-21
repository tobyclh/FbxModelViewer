# Quick Start Guide - Building with CMake

This is a simplified guide to get you building quickly with CMake.

## Prerequisites Checklist

### Minimal Setup (Automatic Dependency Fetching - RECOMMENDED)

- [ ] CMake 3.15+ installed
- [ ] Visual Studio 2015 (or newer with v140 toolset)
- [ ] Windows SDK 8.1+
- [ ] FBX SDK 2020.3.2 installed
- [ ] Git installed (for fetching dependencies)
- [ ] Internet connection (for first build only)

**That's it!** DirectXTK, DirectXTex, and Effects11 will be automatically downloaded and built by CMake.

### Manual Setup (Traditional Method)

- [ ] CMake 3.15+ installed
- [ ] Visual Studio 2015 (or newer with v140 toolset)
- [ ] Windows SDK 8.1+
- [ ] FBX SDK 2020.3.2 installed
- [ ] DirectXTK built and available
- [ ] DirectXTex built and available
- [ ] Compact Effects11 built and available
- [ ] DDSTextureLoader files copied to SharedUtility/DDSTextureLoader/

## Quick Build (Windows)

### Method 1: Using the Build Script (Easiest)

Just run the provided batch file:

```cmd
build_cmake.bat
```

Follow the prompts to select:
1. Platform (Win32 or x64)
2. Configuration (Debug, Release, or both)
3. Visual Studio version

**Note:** On first build, CMake will automatically download DirectXTK, DirectXTex, and Effects11 from GitHub. This may take a few minutes.

### Method 2: Manual CMake Commands (Automatic Dependencies)

For **x64 Release** build with automatic dependency fetching:

```cmd
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -A x64 ..
cmake --build . --config Release
```

For **Win32 Debug** build:

```cmd
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -A Win32 ..
cmake --build . --config Debug
```

**First build will be slower** as CMake downloads and builds DirectXTK, DirectXTex, and Effects11. Subsequent builds will be much faster.

### Method 3: Manual Dependencies (Advanced)

If you prefer to manage dependencies manually:

```cmd
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -A x64 -DFETCH_DEPENDENCIES=OFF ..
cmake --build . --config Release
```

This requires you to have DirectXTK, DirectXTex, and Effects11 pre-built and their paths configured.

## Setting Up Dependencies

### Option 1: Automatic (Recommended - No Setup Required!)

**Default behavior:** CMake will automatically download and build DirectXTK, DirectXTex, and Effects11.

You **only** need to install:
- **FBX SDK** from Autodesk (must be manually installed)

Set this environment variable (or install to default location):
```cmd
setx FBXSDK_ROOT "C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2"
```

**That's all!** DirectXTK, DirectXTex, and Effects11 are fetched automatically.

### Option 2: Manual Environment Variables (Advanced)

Only needed if you disable automatic fetching (`-DFETCH_DEPENDENCIES=OFF`):

```cmd
setx FBXSDK_ROOT "C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2"
setx DIRECTXTK_ROOT "C:\path\to\DirectXTK"
setx DIRECTXTEX_ROOT "C:\path\to\DirectXTex"
setx EFFECTS11_ROOT "C:\path\to\CompactEffects11"
```

**Important:** Restart your terminal/IDE after setting environment variables!

### Option 3: Standard Locations (Advanced)

Only needed if you disable automatic fetching. Place dependencies in:
- FBX SDK: `C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2`
- DirectXTK: `C:\DirectXTK`
- DirectXTex: `C:\DirectXTex`
- Effects11: `C:\CompactEffects11`

## After Building

### Copy Required DLLs

Copy these DLLs to your output directory (e.g., `build/bin/x64/Release/`):

1. **libfbxsdk.dll**
   - From: `C:\Program Files\Autodesk\FBX\FBX SDK\2020.3.2\lib\vs2015\x64\release\`
   - To: Your output directory

2. **MyWpfGraphLibrary.dll** (optional, for WPF features)
   - Build the C# project first
   - Copy to output directory

## Verify Your Build

Check that the executable was created:
```cmd
dir build\bin\x64\Release\FbxModelMonitor.exe
```

Or for Debug:
```cmd
dir build\bin\x64\Debug\FbxModelMonitor.exe
```

## Common Issues

### "CMake Error: Could not find FBXSDK"
- Verify FBX SDK is installed
- Check FBXSDK_ROOT environment variable
- Restart your terminal

### "CMake Error: Could not find DirectXTK/DirectXTex/Effects11"
- Make sure you've built these libraries first
- Check environment variables
- Verify both Debug and Release configs are built

### "Missing DDSTextureLoader.h"
- **With automatic fetching:** This is handled automatically! CMake copies the files during configuration.
- **With manual dependencies:** Copy files from DirectXTK or DirectXTex to `SharedUtility/DDSTextureLoader/`

## Next Steps

For detailed information, see:
- [README_CMAKE.md](README_CMAKE.md) - Complete CMake build documentation
- [README.md](README.md) - Original project documentation

## Building Dependencies

### Automatic Method (Recommended)

**You don't need to do anything!** CMake handles this automatically.

When you run CMake for the first time, it will:
1. Download DirectXTK from GitHub
2. Download DirectXTex from GitHub
3. Download CompactEffects11 from GitHub
4. Build all three libraries automatically
5. Copy DDSTextureLoader files to the correct location

This happens only once. Subsequent builds reuse the already-built dependencies.

### Manual Method (Only if FETCH_DEPENDENCIES=OFF)

If you've disabled automatic fetching, build manually:

#### DirectXTK
```cmd
git clone https://github.com/microsoft/DirectXTK.git
cd DirectXTK
# Open DirectXTK_Desktop_2015.sln in Visual Studio
# Build for Win32 and x64, Debug and Release
```

#### DirectXTex
```cmd
git clone https://github.com/microsoft/DirectXTex.git
cd DirectXTex
# Open DirectXTex_Desktop_2015.sln in Visual Studio
# Build for Win32 and x64, Debug and Release
```

#### Compact Effects11
```cmd
git clone https://github.com/sygh-JP/CompactEffects11.git
cd CompactEffects11
# Open Effects11_2015.sln in Visual Studio
# Build for Win32 and x64, Debug and Release
```

**Remember:** Build all dependencies for the same platform and configuration you plan to use for FbxModelViewer!
