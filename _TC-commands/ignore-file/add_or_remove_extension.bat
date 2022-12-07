@echo off

set "sourcePath=%~1"
set "selectedFile=%~2"
set "mode=%~3"
set "ignore_file=%~4"

rem echo sourcePath:%sourcePath%
rem echo selectedFile:%selectedFile%
rem echo ignore_file:%ignore_file%
rem pause

IF [%ignore_file%]==[] set "ignore_file=default"

set sourcePath=%sourcePath:~0,-1%
set "batch_path=%~dp0"
set "ignoreFile=%Commander_Path%\_ignore_file\%ignore_file%.txt"

REM set "%path_tcmc%=%Commander_Path%\TCMC\TCMC.exe"
set "fart=%batch_path%\fart.exe"


::FOR EVERY FILE OR FOLDER
set t=%selectedFile%
:loop
for /F "tokens=1*" %%a in ("%t%") do (
    call :fileOrFolder %%a
	set t=%%b
)

if defined t goto :loop
goto :TURN_IGNORE_FILE_ON


::TEST IF FILE OR FOLDER
:fileOrFolder
rem echo --- file Or Folder

FOR /f %%F IN ("%~1") DO (
    IF NOT [%%~xF]==[] call :file %%~xF
    IF     [%%~xF]==[] call :folder %~1
)
goto :eof

::MAKE FILE HARD LINK
:file
IF %mode%==add (
    echo *%1>>%ignoreFile%
) else (
    %fart% "%ignoreFile%" "*%1" " "
    :remove_empty_lines
    findstr /v /r /c:"^$" /c:"^\ *$" "%ignoreFile%">>"%ignoreFile%.remove"
    move /y "%ignoreFile%.remove" "%ignoreFile%"
)


goto :eof



::MAKE FOLDER HARD LINK
:folder
goto :eof


:TURN_IGNORE_FILE_ON
::TURN OFF IGNORE LIST IF IT IS ON
findstr /B "IgnoreListFileEnabled=1" %Commander_Path%\wincmd.ini
if %errorlevel%==0 (
    echo ignore is ON
    %path_tcmc% 200 CM2922
)
rem ::TURN IGNORE LIST ON
%path_tcmc% 200 CM2922


:exit
exit
