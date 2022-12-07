#SingleInstance force

/** Restart Total commander 
  */

WinGet, $tc_exe, ProcessName, ahk_class TTOTAL_CMD

IfWinExist, % "ahk_exe " $tc_exe
	WinClose , % "ahk_exe " $tc_exe

Run *RunAs %Commander_Path%\%$tc_exe%

exitApp