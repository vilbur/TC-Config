#NoTrayIcon
#SingleInstance force

#Include %A_LineFile%\..\..\..\_TC-commands\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk
#Include %A_LineFile%\..\..\..\_TC-commands\_Ahk-Lib\TotalCommander\TcCommand\TcCommand.ahk

/** Add files selected or file under cursor to Total commander commands
  *
  */
$selection	:= new TcSelection().getSelectionOrFocused("(.ahk|.exe|.bat)$")

if( ! IsObject($selection) )
	$selection := [$selection]

For $i, $file in $selection
	crateCommand( $file )

/**
 */
crateCommand( $file )
{
	
	SplitPath, $file, $file_name, $file_dir,, $file_noext 
	SplitPath, $file_dir, $dir_name
	
	StringUpper, $dir_name, $dir_name
	
	$cmd_name	:= RegExReplace( $dir_name, "^[_]", "" ) "-" RegExReplace( $file_noext, "[_]", "-" )
	$menu	:= RegExReplace( $cmd_name, "[_-]", " " ) 	

	
	InputBox, $params,	SET PARAMS,	% "Add params for: " $file_name, , , 128, , , , ,
	
	InputBox, $menu,	SET MENU TEXT,	% "Menu text for: " $cmd_name, , , 128, , , , , %$menu%
	if ErrorLevel
		exitAddingCommand( $file_name )
	
	InputBox, $tooltip,	SET TOOLTIP,	% "Tooltip text for: " $cmd_name, , , 128, , , , , %$menu%	
	if ErrorLevel
		exitAddingCommand( $file_name )
		
	if( $menu && $tooltip){
		new TcCommand()
			.name($cmd_name)
			.cmd($file)
			.param($params)
			.menu($menu)
			.tooltip($tooltip)	
			.create()
			
			MsgBox,262144,SUCCESS, % "FILE: " $file_name "`n`n     WAS ADDED"

	}else
		exitAddingCommand( $file_name )

}

/**
 */
exitAddingCommand( $file_name )
{
	MsgBox,262144,FAIL, % "FILE: " $file_name "`n`nWAS NOT ADDED TO COMMANDS"
	exitApp
}


exitApp