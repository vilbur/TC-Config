#SingleInstance force

#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk
#Include %A_LineFile%\..\..\_Ahk-Lib\Ini\INI.ahk
#Include %A_LineFile%\..\..\_Ahk-Lib\File\Path\Path.ahk


$file_list	:= new TcSelection().getSelectionOrFocused()
$INI	:= INI()


Loop % $file_list.Length(){

    $file_path	:= % $file_list[A_Index]
    SplitPath, $file_path,,, $ext

    ;;; get program name by extension from ini
	$TC_edit_program	:= $INI.get( "TC_edit_program", $ext )

    ;;; get program file_path by program_name from ini
    if($TC_edit_program!="" )
		$edit_program_path	:= Path($INI.get( "paths", $TC_edit_program )).getPath()
	;Dump($edit_program_path, "edit_program_path", 1)

	;;; GET DEFAULT Notepad++ file_path if edit program for extension is not defined, or does not exists
    If ( !FileExist( $edit_program_path ) )
        $edit_program_path := $INI.get( "paths", "notepad++" )

	$edit_program_path := Path($edit_program_path).getPath()

	;MsgBox,262144,edit_program_path, %$edit_program_path%,3
    Run, %$edit_program_path% "%$file_path%"
	sleep, 200

}

ExitApp
