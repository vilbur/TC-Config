#SingleInstance force

#Include %A_LineFile%\..\..\..\..\TcCore.ahk
#Include %A_LineFile%\..\..\TcTabsGetter.ahk

$TcTabsGetter 	:= new TcTabsGetter()

Dump($TcTabsGetter.getTabs(), "TcTabsGetter.getTabs()", 1)
Dump($TcTabsGetter.getTabs("left"), "TcTabsGetter.getTabs('left')", 1)
Dump($TcTabsGetter.getTabs("right"), "TcTabsGetter.getTabs('right')", 1)