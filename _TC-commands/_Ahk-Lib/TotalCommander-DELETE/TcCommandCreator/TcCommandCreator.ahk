#Include %A_LineFile%\..\includes.ahk

/** Class TcCommandCreator
*/
Class TcCommandCreator
{
	_commander_path	:= ""	
	_usercmd_ini	:= "" ; save 
	
	_prefix	:= ""	
	_name	:= ""
	_section	:= ""		
	
	_cmd	:= ""		
	_param	:= ""
	_menu	:= ""	
	_tooltip	:= ""	
	_button	:= "%systemroot%\system32\shell32.dll,43"			
	
	/** _setTabsPath
	 */
	__New()
	{
		$commander_path	= %Commander_Path%	
		$_usercmd_ini	= %Commander_Path%\usercmd.ini		
		this._commander_path	:= $commander_path		
		this._usercmd_ini	:= $_usercmd_ini		
	}
	/** set prefix
	  * @param	string	$prefix	for commands name, menu and tooltip text
	 */
	prefix( $prefix:="" )
	{
		this._prefix := $prefix
		
		return this		
	}
	/**
	  * @param	string	$name of command
	 */
	name( $name )
	{
		this._name := $name 
		return this 		
	}
	/**
	  * @param	string	$cmd	cmd key in Usercmd.ini
	 */
	cmd( $cmd )
	{
		this._cmd := $cmd 
		return this 		
	}
	/**
	  * @param	string	$params	any numbre of prameters, param key in Usercmd.ini
	 */
	param( $params* )
	{
		this._params 	:= $params

		return this
	}
	/**
	  * @param	string	$menu	menu key in Usercmd.ini
	 */
	menu( $menu )
	{
		this._menu := $menu
		
		return this 		
	}	
	/**
	  * @param	string	$tooltip	tooltip key in Usercmd.ini
	 */
	tooltip( $tooltip )
	{
		this._tooltip := $tooltip
		
		return this 		
	}
	/**
	  * @param	string	$icon	button key in Usercmd.ini
	 */
	icon( $icon )
	{
		if( $icon )
			this._button := $icon

		return this 		
	}
	/** write command to Usercmd.ini
	 */
	create()
	{
		this._setSection()
		
		this._writeToIni( "menu" )		
		this._writeToIni( "cmd" )
		this._writeToIni( "param" )
		this._writeToIni( "tooltip" )		
		this._writeToIni( "button" )
		
		this._appendEmptyLine()
		
		return this
	}
	/** delete command from Usercmd.ini
	 */
	delete( )
	{
		if( this._name )
			IniDelete, % this._usercmd_ini, % this._name
		return this
	}
	/**
	 */
	shortcut( $keys* )
	{
		if( $keys )
			return % this._shortcut.keys($keys)
		
		return this._shortcut
	}
	/**
	 */
	_setSection()
	{
		$prefix_sanitized	:= RegExReplace( this._prefix, "\s+", "_" )
		$prefix_name	:= $prefix_sanitized ? $prefix_sanitized "-" : $prefix_sanitized
		;$cmd_name	:= this._name ? RegExReplace( this._name, "[-\s\\\/]+", "-" ) : this._cmd
		this._section := "em_" $prefix_name this._getCmdName()
	} 
	/**
	 */
	_writeToIni( $key )
	{
		$value := this["_get" $key "Value" ]()
	
		if( $value != "" )
			IniWrite, %$value%,	% this._usercmd_ini, % this._section, %$key%		
	}
	/**
	 */
	_appendEmptyLine()
	{
		FileAppend, `n, % this._usercmd_ini	
	}
	/*---------------------------------------
		GET VALUES
	-----------------------------------------
	*/
	/**
	 */
	_getPrefix()
	{
		return this._prefix ? this._prefix " - " : ""
	
	} 
	/**
	 */
	_getCmdName()
	{		
		return this._name ? RegExReplace( this._name, "[-\s\\\/\[\]\(\)]+", "-" ) : this._cmd
	}
	/**
	 */
	_getMenuValue()
	{
		;$menu := this._menu ? this._menu : RegExReplace( this._name, "[-\s]+", " " )
		$menu := this._menu ? this._menu : this._name		
		
		return this._getPrefix() $menu
	}
	/**
	 */
	_getCmdValue()
	{
		return this._replaceCommanderPathEnvVariable(this._cmd)
	}
	/**
	 */
	_getParamValue()
	{		
		if( this._params.length()>0 && this._params[1]!=""  )
			For $i, $param in this._params
				$params .= this._escapeParameter($param) " "
				
		return $params
	}
	/**
	 */
	_getTooltipValue()
	{
		return this._tooltip ? this._getPrefix() this._tooltip : this._getMenuValue()
	}
	/**
	 */
	_getButtonValue()
	{
		return this._replaceCommanderPathEnvVariable(this._button)
	}	
	/*---------------------------------------
		HELPERS
	-----------------------------------------
	*/
	
	/** Replace path to %COMMANDER_PATH% back
			E.G.: "C:\TotalCommander" >>> "%COMMANDER_PATH%"
	 */
	_replaceCommanderPathEnvVariable( $path )
	{
		$commander_path_rx := RegExReplace( this._commander_path, "i)[\\\/]+", "\\" )
		return % RegExReplace( $path, "i)" $commander_path_rx, "%COMMANDER_PATH%" ) 
	}
	/** escape and quote %T & %P parameter
	 */
	_escapeParameter( $param )
	{
		if( RegExMatch( $param, "i)^%[TP]$" )  )
			return % """" $param "\""" ;;;;;; "
		
		return %$param%
	} 
}

