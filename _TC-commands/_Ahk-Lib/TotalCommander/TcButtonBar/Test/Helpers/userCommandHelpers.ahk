#Include %A_LineFile%\..\getNewButtonBar.ahk

/**
 */
createTestUserCommand()
{
	
	IniWrite, \foo\file\pah,	%$ini_path%, %$user_command%, cmd
	IniWrite, %systemroot%\system32\shell32.dll`,43,	%$ini_path%, %$user_command%, button
	IniWrite, "foo param",	%$ini_path%, %$user_command%, param
	IniWrite, Tooltip test,	%$ini_path%, %$user_command%, menu	
	
}
/**usercmd_ini
 */
deleteTestUserCommand()
{
	IniDelete, %$ini_path%, %$user_command%
}