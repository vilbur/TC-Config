;#NoTrayIcon
#SingleInstance force
#Include %A_LineFile%\..\Project.ahk

Class Laravel {

	;_path := {"project":"", "public":""}
	;_name := ""
	Project := ""

	__new($path){
		this.Project := new Project($path)
	}



}


/** ====== TESTS ======
*/

;$parameter1	= %1%
;global $Laravel
;$Laravel := new Laravel($parameter1)
;
;LaravelPath_Test()
;{
;	Dump( $Laravel.Project.path()!="" , "Laravel.path()", 1)
;	Dump( $Laravel.Project.name()!="" , "Laravel.name()", 1)
;	;Dump($Laravel, "Laravel", 1)
;}
;
;LaravelPath_Test()
