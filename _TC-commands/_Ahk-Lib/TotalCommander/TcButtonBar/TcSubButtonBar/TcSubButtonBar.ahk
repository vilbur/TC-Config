/** TcSubButtonBar - Button with nested button bar
 * Set button bar as button
 * Icon is assigned to button, if *.ico named as button bar exist in folder E.g.: Buttonbar.bar & Buttonbar.ico
 * 
 * @method	self|TcButtonBar	bar( [string|object $buttonbar] )	Set\Get button bar
 * @method	self	save( [string $buttonbar_path] )	Save button bar to file
 *
 * @method	self	asBar()	Show sub bar as flatterned menu
 * @method	self	asMenu()	Show sub bar as dropdown menu
 * 
 * @method	self	backButton( string $main_buttonbar_path ) Set first button as back button to main button bar	
 *    
 */
Class TcSubButtonBar extends TcButtonBarButton
{
	_bar 	:= "" ; subbar 
	_iconic	:= 1 ; show as: bar = 0 | menu = 1

	/** Get\Set TcButtonBar to button
	  *
	  * @param	TcButtonBar|string	$buttonbar	TcButtonBar object OR path to *.bar file
	  *
	  * @return	self|TcButtonBar 
	 */
	bar( $buttonbar:="" )
	{
		if( $buttonbar )
			this._bar	:= isObject($buttonbar) ? $buttonbar : new TcButtonBar().load($buttonbar)
		
		return $buttonbar ? this : this._bar
	}
	/** Save buttonbar
	  *
	  * @param	string	$buttonbar_path	Path to button bar
	  *	  	  
	  * @return	self
	 */
	save( $buttonbar_path:="" )
	{
		this._bar.save( $buttonbar_path )
		
		this._setBarPath( $buttonbar_path )

		return this 
	}
	/** Show subbar as bar
	 */
	asBar()
	{
		return % this.iconic( 0 )
	}
	/** Show subbar as menu
	 */
	asMenu()
	{
		return % this.iconic( 1 )
	}
	/** Set first button of subbar as reference to main buttonbar
	  *
	  * @param	string	$main_buttonbar_path	Path to main subbar
	  *
	 */
	backButton( $main_buttonbar_path )
	{
		$backbutton := this._bar.button(1)
		
		if( ! RegExMatch( $backbutton.cmd(), "i).bar$" ) )
			this._addBackButton( $main_buttonbar_path )

		return this
	}
	/**
	 */
	_addBackButton( $buttonbar_path )
	{
		this._bar.button( new TcButtonBarButton()
								.cmd($buttonbar_path)
								.icon( "%Commander_Path%\wcmicons.dll,15" )								
								.tooltip( "Back to " this._getButtonBarName( $buttonbar_path )  ), 1)
	}
	/**
	 */
	_setBarPath( $path:="" )
	{
		if( ! $path )
			return 

		this.cmd( $path )
		this.menu( this._getButtonBarName( $path )  )		
		
		this._tryFindIcon()
	}
	/**
	 */
	_getButtonBarName( $path )
	{
		return % RegExReplace( $path, ".*\\([^\\]+).bar$", "$1" )
	} 
	/** Set this._button and this._iconnic
	  *
	  * @param	string	$icon	Path to icon
	  * @param	int	$index	Index of icon
	  *
	  * @return	self
	 */
	_tryFindIcon( )
	{
		$icon_path := RegExReplace( this.cmd(), ".bar$", ".ico" )
		
		if( ! this._button )
			if( FileExist( $icon_path ) )
				this.icon($icon_path)
		
		return this
	}
	
	
}