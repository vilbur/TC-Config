global 	$usercmd
global 	$cmd
$usercmd	= %Commander_Path%\usercmd.ini
$cmd	= em_UserTestCommand

/**
 */
userCommandCreate()
{
	IniWrite, % A_ScriptDir "\command-file\command-file.ahk", %$usercmd%, %$cmd%, cmd
}

userCommandCreate()