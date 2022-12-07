#Include %A_LineFile%\..\includes.ahk
/** Create keyboard shortcut
*/
Class TcShortcut extends TcCommanderPath
{
	_name	:= "" ; name of command
	_section	:= "Shortcuts"
	_keys	:= []
	
	_force	:= "" ; force overide existing shortcut
	_suspend	:= "" ; suspend create() in keys() method 
	
	/**
	  * @param	string	$name Name of command
	  */
	__New($name:="")
	{
		this._setCommanderPath()
		this._setIniFile("usercmd.ini")
		this._setIniFile("wincmd.ini")		
		
		if( $name )
			this.name($name)
	}
	/** Name of command E.G.: "em_user-command"
	 *
	 * @param	string	$name Name of command
	 * @return	self  
	 */
	name( $name )
	{
		this._name := RegExMatch( $name, "^em_" ) ? $name : "em_" $name
		;Dump(this._name, "this._name", 1)
		return this 		
	}
	/** Set control keys
	 *
	 * Last parameter can be boolean for force or suspend creation	 
	 *
	 * @param	string	$keys*	Keyboard keys for shortcut
	 * @return	self  
	 */
	shortcut( $keys* )
	{
		this._keys := $keys
		
		this._getLastParam()
		this._setSection()		

		if( ! this._suspend )
			this._create()
		
		return this
	}
	/** Get _force\_supsend if last parameter is boolean
	  *
	  * Remove boolean from keys
	 */
	_getLastParam()
	{
		$length	:= this._keys.length()
		$last_param	:= this._keys[$length]
	
		
		if( [$last_param].GetCapacity(1) > 0 ) ;  if not number but can be string number e.g.: 0 & "0"
			return
				
		if( $last_param==0 )
			this._suspend := true
			
		else if( $last_param==1 )
			this._force 	:= true
		
		this._keys.delete($length)
	}
	/** Set section in usercmd.ini
	 */
	_setSection()
	{
		For $k, $key in this._keys
			if( RegExMatch( $key, "i)win" ) )
				this._section := "ShortcutsWin"
	} 
	/** Delete shorcut
		Find command name in section and delete it
	 */
	delete()
	{
		if( this._keys.length() )
			this._deleteByShortcut()
		
		else if( this._name )
			this._deleteAllByCommandName()			
	}
	/** Delete by shorctut
	 */
	_deleteByShortcut()
	{
		IniDelete,  % this._wincmd_ini, % this._section, % this._getShortcut()
	} 
	/** Delete all shortcuts by command name
	  *
	  */
	_deleteAllByCommandName()
	{
		For $s, $section in ["Shortcuts","ShortcutsWin"]
		{
			IniRead, $sections, % this._wincmd_ini, %$section%
				loop, Parse, $sections, `n
					if( RegExMatch( A_LoopField, "i)^([^\=]+)\=.*" this._name, $key_match ) )
						IniDelete,  % this._wincmd_ini, %$section%, %$key_match1% 
		}
	}
	/*---------------------------------------
		PRIVATE
	-----------------------------------------
	*/
	/** create keyboard shortcut to run this._cmd_load_tabs command
		create keyboard shortcut in section "ShortcutsWin"
		section "ShortcutsWin" runs keyboard shortcuts with win key 
	 */
	_create()
	{
		;$shortcut := this._getShortcut()
		;Dump(this, "this.", 1)
		if( this._ifCommandExists() && ( this._force || this._ifShortcutDoesNotExists() ) )
			IniWrite, % this._name, % this._wincmd_ini, % this._section, % this._getShortcut()
	}
	/**
	 */
	_ifCommandExists()
	{
		IniRead, $exist_cmd,	% this._usercmd_ini,	% this._name
		;MsgBox,262144,exist_cmd, %$exist_cmd%,3 
		if( ! $exist_cmd )
			MsgBox,262144,, % "COMMAND DOES NOT EXISTS:`n`n" this._name

		return $exist_cmd ? true :false
	}
	/**
	 */
	_ifShortcutDoesNotExists()
	{
		IniRead, $exist_shortcut,	% this._wincmd_ini,	% this._section, % this._getShortcut(), 0
		
		;MsgBox,262144,exist_shortcut, %$exist_shortcut%,3 
		if( $exist_shortcut )
			MsgBox,262144,, % "SHORTCUT ALREADY EXISTS`n`n" this._joinKeys()
		
		return % ! $exist_shortcut
	}
	
	/**
	 */
	_getShortcut()
	{
		For $i, $key in this._keys
			if( ! InStr( $key, "win" ) )
				$keys .= RegExMatch( $key, "i)(ctr|control|alt|shift)" ) ? SubStr($key, 1, 1) : "+" $key
		
		return %$keys% 
	}
	/**
	 */
	_joinKeys()
	{
		For $i, $key in this._keys
			$keys .=  $key "+"
		
		$keys := SubStr( $keys, 1, StrLen($keys)-1 ) 
		
		return $keys 
	}
	/** Exit script with message
	 */
	_exit( $message  )
	{
		MsgBox,262144, TcShortcut, %$message%
		return
	}
	
}

