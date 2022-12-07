#SingleInstance force

#Include %A_LineFile%\..\..\TcButtonBarButton.ahk

#Include %A_LineFile%\..\..\..\..\TcCommanderPath\TcCommanderPath.ahk
#Include %A_LineFile%\..\..\..\Test\Helpers\userCommandHelpers.ahk

$usercmd_ini	= %Commander_Path%\usercmd.ini

/** Button types
*/
$Separator      := new TcButtonBarButton()

$Button_empty   := new TcButtonBarButton().empty()

$Custom_command := new TcButtonBarButton($usercmd_ini).loadCommand( "em_TestTcButtonBar" )

$Button         := new TcButtonBarButton().cmd( "foo.bat" )
                                          .icon("%systemroot%\system32\shell32.dll", 43)
                                          .tooltip("Tooltip test")

;Dump($Separator, "Separator", 1)
;Dump($Button, "Button", 1)			
;Dump($Custom_command, "Custom_command", 1)			
;Dump($Button_empty, "Button_empty", 1)