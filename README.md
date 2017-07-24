# vcbuild.bat

**NOTE: THIS PROJECT IS WORKING IN PROGRESS**

Build and debug script for Windows C++ application without launching heavy Visual Studio IDE.

Good for very small program or examine code snippet on lovely lightweight cmd.exe.

## Prerequisuites

- Visual Studio 2017 (Tested on free Community edition)
  - Windows Universal CRT SDK
  - Windows SDK 8.1
- OR, Visual Studio 2015 (Tested on free Community edition)

And, if use debugger, `windbg` must be on your `PATH`.

## Usage

The following script will compile `test.cpp` into `test.exe` and run
debugger(`windbg`) with breakpoints `test.cpp:81 `test.cpp:32`.

```batchfile
set VCBUILD_INPUT=test.cpp
set VCBUILD_OUTPUT=test.exe
vcbuild.bat execute 81 32
```

You can also build as release with/without specified target platform. (default is `x64`)

```batchfile
set VCBUILD_PLATFORM=x86
vcbuild.bat release
```

Of course, can automatically run after release build (without debugger) as following:

```batchfile
vcbuild.bat release execute
```

## License

CC0 v1.0 License

No rights reserved
