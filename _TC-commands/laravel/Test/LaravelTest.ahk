#SingleInstance force
#Include %A_LineFile%\..\..\Laravel.ahk


Laravel_Test()
{
	$Laravel := new Laravel(A_WorkingDir)
	;Dump( $Laravel.Project.path()!="" , "Laravel.path()", 1)
	;Dump( $Laravel.Project.name()!="" , "Laravel.name()", 1)
	Dump($Laravel, "Laravel", 1)
}

Laravel_Test()
