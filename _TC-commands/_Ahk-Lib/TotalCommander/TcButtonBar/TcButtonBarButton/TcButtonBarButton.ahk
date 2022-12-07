/** TcButtonBarButton
 *		Button in button bar
 * 
 *  CREATE BUTTON OF TYPES:
 *		1. Custom button
 *		2. From command
 *		3. Separator
 *		4. Empty button
 *
 * @class TcButtonBarButton( [string $file] )
 *		     
 * @method	self	loadCommand( string $command_name )	Load command as button from cmd.ini E.G.: Usercmd.ini
 * @method	self	loadButton( int $position )	Load button from *.bar file
 * @method	self	empty()	Create empty button
 *
 * @method	self	cmd( string $cmd )	Get\Set cmd key
 * @method	self	menu( string $menu )	Get\Set menu key
 * @method	self	param( string $param )	Get\Set param key
 * @method	self	iconic( string $iconic )	Get\Set iconic key
 * @method	self	button( string $button[, int $index] )	Get\Set button key    
 *
 * @method	self	icon( string $icon[, int $index] )	Get\Set icon, alias for button()
 * @method	self	tooltip( string $tooltip )	Get\Set tooltip, alias for menu()
 *     
 * @method	string	join( int $position )	Join object data to string ready for write to *.bar file
 * 
 */
Class TcButtonBarButton extends TcCommanderPath
{
	static _file := {path:""} ; path to *.ini with command, ussually Usercmd.ini
	
	_cmd	:= ""
	_param	:= ""	
	_button	:= "" ; icon
	_iconic	:= "" ; icon number
	_menu	:= "" ; tooltip

	/**
	  * @param	string	$file	path to *cmd.ini file or *.bar file
	 */
	__New( $file:="" )
	{
		this._setCommanderPath()
		
		if( $file )
			this._file.path := $file
	}
	/** Load command as button from cmd.ini E.G.: Usercmd.ini
	 *  
	 *  @param	string	$name	Command name from "Usercmd.ini" E.G.: "em_custom-command"
	 *
	 * @return	self	
	 */
	loadCommand( $name )
	{
		this.cmd( $name)
		
		For $key, $value in this
			this._loadCommandProperty($key)
				
		return this
	}
	/** Load button from *.bar file
	 *  
	 *  @param	int	$position	Position of button in *.bar file
	 *
	 * @return	self	
	 */
	loadButton( $position )
	{		
		For $key, $value in this
			this._loadButtonProperty($key, $position)
				
		return this
	}
	/** Create empty button
	 *
	 * @return	self	
	 */
	empty()
	{
		this.cmd( "cmd.exe /c exit" )	; do nothing command
		this.icon("%systemroot%\system32\shell32.dll,49") 	; empty icon
		this.iconic(0)	; run minimized
		this.tooltip("-")
		
		return this 
	}
	
	/** Join object to string
	  *
	  * @param	int	$position	position of button
	  * @return	string	Lines ready to be written to *.bar file
	 */
	join($position)
	{
		if( this._isSeparator() )
			return "iconic" $position "=0"
	
		For $key, $value in this
			if( (!isObject($value) && $value ) || this._isIconicNumber($key)  )
				$cmd_string .= RegExReplace( $key, "^_", "" ) $position "=" this.pathEnv($value) "`n"
		
		return % SubStr( $cmd_string, 1, StrLen($cmd_string)-1 ) 
	}

	/*---------------------------------------
		SET\GET BUTTNO PROPERTY
	-----------------------------------------
	*/
	/** Set\Get cmd property
	  * @return	self|string
	 */
	cmd( $cmd:="" )
	{
		return % this._setOrGet( "_cmd", $cmd )
	}
	/** Set\Get param property 
	  * @return	self|string
	 */
	param( $param:="" )
	{
		return % this._setOrGet( "_param", $param )
	} 
	/** Set\Get button property 
	  * @return	self|string
	 */
	button( $icon:="", $index:="" )
	{
		this.set( "_button", $icon ($index?"," $index : "") )

		return $value ? this : this[$key]
	}
	/** Set\Get iconic property 
	  * @return	self|string
	 */
	iconic( $iconic:="" )
	{
		if $iconic is number
			this._iconic := $iconic
		else
			return this._iconic

		return this
	}
	/** Set\Get menu property 
	  * @return	self|string
	 */
	menu( $tooltip:="" )
	{
		return % this._setOrGet( "_menu", $tooltip )
	}
	/*---------------------------------------
		ALIASES
	-----------------------------------------
	*/
	/** Set icon, alias for button()
	  *
	  * @param	string	$icon	Path to icon
	  * @param	int	$index	Index of icon
	  *
	  * @return	self
	 */
	icon( $icon, $index:="" )
	{
		this.button( $icon, $index )
		
		return this
	}
	/** Set tooltip, alias for menu()
	  *
	  * @return	self
	 */
	tooltip( $tooltip )
	{
		this.menu($tooltip)
		
		return this
	}
	/*---------------------------------------
		PRIVATE
	-----------------------------------------
	*/
	/**
	 */
	_isSeparator()
	{
		For $key, $value in this
			if( $value )
				return
				
		return true
	} 
	/**
	 */
	_isIconicNumber($key)
	{
		$iconnic := this._iconic
		
		if( $key=="_iconic" )
			if $iconnic is number
				return true
	} 
	/*---------------------------------------
		SET PROPERTIES
	-----------------------------------------
	*/
	
	/** Set\Get property
	  *
	  * @param	string	$key	Key of property
	  * @param	string	$value	Value of property 
	  *
	 */
	set( $key, $value:="" )
	{
		$key := RegExReplace( $key, "^_*", "_" ) 

		if( $value )
			this[$key]	:= $value
		
		return  this
	} 	
	/** Set\Get property 
	 */
	_setOrGet( $key, $value:="" )
	{
		this.set( $key, $value )

		return $value ? this : this[$key]
	} 	

	/*---------------------------------------
		LOAD COMMAND FROM usercmd.ini
	-----------------------------------------
	*/

	/** Load value from ini
	 */
	_loadCommandProperty($key)
	{
		$ini_value := this._getIniValue( this.cmd(), $key )
		
		if( $ini_value && ! this[$key] )
			this[$key] := $ini_value
	}
	/*---------------------------------------
		LOAD COMMAND FROM *.bar FILE
	-----------------------------------------
	*/

	/** Load value from ini
	 */
	_loadButtonProperty($key, $position)
	{
		$ini_value := this._getIniValue( "Buttonbar", $key $position )
		
		if( $ini_value && ! this[$key] )
			this[$key] := $ini_value
	}
	
	/*---------------------------------------
		INI METHODS
	-----------------------------------------
	*/
	/**
	 */
	_getIniValue( $section, $key )
	{
		$key := RegExReplace( $key, "^_", "" ) 

		IniRead, $value, % this._file.path, %$section%, %$key%
		
		return $value!="ERROR" ? $value : "" 
	} 
	
}