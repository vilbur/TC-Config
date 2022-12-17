/** Class TcShortcut
*/
Class TcShortcut
{
	_wincmd_ini	:= "" ; set keyboard shortcuts
	_name	:= "" ; name of command
	_section	:= "Shortcuts"
	_keys	:= []	

	/** _setTabsPath
	 */
	__New()
	{
		$_wincmd_ini	= %Commander_Path%\wincmd.ini
		this._wincmd_ini	:= $_wincmd_ini
	}
	/**
	 */
	name( $name )
	{
		this._name := $name
		this._shortcut 	:= new TcShortcut($name)
		return this 		
	}
	/**
	 */
	keys( $keys )
	{
		For $k, $key in $keys
			if( RegExMatch( $key, "i)win" ) )
				this._section := "ShortcutsWin"
				
			;else if( RegExMatch( $key, "i)(ctr|control|alt|shift)" ) )
				;this._keys.push(SubStr($key, 1, 1))

			else
				this._keys.push($key)

		return this
	}
	/** create keyboard shortcut to run this._cmd_load_tabs command
		create keyboard shortcut in section "ShortcutsWin"
		section "ShortcutsWin" runs keyboard shortcuts with win key 
	 */
	create( $force:=false )
	{
		$shortcut := this._getShortcut()
		IniRead, $exists, % this._wincmd_ini, % this._section, %$shortcut%, NOT
		
		if( $exists=="NOT" || $force!=false )
			IniWrite, % this._name, % this._wincmd_ini, % this._section, % this._getShortcut()
		else
			MsgBox,262144,, % "SHORTCUT ALREADY EXISTS`n`n" $shortcut
	}
	/** Delete shorcut
		Find command name in section and delete it
	 */
	delete()
	{
		For $s, $section in ["Shortcuts","ShortcutsWin"]
			IniRead, $sections, % this._wincmd_ini, %$section%
				loop, Parse, $sections, `n
					if( RegExMatch( A_LoopField, "i)^([^\=]+)\=" this._name, $key_match ) )
						IniDelete,  % this._wincmd_ini, %$section%, %$key_match1% 
	}

	/**
	 */
	_getShortcut()
	{
		For $i, $key in this._keys
			$keys .= RegExMatch( $key, "i)(ctr|control|alt|shift)" ) ? SubStr($key, 1, 1) : "+" $key
		
		return %$keys% 
	} 
	


	
}

