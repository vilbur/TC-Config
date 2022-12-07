;#NoTrayIcon
#SingleInstance force

LoopFileSelectionAndSetCommandToIni()

/*
;; ------------------------------------------------------------------------------------------------------------------------
;; set selected *.ahk and *.bat files TO TOTAL COMMANDER copmmands ini in "%Commander_Path%\LANGUAGE\%username%.ini"
;; ------------------------------------------------------------------------------------------------------------------------
*/
LoopFileSelectionAndSetCommandToIni(){
	$file_list_array := TotalCommander_GetSelectionList("ahk,bat",0,0)
	;dump($file_list_array, "file_list_array" )

	;For $key, $file in $file_list_array
	;	_setCommandToIni($file,$command_object)
	;Run, Komodo.exe %$tc_commands_ini%
}

/*
	set command to ini, commands are alphabetically sorted
*/
;_setCommandToIni($file,$command_object){
;
;    SplitPath, $file, $name, $dir, $ext, $noext, $drive
;	;$tc_commands_ini	= %path_tc%\LANGUAGE\vilbur.ini
;	$INI	:= INI( "%path_tc%\LANGUAGE\vilbur.ini" )
;	$parent_dir	:= Path_getParentFolder($file)
;	$command_object	:= _getIniCommandObject($file)
;	$section	:= "em_" $parent_dir "_" $noext
;	;dump($command_object, "command_object")
;	;dump($INI.data.em_Tabs_load_via_ahk, "INI")
;	
;	$INI.set($section, $command_object)
;	$INI.create("",1) ; rewrite whole file
;
;	Notify_info("TOTAL COMMANDER`nCommand added", "Ahk file:`n" $name , 1 )
;	
;}
;
;/*
;*/
;_getIniCommandObject($file){
;    SplitPath, $file, $name, $dir, $ext, $noext, $drive
;    $parent_dir := Path_getParentFolder($file)
;
;	$tc_relative_file_path  := TC_GetRelativePath($file)
;	$tc_relative_dir_path 	:= TC_GetRelativePath($dir)
;
;	$cmd_obj := {"cmd":"""" $tc_relative_file_path """"
;		,"path":""
;		,"param":""
;		,"menu":$parent_dir " " RegExReplace( $noext, "[_-]", " " )
;		,"button":"""" $tc_relative_file_path """"}
;
;	return %$cmd_obj%
;}
