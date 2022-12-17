#SingleInstance force

#Include %A_LineFile%\..\..\TcCommand.ahk




/*---------------------------------------
	RUN TEST
-----------------------------------------
*/



/* TEST NATIVE TOTAL COMMANDER COMMAND
 */
;new TcCommand().call("cm_GoToLockedDir")
;new TcCommand().call("GoToLockedDir")


/* TEST USER COMMAND
 */
global $user_command	:= "TestCommandCalled"

createTestUserCommand()


;new TcCommand().call($user_command)
new TcCommand().call("em_" $user_command)


deleteTestUserCommand()




/*---------------------------------------
	HELPERS FOR TEST
-----------------------------------------
*/
/**
 */
createTestUserCommand()
{
	IniWrite, % A_ScriptDir "\command-file\command-file.ahk", %Commander_Path%\usercmd.ini, % "em_" $user_command, cmd
}
/**
 */
deleteTestUserCommand()
{
	IniDelete, %Commander_Path%\usercmd.ini, % "em_" $user_command
}
