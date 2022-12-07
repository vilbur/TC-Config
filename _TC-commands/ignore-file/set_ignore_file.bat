@echo off
::http://stackoverflow.com/questions/2866117/read-ini-from-windows-batch-file
::
:: HOW TO RUN
:: get_ini.bat file.ini SectionName  total
::
:: HOW GET RESULT IN BATCH
:: FOR /F "tokens=*" %%i IN ('c:\GoogleDrive\TotalComander\_commands\tc_selections\get_ini.bat c:\GoogleDrive\TotalComander\wincmd.ini Configuration IgnoreListFile') DO set "ini_value=%%i"
:: echo ini_value:%ini_value%

set "ignore_file=%~1"
IF [%ignore_file%]==[] set "ignore_file=default"


set "tc_ini=%Commander_Path%\wincmd.ini"
set "ignoreFile=%Commander_Path%\_ignore_file\%ignore_file%.txt"
set "batch_path=%~dp0"
rem set "selectionFile=%Commander_Path%\_tc_selections\%mode%.tcsel"

set "%path_tcmc%=%Commander_Path%\_Extensions\TCMC\TCMC.exe"
set "fart=%batch_path%\fart.exe"


:EXIT
::TURN OFF IGNORE LIST IF IT IS ON
findstr /B "IgnoreListFileEnabled=1" %Commander_Path%\wincmd.ini
if %errorlevel%==0 (
    echo ignore is ON
    %path_tcmc% 200 CM2922
)
::get current ignore file from ini
FOR /F "tokens=*" %%i IN ('%batch_path%\get_ini.bat %tc_ini% Configuration IgnoreListFile') DO set "ini_value=%%i"
:: find and replace current IgnoreListFile with custom
%fart% "%tc_ini%" IgnoreListFile=%ini_value% IgnoreListFile=%ignoreFile%
rem ::TURN IGNORE LIST ON
%path_tcmc% 200 CM2922
