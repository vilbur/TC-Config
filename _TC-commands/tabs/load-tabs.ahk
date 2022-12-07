#NoTrayIcon
#SingleInstance force

/*
	Load *.tabs file to total commander

	Set temp command in "%Commander_Path%\Usercmd.ini"
	Run this command
	Delete temp command

	@param string path to *.tabs.file
*/

$tab_file_path	= %1%

$ini_value	:= "OPENTABS """ $tab_file_path """"
$cmd_name	:= "em_TABS_load-tabs-TEMP"
$cmd_load_tabs	:= $tcmc "500 EM" $cmd_name
$commands_ini	= %Commander_Path%\Usercmd.ini
$path_tcmc	= %Commander_Path%\_Extensions\TCMC\TCMC.exe

if( ! FileExist($commands_ini) ){
	MsgBox,262144,, % "Ini file does not exists:`n`n" $commands_ini
	return
}

IniWrite, %$ini_value%, %$commands_ini%, %$cmd_name%, cmd
RunWait %comspec% /c %$path_tcmc% %$cmd_load_tabs%,,Hide
Sleep, 100
IniDelete, %$commands_ini%, %$cmd_name%
exitApp