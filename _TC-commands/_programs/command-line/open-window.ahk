#SingleInstance force
#NoTrayIcon
#Include %A_LineFile%\..\..\..\laravel\Lib\Project.ahk

/* Open command line window
   
	Open in Laravel`s root if working dir is in Laravel project	e.g.: C:\wamp64\www\laravel\app\foo\bar
*/

$Project	:= new Project(A_WorkingDir)

$cmd := "cmd.exe "

if( $Project.path() )
	$cmd .= "/K cd " $Project.path()
	

Run *RunAs %$cmd%,,, $pid


/** When Cmd.exe window is selected, then it change title  to "Select Administrator C:\Windows\System32\cmd.exe"
 *	Change window title to init path E.G.: "C:\Current\dir"
 */
WinWaitActive, Select Administrator, , 5
if ! ErrorLevel && $Project.path()
	WinSetTitle, ahk_pid %$pid%,, % $Project.path() 


exitApp