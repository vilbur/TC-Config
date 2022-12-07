#SingleInstance force
#Include %A_LineFile%\..\..\TcCommand.ahk
#Include %A_LineFile%\..\helpers\TcCommandTestCmdCreate.ahk
/* Call native & user command
 */
callCommandsTest()
{
    $default_command := "SrcThumbs"
    $user_command    := "UserTestCommand"

	new TcCommand($default_command) ; call command in constructor
	
	new TcCommand()
			.cmd("cm_" $default_command, 1000)			
			.cmd($user_command, 2000)			
			.cmd("em_" $user_command, 3000)
			.call()
}
/*--------------------------------------- 
	RUN TESTS
-----------------------------------------
*/
callCommandsTest()


#Include %A_LineFile%\..\helpers\TcCommandTestCmdDelete.ahk
