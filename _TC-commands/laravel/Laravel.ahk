;#NoTrayIcon
#SingleInstance force
#Include %A_LineFile%\..\Lib\Project.ahk

Class Laravel
{

	Project := ""

	__new($path){
		this.Project := new Project($path)
	}


}