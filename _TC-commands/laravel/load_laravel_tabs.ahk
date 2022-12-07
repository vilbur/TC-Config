#SingleInstance force
#Include %A_LineFile%\..\Lib\Laravel.ahk

global $path_ini_file
global $path_load_tabs
global $tabs_folder

$path	= %1%
$tabs_file	= %2%
$path_ini_file	= %A_LineFile%\..\load_laravel_tabs.ini
$path_load_tabs	= %A_LineFile%\..\..\tabs\load-tabs.ahk
$tabs_folder	:= getPathsToTabs()

;;; ------------------------------------------------------------------------------------------------------------------------
;;; Replace Project_name in TotalCommander *.tab files
;;; get project name from given path and replace it in *.tab paths
;;;
;;; @param string $path to current folder, must contain "\\laravel\\" before project name	E.G.: "c:\wamp\laravel\Foo_Project.com\app\"
;;; @param string $tabs_file is name of *.tab file 												E.G.: "c:\TotalComander\_tabs\APP.tab"
;;; @param string $project_name is name of laravel project
;;;
;;; E.G.: TC_get_project_tabs("c:\wamp\laravel\Foo_Project.com\app\", "APP")
;;;				In "c:\GoogleDrive\TotalComander\_tabs\projects\Laravel_tabs\APP.tab" replace project name with "Foo_Project.com"
;;; ------------------------------------------------------------------------------------------------------------------------


TC_get_project_tabs($path, $tabs_file){

	$Laravel	:= new Laravel($path)
	$project_path	:= $Laravel.Project.path()
	$project_name	:= $Laravel.Project.name()
	$project_parent	:= $Laravel.Project.parent()

	if(!$project_name){
		MsgBox,262144,, % "LARAVEL PROJECT NOT FOUND IN PATH :`n`n" $path
		return
	}
	if(!FileExist($tabs_folder)){
		MsgBox,262144,, % "PATH TO TABS DOES NOT EXISTS !`n`nPlease set existing path to tab files in:`n`n" $path_ini_file
		return
	}

	$tabs_project = %$tabs_folder%\%$project_name%\%$tabs_file%.tab
	$tabs_default = %$tabs_folder%\_default\%$tabs_file%.tab

	$tabs_type	:= FileExist( $tabs_project )	? "project"		: "default"
	$tabs_file 	:= $tabs_type == "project" 		? $tabs_project	: $tabs_default
	$project_parent_esc	:= RegExReplace( $project_parent, "\\", "\\" )

	if ( $tabs_type == "default" ){
		If FileExist( $tabs_file )
			TF_RegExReplace( "!" $tabs_file, "i)" $project_parent_esc "\\+[^\\]+", $project_parent "\\" $project_name )
		else
			MsgBox,262144,, % "Tabs file does not exists:`n`n" $commands_ini
	}

	Run, %$path_load_tabs% ""%$tabs_file%""

}



getPathsToTabs()
{
	IniRead, $paths_tabs, %$path_ini_file%, path, tabs

	if( FileExist($path_ini_file) && $paths_tabs!="ERROR" )
		return %$paths_tabs%
	else
		IniWrite, %Commander_Path%\_tabs\laravel, %$path_ini_file%, path, tabs
}
/* Create kickstart files if does not exists
  */
createExampleTabFile($project_name)
{
	;MsgBox,262144,, createExampleTabFiles,2
	$tabs_path	= %Commander_Path%\_tabs\laravel
	$tabs_folder	= %$tabs_path%\%$project_name%
	$tabs_file	= %$tabs_folder%\APP.tab

	FileCreateDir, %$tabs_folder%

	FileAppend,  ; The comma is required in this case.
	(
[activetabs]
0_path=C:\wamp64\www\project_name\
0_options=1|0|0|0|0|2|0
activetab=1
	), %$tabs_file%

}



if(!FileExist($tabs_folder)){
	createExampleTabFile("_default")
	createExampleTabFile("project_name")

} else
	TC_get_project_tabs($path, $tabs_file)



