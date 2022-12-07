#Include %A_LineFile%\..\..\TcCommandCreator.ahk

/** TcCommandSetter
  *
  * Mass creator for TcCommands
  *
  */
Class TcCommandSetter
{
	_TcCommandCreator 	:= new TcCommandCreator()
	_commands	:= {} ; definition for commands
	
	/** set definition for commands
	  *
	  * @param object $commands {"command":	[ "MENU",	"TOOLTIP",	"ICONPATH",	"PARAMETERS"	]}
	  */
	commands( $commands:="" )
	{
		this._commands := $commands
		
		return this
	}
	/** set prefix
	  * @param	string	$prefix	for commands name, menu and tooltip text
	 */
	prefix( $prefix:="" )
	{
		this._prefix := $prefix
		
		return this		
	} 
	/** Create all commands
	 */
	createCommands()
	{		
		For $command, $values in this._commands
			this._TcCommandCreator.clone()
					.prefix(this._prefix)
					.cmd($command)
					.param($values[4]*)
					.menu($values[1])
					.tooltip($values[2])
					.icon($values[3])			
					.create()
	}

}

