#SingleInstance force
#Include %A_LineFile%\..\..\..\Laravel.ahk


/** ====== TESTS ======
*/
LaravelPath_Test( )
{
	;$path_to_laravel	:= "c:\wamp64\www\portfolio\database"
	$path_to_laravel	:= "c:\wamp64\www\portfolio\\"
	;$path_to_laravel	:= "c:\wamp64\www\portfolio"
	$Project	:= new Project(A_WorkingDir)
	Dump( $Project.path()=="c:\wamp64\www\portfolio",	"Project.path()", 1)
	Dump( $Project.parent()=="c:\wamp64\www",	"Project.parent()", 1)
	Dump( $Project.name()=="portfolio",	"Project.name()", 1)
}

LaravelPath_Test()