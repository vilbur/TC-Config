/*
	A) Save source and target path if Control pressed to file "\.tcfiles\sync.ini"


	B) Open sync dialog with selection in steps
		1) Load source and target paths from	"\.tcfiles\sync.ini"
		2) try set selection if saved in	"\.tcfiles\sselection.tcsel" else use current selection if defined
		3) open sync dialog
		4) run compare

*/

/*
  ====== SAVE SYNC ======
*/

setSyncIniFile()
{

	FileDelete %$sync_file%
	FileCreateDir, %$path_source%\.tcfiles

	IniWrite, 1,	%$sync_file%,	config, selected
	IniWrite, %$path_source%,	%$sync_file%,	paths, source
	IniWrite, %$path_target%,	%$sync_file%,	paths, target

}


/*
  ====== LOAD SYNC ======
*/
loadPaths()
{
	IniRead, $path_source, %$sync_file%, paths, source
	IniRead, $path_target, %$sync_file%, paths, target
}

openPaths()
{
	$parameters	:= "50 CD " $path_source " " $path_target " 100 Cmcm_FocusLeft"
	RunWait %comspec% /c %$path_tcmc% %$parameters%,,Hide
}

tryGetSelectionIfNothingSelected()
{
	if(!$selection || $selection==$file_under_cursor) ; file under cursor == selection if nothing selected
		RunWait, %A_LineFile%\..\..\selection\selection-save-load.ahk "tcfile" %$path_source%
}

openSyncDialog()
{
	$parameters	:= "50 CMcm_FileSync"
	Run, %comspec% /c %$path_tcmc% %$parameters%,,Hide
}

pressCompare()
{
	sleep, 500
	Send, {Enter}
}

/*
  ====== RUN COMMAND  ======
*/

global $path_source
global $path_target
global $sync_file
global $file_under_cursor
global $selection
global $path_tcmc

$path_source	= %1%
$path_target	= %2%
$selection	= %3%
$file_under_cursor	= %4%

$control_key 	:= GetKeyState("Control", "Mode")
$sync_file	= %$path_source%\.tcfiles\sync.ini
$path_tcmc	= %Commander_Path%\_Extensions\TCMC\TCMC.exe


;;; Save if Control pressed
if($control_key)
	setSyncIniFile()
else {
	loadPaths()

	if($path_source==="ERROR") ; if "\.tcfiles\sync.ini" does not exists
		return

	openPaths()
	tryGetSelectionIfNothingSelected()
	openSyncDialog()
	pressCompare()

}
