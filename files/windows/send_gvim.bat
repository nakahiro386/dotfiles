@ECHO OFF
SETLOCAL

REM gvim‚ÅŠJ‚­

:loop

if "%~f1" == "" goto end

SET ARG="%~f1"
SET ARG=%ARG:\(=\\(%
SET ARGS=%ARGS% %ARG%

shift

goto loop
:end

start "" /D %home% gvim.exe --literal --remote-tab-silent %ARGS%


ENDLOCAL
EXIT /B 0
REM vim:ft=dosbatch fenc=cp932 ff=dos
