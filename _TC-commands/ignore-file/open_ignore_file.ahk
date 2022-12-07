/*
  Find path to ignore file in wincmd.ini
  and open it in totepad +++
*/

$iniFile = %Commander_Path%\wincmd.ini
$notepad = notepad++.exe

ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, int, 1999, "Cdecl int")
	return dest
}

;;;LOOP INI FILE
Loop, Read, %$iniFile%
{
    ;;;FIND LINE WHERE PATH TO IGNORE FILE
    RegExMatch( A_LoopReadLine , "IgnoreListFile=(.*)", $match )
    if %$match%
    {
        $cmd := $notepad " """ ExpandEnvVars($match1)  """"
        Run, %$cmd%
    }

}