/* Save\Load current selection
	Save if Control key is pressed, otherwise load

	@param string $selection_file
		3 modes of selection saved\load :
			$selection_file == "quick"	; quick selection to GLOBAL file
			$selection_file == "tcfile"	; current folder to file ".tcfiles\selection.tcsel"
			$selection_file == "C:\filePath.txt"	; to given file

	@param string $path_source	current path in total commander
	@param string $selection	current selection in total commander

*/

global $file_mode
global $path_source
global $selection
global $selection_file

$file_mode	= %1%
$path_source	= %2%
$selection	= %3%

setSelectionFile()
{
	if( $file_mode == "quick" )
		$selection_file	= %A_LineFile%\..\selection.tcsel
	else if( $file_mode == "tcfile" )
		$selection_file	= %$path_source%\.tcfiles\selection.tcsel
	else
		$selection_file	= %$file_mode%
}

saveSelection()
{
	if( $file_mode != "quick" )
		$file_exists := FileExist( $selection_file )

	If ( $file_exists )
		MsgBox, 4, Save current selection, Overide selection ?
			IfMsgBox, No
				$cancel = true

	if( ! $cancel ){

		FileDelete %$selection_file%
		FileCreateDir, %$path_source%\.tcfiles

		$file_content := addSlashToFolders()

		FileAppend, %$file_content% , %$selection_file%
	}
}

addSlashToFolders()
{
	$selection_split	:= StrSplit($selection, A_Space )

	For $f, $path in $selection_split
		$paths .= fileOrFolder( $path_source "\\" $path ) == "folder" ? $path "\`n" : $path "`n"

	return %$paths%
}


fileOrFolder( $path )
{
	return  InStr(FileExist($path), "D") = 0 ? "file" : "folder"
}

loadSelection()
{

	$path_tcmc	= %Commander_Path%\_Extensions\TCMC\TCMC.exe
	FileRead, $file_content, %$selection_file%

	clipboard	= %$file_content%
	$parameters	:= "50 CMcm_LoadSelectionFromClip"
	RunWait %comspec% /c %$path_tcmc% %$parameters%,,Hide
}



$control_key 	:= GetKeyState("Control", "Mode")
setSelectionFile()

;;; Save if Control pressed
if($control_key)
	saveSelection()
else
	loadSelection()