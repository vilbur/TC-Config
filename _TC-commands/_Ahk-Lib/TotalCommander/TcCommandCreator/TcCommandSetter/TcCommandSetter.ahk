#Include %A_LineFile%\..\..\TcCommandCreator.ahk

/** TcCommandSetter
  *
  * Mass creator for TcCommand
  *
  */
Class TcCommandSetter
{
	_TcCommandCreator 	:= new TcCommandCreator()
	_commands	:= {} ; definition for commands
	
	/** Set definition for commands
	  *
	  * @param object $commands {"command": [ "MENU", "TOOLTIP", "ICONPATH", "PARAMETERS" ]}
	  * @return	self 
	  */
	commands( $commands )
	{
		this._commands := $commands
		
		return this
	}
	/** Set prefix
	  * @param	string	$prefix	for commands name, menu and tooltip text
	  * @return	self 
	  */
	prefix( $prefix )
	{
		this._prefix := $prefix
		
		return this		
	} 
	/** Create all commands
	 */
	create()
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

