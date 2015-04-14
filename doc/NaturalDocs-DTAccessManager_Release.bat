@echo off

set NaturalDocsParams= -i F:\Pro\ACCESS-MANAGER\Release\DTAccessManager\src -o FramedHTML F:\Pro\ACCESS-MANAGER\Release\doc -p F:\Pro\ACCESS-MANAGER\Release\doc\projectDoc

rem Shift and loop so we can get more than nine parameters.
rem This is especially important if we have spaces in file names.

:MORE
if "%1"=="" goto NOMORE
set NaturalDocsParams=%NaturalDocsParams% %1
shift
goto MORE
:NOMORE

C:\Perl\bin\perl.exe NaturalDocs %NaturalDocsParams%

PAUSE