;#NoTrayIcon
#SingleInstance force

#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk
#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcPane\TcPane.ahk
#Include %A_LineFile%\..\..\_Ahk-Lib\File\File.ahk

$TcPane	:= new TcPane()
$selection	:= new TcSelection().getSelectionOrFocused()
$target_path	:= $TcPane.getPath("target")
$target_path	= %$target_path%\

if( ! isObject($selection) )
	$selection := [$selection]

For $i, $path_source in $selection
{
	;Dump($path_source, "path_source", 1)
	;Dump($target_path, "target_path", 1)
	;;; /* Create hardlink, backuped and quiet */
	MsgBox, 4, WOULD YOU LIKE TO CREATE HARDLINK ?, Source:`n%$path_source% `n`nTarget:`n%$target_path% 
	IfMsgBox, Yes
	
		File($path_source).hardlink($target_path)
}

sleep 500
$TcPane.refresh("target")