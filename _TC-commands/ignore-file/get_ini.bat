@setlocal enableextensions enabledelayedexpansion
@echo off
::http://stackoverflow.com/questions/2866117/read-ini-from-windows-batch-file
::
:: HOW TO RUN
:: get_ini.bat file.ini SectionName  total
::
:: HOW GET RESULT IN BATCH
:: FOR /F "tokens=*" %%i IN ('c:\GoogleDrive\TotalComander\_commands\tc_selections\get_ini.bat c:\GoogleDrive\TotalComander\wincmd.ini Configuration IgnoreListFile') DO set "ini_value=%%i"
:: echo ini_value:%ini_value%



set file=%~1
set area=[%~2]
set key=%~3
set currarea=
for /f "usebackq delims=" %%a in ("!file!") do (
    set ln=%%a
    if "x!ln:~0,1!"=="x[" (
        set currarea=!ln!
    ) else (
        for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
            set currkey=%%b
            set currval=%%c
            if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
                echo !currval!
            )
        )
    )
)
endlocal


