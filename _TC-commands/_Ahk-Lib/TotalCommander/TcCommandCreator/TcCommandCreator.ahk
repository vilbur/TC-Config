#Include %A_LineFile%\..\includes.ahk

/** Create command in Total Commander
*/
Class TcCommandCreator extends TcCommanderPath
{
	_shortcut 	:= new TcShortcut()
	
	_prefix	:= ""	
	_name	:= "" ; name of command WITHOUT PREFIX "em_"
	_section	:= ""		
	
	_cmd	:= ""		
	_param	:= ""
	_menu	:= ""	
	_tooltip	:= ""	
	_button	:= "%systemroot%\system32\shell32.dll,43"
	
	/**
	  * @param	string	$name Name of command
	  */
	__New($name:="")
	{
		this._setCommanderPath()
		this._setIniFile("usercmd.ini")
		
		if( $name )
			this.name($name)
	}
	/** Set prefix for commands name, menu and tooltip text
	  * @param	string	$prefix	
	  *
	  * @return	self
	  */
	prefix( $prefix:="" )
	{
		this._prefix := $prefix
		
		return this		
	}
	/** Set name of command
	  * @param	string	$name Name of command
	  *
	  * @return	self
	  */
	name( $name )
	{
		this._name := RegExMatch( $name, "^em_" ) ? SubStr( $name, 4 )  : "em_" $name
		return this 		
	}
	/** Set of command
	  * @param	string	$cmd	cmd key in Usercmd.ini
	  *
	  * @return	self
	  */
	cmd( $cmd )
	{
		this._cmd := $cmd 
		return this 		
	}
	/** Set params of command
	  * @param	string	$params	Any number of parmeters, param key in Usercmd.ini
	  *
	  * @return	self
	  */
	param( $params* )
	{
		this._params 	:= $params

		return this
	}
	/** Set menu text of command
	  * @param	string	$menu	Menu key in Usercmd.ini
	  *
	  * @return	self
	  */
	menu( $menu )
	{
		this._menu := $menu
		
		return this 		
	}
	
	/*---------------------------------------
		ALIASES
	-----------------------------------------
	*/
	/** Set tooltip of command
	  * @param	string	$tooltip	Menu key in Usercmd.ini
	  *
	  * @return	self
	  */
	tooltip( $tooltip )
	{
		this._tooltip := $tooltip
		
		return this 		
	}
	/** Set Icon of command
	  * @param	string	$icon	button key in Usercmd.ini
	  *
	  * @return	self
	  */
	icon( $icon )
	{
		if( $icon )
			this._button := $icon

		return this 		
	}
	/*---------------------------------------
		COMMAND METHODS
	-----------------------------------------
	*/
	/** Write command to Usercmd.ini
	  *
	  * @return	self
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
	/** Delete command from Usercmd.ini
	  *
	  * @return	self
	  */
	delete( )
	{
		if( this._name )
			IniDelete, % this._usercmd_ini, % this._name
		return this
	}
	/** Create keyboard shortcut or get TcShortcut if params are empty
	 *
	 * @param	string	$keys*	Keys for shortcut
	 * @return	self|[TcShortcut](/TcShortcut)
	 */
	shortcut( $keys* )
	{
		if( ! $keys.length() )
			return this._shortcut
		
		this._shortcut.name(this._getSectionName())
		
		this._shortcut.shortcut($keys*)
		
		return % this
	}
	
	/*---------------------------------------
		PRIVATE
	-----------------------------------------
	*/
	/**
	 */
	_getSectionName()
	{
		$prefix_sanitized	:= RegExReplace( this._prefix, "\s+", "_" )
		$prefix_name	:= $prefix_sanitized ? $prefix_sanitized "-" : $prefix_sanitized
		return % "em_" $prefix_name this._getCmdName()
	} 
	/**
	 */
	_setSection()
	{
		this._section := this._getSectionName()
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
		return this.pathEnv(this._cmd)
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
		return this.pathEnv(this._button)
	}	
	/*---------------------------------------
		HELPERS
	-----------------------------------------
	*/

	/** escape and quote %T & %P parameter
	 */
	_escapeParameter( $param )
	{
		if( RegExMatch( $param, "i)^%[TP]$" )  )
			return % """" $param "\""" ;;;;;; "
		
		return %$param%
	} 
}

