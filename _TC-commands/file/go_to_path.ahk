;#NoTrayIcon
#SingleInstance force

#Include %A_LineFile%\..\..\_Ahk-Lib\File\Path\Path.ahk
#Include %A_LineFile%\..\..\_Ahk-Lib\Clip\Clip.ahk

/** Browse File In Total Commander
	PATH IS DEFINED IN PARAMETER, CLIPBOARD OR VIA SELECTED TEXT

	PRIORITY: 1. FILE DEFINED IN PARAMETER      E.G.: C:\\Go_to_file.ahk "C:\\foo.txt"
	PRIORITY: 2. FILE IN CLIPBOARD,             E.G.: path stroed in Ctrl+V
	PRIORITY: 3. FILE PATH SELECTED SOMEWHERE   E.G.: some selectedtext with cursor, in browser, program and otherwere

	@param string $file_path with double backslashes "c:\\FooDir\\File.exe"

*/
TC_goToFile($file_path:=""){

	if ( $file_path=="" ) {
		/**	Priorities for reaching of text
		   1 Get path from selected text
		   2 Get path from path_clipboard
		   3 Get path from window title
		*/
		 /* try get selected text
		 */
		$path_clipboard	:= Path(Clipboard).getPath()
		$path_selected	:= Path(Clip_Get()).getPath()

		/* try get path from path_clipboard, if path is not selected
		*/
		if FileExist($path_selected)
			$file_path := $path_selected
		else if FileExist($path_clipboard)
			$file_path := $path_clipboard

		/* try get path from program title, if path is not in clip
		*/
		if ($file_path==""){
			/* GET PaTH OF KOMODO FILE
			*/
			IfWinActive, ahk_exe komodo.exe
				$file_path := getKomodoFileFromTitle()
			else{
				/* TRY GET FILE PATH FROM OTEHRS PROGRAMS TITLES
				 */
				WinGetActiveTitle, $ActiveWinTitle
				RegExMatch( $ActiveWinTitle, "i)([A-Z]:(?:[\/\\][^\/\\]+)+\.\w+)", $path_match )
				$path_title := Path($path_match).getPath()
				if FileExist($path_title)
					$file_path := $path_title
			}
		}
	}

	WinGet, $process_name , ProcessName, ahk_class TTOTAL_CMD
	;MsgBox,262144,process_name, %$process_name%,3

	$commander_path	= %Commander_Path%\%$process_name%

	;MsgBox,262144,commander_path, %$commander_path%,3

	if FileExist($commander_path)
		Run, % $commander_path " /S /O """ $file_path """"
}


getKomodoFileFromTitle()
{
	WinGetTitle, $win_title, ahk_exe komodo.exe

	RegExMatch( $win_title, "(\S+)\**\s\(([^,)]+)", $file_path_match )
	RegExMatch( $win_title, "Project\s(\S+)", $project_match )

	if ( $file_path_match ){
		$filePath	 = %$file_path_match2%\%$file_path_match1%
		return $filePath
	}

	if ( $project_match )
		return $project_match1
}



$file_path = %1%
TC_goToFile($file_path)
exitApp
