#SingleInstance force

#Include %A_LineFile%\..\..\..\..\TcCore.ahk
#Include %A_LineFile%\..\..\TcTabsLoader.ahk
#Include %A_LineFile%\..\..\..\..\TcPane\TcPane.ahk

$TcTabsLoader 	:= new TcTabsLoader()
$tab_file_path 	:= A_ScriptDir "\test-both-sides.tab"


/* Load to active pane
*/
$TcTabsLoader.load( $tab_file_path )

/* Load active pane to left
*/
;sleep, 2000
;$TcTabsLoader.load( $tab_file_path, "left")

/* Load active pane to right
*/
;sleep, 2000
;$TcTabsLoader.load( $tab_file_path, "right")