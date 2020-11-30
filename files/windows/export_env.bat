@ECHO OFF
REM 環境変数のバックアップ
SETLOCAL

SET DATESTRING=%date:~-10,4%%date:~-5,2%%date:~-2,2%_%time:~0,2%%time:~3,2%
SET DATESTRING=%DATESTRING: =0%
IF "%~1" == "" (
    SET BACKUPFILE=%~dp0environmet_%DATESTRING%.txt
) ELSE (
    SET BACKUPFILE=%~1
)

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /s /z > "%BACKUPFILE%"
reg query "HKEY_CURRENT_USER\Environment" /s /z >> "%BACKUPFILE%"

EXIT /B %ERRORLEVEL%

REM vim:ft=dosbatch fenc=cp932 ff=dos
