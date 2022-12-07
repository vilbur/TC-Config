#SingleInstance force
#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk

/*  Set or run file via command in Total commander
	
	Save path to file and parameter
	  
	1) Save test file path if Control key is pressed 
	2) Execute test file if NOT Control key
	
*/

$wincmd_ini	= %Commander_Path%\wincmd.ini
$usercmd_ini	= %Commander_Path%\usercmd.ini
$commander_path	= %Commander_Path%
$command_name	:= "em_FILE-test-command"

/* Add new test file 
  */
if( GetKeyState("Control", "P"))
{
	
	$TcSelection 	:= new TcSelection()
	$focused_file	:= $TcSelection.getFocused("file")
	$icon	:= "%Commander_Path%\Icons\_Library\TestBat.ico"
	
	if( ! $focused_file )
	{
		MsgBox,262144,, File is not focused,2 	
		return	
	}
	/* If file runs itself (e.g.: if executed first time)
	  */
	if(  InStr( A_ScriptFullPath, $focused_file )  )
		$focused_file  := ""
	
	
	InputBox, $params_input,	SET PARAMS,	% "Add params for: " $focused_file, , , 128, , , , ,
	
	$params := $focused_file " " $params_input
	
	IniWrite, % A_ScriptFullPath,	%$usercmd_ini%, %$command_name%, cmd
	IniWrite, %$params%,	%$usercmd_ini%, %$command_name%, params
	IniWrite, %$icon%,	%$usercmd_ini%, %$command_name%, button
	
	/*---------------------------------------
		SET TOOLTIP
	-----------------------------------------
	*/
	IniRead, $buttonbar_file,	%$wincmd_ini%, Buttonbar, Buttonbar
	$buttonbar_file := RegExReplace( $buttonbar_file, "%Commander_Path%", $commander_path ) 

	If( ! FileExist( $buttonbar_file ))
		return 

	/* Find command in button bar
	  */
	Loop, read, %$buttonbar_file%
		IfInString, A_LoopReadLine, %$command_name%
			RegExMatch( A_LoopReadLine, "i)cmd(\d+).*", $cmd_number )
	
	/* Set tooltip
	  */
	if( $cmd_number1 )
		IniWrite, %$focused_file%,	%$buttonbar_file%, Buttonbar, % "menu" $cmd_number1
	
	
}else{
	/* Run Test file
	*/
	IniRead, $test_path_with_params,	%$usercmd_ini%, %$command_name%, params

	Run, %$test_path_with_params%
}



