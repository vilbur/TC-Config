/** Class Control
*/
Class Control_vgui extends ControlSetup_vgui
{

	_Options := new Options_vgui()

	__New($Controls)
	{
		this.guiName($Controls.guiName())
		
		this._Controls	:= &$Controls
		this._type	:= RegExReplace(  this.__class, "_vgui$", "" )
		this.address()
	}
	/** Add control to Gui
	 * 
	 * @param	string	$name	name of control
	 * 
	 * @return	object Controls
	 */
	add($name:="")
	{
		this.name($name)
		
		return % this.Controls().add(this) ; clone added object if user insert one object multiple times
	}
	
	/** Delete control from Gui, Layout & ControlList
	 */
	delete()
	{
		;MsgBox,262144,DELETE CONTROL, % this._name ,3
		Object(this._layout_container).deleteControlFromSection(this)
	}
	/** Get configured Control object which is prepared to be passed Controls.add( $Control )
	 * 
	 * @return	object	Control	  
	 */
	get()
	{
		this.preAdd()
		return this
	}
	/** clear values in item types control
	 * 
	 */
	clear()
	{
		return % this.edit("")
	}
	
	/*---------------------------------------
		PRIVATE
	-----------------------------------------
	*/
	/** set Value Or Items
	*/
	_setValue($value)
	{
		if(this._isControlItemType())
			this.items($value)
		else 
			this.value($value)			
	}
	/** _getValueOrItems
	*/
	_getValueOrItems()
	{
		return % this._isControlItemType() ? this._items.string : this._value ; this._value
	}
	/**
	 */
	_isControlItemType()
	{
		return % RegExMatch( this._type, "i)(Tab|ListView|ListBox|Dropdown)")
	} 
	/** sanitizeName
	*/
	_sanitizeName()
	{
		;;;this._name := RegExReplace( this._name, "i)[^A-Z0-9_]+", "" )
		this._name := RegExReplace( this._name, "i)`n", " " )		
		
		return this
	}
	/** TODO: rename to private
	 */
	removeFromGui()
	{
		;MsgBox,262144,DELETE CONTROL, % this._name ,3
		this.Controls()._List.delete(this.hwnd)
		WM_CLOSE=0x10
		PostMessage, %WM_CLOSE%,,,, % "ahk_id " this.hwnd
	}

	/*---------------------------------------
		PARENTS
	-----------------------------------------
	*/
	/** Set\Get Base class VilGUI
		@return V
	*/
	Base()
	{
		return % this.Controls().Base()		
	}
	/** name of gui
	*/
	guiName($gui:="")
	{
		if($gui)
			this._gui	:= $gui
			
		return % $gui ? this : this._gui
	}	
	/** Controls
	*/
	Controls()
	{
		return % Object(this._Controls)
	}


}
