set build=%1
if "%2" == "static" (
  set makefile=ms\nt.mak
) else (
  set makefile=ms\ntdll.mak
)

perl Configure no-asm no-hw no-dso VC-WINUNIVERSAL -FS -FIWindows.h

for /D %%f in ("%WindowsSdkDir%References\%WindowsSDKLibVersion%Windows.Foundation.FoundationContract\*") do set LibPath=%LibPath%;%%f\
for /D %%f in ("%WindowsSdkDir%References\%WindowsSDKLibVersion%Windows.Foundation.UniversalApiContract\*") do set LibPath=%LibPath%;%%f\

call ms\do_winuniversal.bat

mkdir inc32\openssl

jom -j %NUMBER_OF_PROCESSORS% -k -f %makefile%
REM due to a race condition in the build, we need to have a second single-threaded pass.
nmake -f %makefile%

