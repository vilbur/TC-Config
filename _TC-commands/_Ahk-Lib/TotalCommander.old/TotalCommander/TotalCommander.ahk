#Include %A_LineFile%\..\..\TcCore.ahk
/* Class TotalCommander
*/
Class TotalCommander extends TcCore
{
	_previous_vindow	:= {}

	/**
	 */
	__New()
	{
		this._init()
	}
	/** activate
	*/
	activate()
	{
		WinActivate, % this.ahkId()
	}
	/** Get\Set title to window
	 */
	title( $title:="" )
	{
		if( $title )
			WinSetTitle, % "ahk_id " this._hwnd,,%$title%
		else 
			WinGetTitle, $title_current, % "ahk_id " this._hwnd 
			
		return % $title ? this : $title_current
	} 
	/** Store id and and state of always on top for resotrion
	 */
	_saveActiveWindow()
	{
		$active_win_hwnd := WinActive("A") 
		
		if( this._hwnd!=$active_win_hwnd)
			this._setActiveWindowData( $active_win_hwnd, this._isWindowALwaysOnTop() )
			
		else
			this._setActiveWindowData()
	}
	/**
	 */
	_setActiveWindowData( $hwnd:="", $on_top_state:="" )
	{
		this._previous_vindow	:= {"ahk_id":"","on_top_state":""}

		if( $hwnd )
			this._previous_vindow.ahk_id := $hwnd
		
		if( $on_top_state )
			this._previous_vindow.on_top_state := $on_top_state
	} 
	
	/** Activate & restore always on top state of previous window
	 */
	_restorePreviousWindow()
	{
		if ( ! this._previous_vindow.ahk_id )
			return
			
		WinActivate, % "ahk_id " this._previous_vindow.ahk_id
				
		$on_top_state := this._previous_vindow.on_top_state ? "On" : "Off"
		WinSet, AlwaysOnTop, %$on_top_state%, A
	}
	/**
	 */
	_isWindowALwaysOnTop()
	{
		WinGet, ExStyle, ExStyle, A
		return (ExStyle & 0x8) == 8 ? true : false
	} 



}