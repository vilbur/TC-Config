#SingleInstance force

#Include %A_LineFile%\..\..\..\TcPane.ahk

$TcPane 	:= new TcPane()
$TcTabs 	:= $TcPane.TcTabs()

;$TcTabs.getTabs("left")

;Dump($TcTabs.getTabs("left"), "TcTabs.getTabs('left')", 1)
Dump($TcTabs.getTabs("right"), "TcTabs.getTabs('right')", 1)
