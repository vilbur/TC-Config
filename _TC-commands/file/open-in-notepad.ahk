#NoTrayIcon
#SingleInstance force

#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk

/*
	All selected files in Total Commander will be opened in Notepad++
	
	@param string $close_others close other opened files IF NOT EMPTY
	
	@Example
		Open_in_notepad.ahk	; open selected files
		Open_in_notepad.ahk true	; open selected files and CLOSE OTHERS		
	
*/

$control_key	:= GetKeyState("control", "P") 
$file_list	:= new TcSelection().getSelectionOrFocused()

if ( $file_list.length() > 0 )
{

    ;;; CLOSE OPENED FILES
	if($control_key){
		Send, !f
		sleep, 50	
		Send, e
		sleep, 50
	}
    ;;; LOOP FILES AND OPEN IT
    For $key, $file in $file_list
		Run, % "Notepad++.exe " $file

}