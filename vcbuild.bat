@echo off
setlocal enabledelayedexpansion

if not defined VCBUILD_INPUT (
  echo [31mVCBUILD_INPUT is mandatory.[0m
  goto end
)
if not defined VCBUILD_OUTPUT (
  echo [31mVCBUILD_OUTPUT is mandatory.[0m
  goto end 
)
if not defined VCBUILD_PLATFORM set VCBUILD_PLATFORM=x64
if not defined VCBUILD_FRAMEWORK set VCBUILD_FRAMEWORK=8.1

set vs2015_vcvarsall=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat
set vs2017_vcvarsall=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat

if exist "%vs2017_vcvarsall%" goto vs2017
if exist "%vs2015_vcvarsall%" goto vs2015
echo [31mVisual Studio 2017 or 2015 is not found on this machine.[0m
goto end

:vs2015
  set vcvarsall=%vs2015_vcvarsall%
  goto build
:vs2017
  set vcvarsall=%vs2017_vcvarsall%
  goto build
:build

  :argloop
  if "%1" neq "" (
    set /a peeknr=%1
    if "%1" equ "release" set release=1
    if "%1" equ "execute" set execute=1
    if !peeknr! gtr 0 set breakpoints=!breakpoints!bp `%VCBUILD_INPUT%:!peeknr!`^;
    echo %1
    shift /1
    goto argloop
  )

  echo [35m VCBUILD_INPUT     :[0m !VCBUILD_INPUT!
  echo [35m VCBUILD_OUTPUT    :[0m !VCBUILD_OUTPUT!
  echo [35m VCBUILD_PLATFORM  :[0m !VCBUILD_PLATFORM!
  echo [35m VCBUILD_FRAMEWORK :[0m !VCBUILD_FRAMEWORK!

  call "!vcvarsall!" %VCBUILD_PLATFORM% %VCBUILD_FRAMEWORK%
  if defined release (
    echo [32mBuild as release mode[0m
    cl /EHsc /Fe:"%VCBUILD_OUTPUT%" %VCBUILD_INPUT%
  ) else (
    echo [32mBuild as debug mode[0m
    cl /EHsc /Zi /DEBUG /Fe:"%VCBUILD_OUTPUT%" %VCBUILD_INPUT%
  )
  
  set CL_ERRORLEVEL=!ERRORLEVEL!
  if not "!CL_ERRORLEVEL!"=="0" (
    echo CL has exited with code !CL_ERRORLEVEL!
    exit /b !CL_ERRORLEVEL!
  )
  if defined execute (
    if defined breakpoints (
      if defined release echo [33mWARNING^! Debugger may not effectivelly work with release binary.[0m
      windbg -c "!breakpoints!g" -y . -srcpath . %VCBUILD_OUTPUT%
    ) else (
      echo [33mWARNING^! No breakpoints specified, execute %VCBUILD_OUTPUT% directly...[0m
      .\%VCBUILD_OUTPUT%
    )
  )
:end
  endlocal
