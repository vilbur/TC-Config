#SingleInstance force
#Include %A_LineFile%\..\..\TcCommandCreator.ahk

/*---------------------------------------
	CREATE COMMANDS
-----------------------------------------
*/
new TcCommandCreator()
		.cmd("TcCommandCreator-minimal-config")
		.create()

/* RESULT:
[em_minimal-command]
	menu=minimal command
	cmd=minimal-command
	tooltip=minimal command
	button=%systemroot%\system32\shell32.dll,43
*/

new TcCommandCreator()
		.prefix("TcCommandCreator")
		.name("command-paths")
		.cmd("c:\GoogleDrive\TotalComander\Path-to-Total-Comamnder-is-escaped")
		.param("%P", "%T")
		.menu("Escape and add trailing slash to %P and %T params")
		.tooltip("Toolbar text")	
		.create()
	
/* RESULT:
[em_TcCommand-command-paths]
	menu=TcCommandCreator - Escape and add trailing slash to %P and %T params
	cmd=%COMMANDER_PATH%\Path-to-Total-Comamnder-is-escaped
	param="%P\" "%T\"      
	tooltip=TcCommandCreator - Toolbar text
	button=%systemroot%\system32\shell32.dll,43
*/

/*---------------------------------------
	DELETE COMMANDS
-----------------------------------------
*/
;new TcCommandCreator("em_TcCommandCreator-minimal-config").delete()
;new TcCommandCreator("em_TcCommandCreator-command-paths").delete()
