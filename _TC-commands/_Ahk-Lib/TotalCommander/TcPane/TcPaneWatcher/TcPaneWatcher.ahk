#SingleInstance force
;#NoTrayIcon
Menu, Tray, Icon, %A_LineFile%\..\ico\TcPaneWatcher.ico,, ;;; Show icon for debbuging

global $TcPaneWatcher
global $CLSID

/** Watch Total Commander and get source pane every time Total commander lost focus
 *
 *	TcPaneWatcher has its own file, reason is that it use OnMessage(), in this way OnMessage does not collide with others OnMessages  
 *	TcPaneWatcher is accessible via ComObject
 * 
 * @param	{hwnd:control_class}	_active_panes	store last used control class, key is hwnd of Total Commander (for use on multiple instances)
 *
 * @method	self	hwnd( integer $hwnd  )	
 * @method	string	activePane( integer $hwnd )	get last focused control class 
 * @method	void	exit()	exit script
 *       
 */
Class TcPaneWatcher
{
	_active_panes	:= {}
	_hwnd_msg	:= 0

	/** Set hwnd for identification of Total Commander
	 *		
	 *	@param	integer	$hwnd	hwnd of Total Commander 
	 */
	hwnd( $hwnd_tc )
	{
		this._registerMessage()

		this._active_panes[$hwnd_tc]	:= ""
		
		this.initCoreActivePane( $hwnd_tc )
		
		return this
	}
	/** Set last used control
	 *
	 * 	@param	integer	$hwnd	hwnd of Total Commander
	 * 	@param	string	$source_pane	ClassNN of source pane
	 * 
	 */
	setActivePane( $hwnd_tc, $source_pane:="" )
	{
		if( ! $source_pane )
			ControlGetFocus, $source_pane, ahk_id %$hwnd_tc%

		if( this._isFileListControl( $source_pane ) )
			this._active_panes[$hwnd_tc] := $source_pane
	}
	/** Get last focused pane
	  * @param	integer	$hwnd	hwnd of Total Commander 
	 */
	activePane( $hwnd_tc )
	{
		return % this._active_panes[$hwnd_tc]
	}
	/** Exit TcPaneWatcher script
	 */
	exit()
	{
		ExitApp
	}
	/**
	 */
	initCoreActivePane( $hwnd_tc )
	{
		$last_win := $hwnd_tc
		
		if( WinActive("ahk_id " $hwnd_tc) )
			this.setActivePane( $hwnd_tc )
	} 
	/** Set callback on focus change
	 */
	_registerMessage()
	{
		Gui +LastFound
		this._hwnd_msg := WinExist()
		
		DllCall( "RegisterShellHookWindow", UInt,this._hwnd_msg )
		$MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
		OnMessage( $MsgNum, "onWindowChange" )
			
		return this
	}
	/**
	 */
	_deregisterMessage()
	{
		DllCall( "DeregisterShellHookWindow", "PTR", this._hwnd_msg )
	} 
	/** Set last used control on Total Commander lost focus
	  * Called by onWindowChange()
	  */
	_onTotalCommanderLostFocus( $hwnd_tc )
	{
		this.setActivePane( $hwnd_tc )
	}

	/** Make sure that last control was list box
	 */
	_isFileListControl( $control_class )
	{
		return % RegExMatch( $control_class, "LCLListBox|TMyListBox" ) 
	} 
	
}

/** On Total Commander Get\Lost focus
 */
onWindowChange(wParam, lParam)
{	
	if(  wParam!=32772 )
		return	
	
	WinGetClass, $win_class, ahk_id %lParam%

	if( $win_class == "TTOTAL_CMD" )
		SetTimer, WatchPane, 200
		
	 else 
		SetTimer, WatchPane, Off
	
}

/*

*/
registerTcPane(Object, CLSID, Flags:=0)
{
    static cookieJar := {}
    if (!CLSID) {
        if (cookie := cookieJar.Remove(Object)) != ""
            DllCall("oleaut32\RevokeActiveObject", "uint", cookie, "ptr", 0)
        return
    }
    if cookieJar[Object]
        throw Exception("Object is already registered", -1)
    VarSetCapacity(_clsid, 16, 0)
    if (hr := DllCall("ole32\CLSIDFromString", "wstr", CLSID, "ptr", &_clsid)) < 0
        throw Exception("Invalid CLSID", -1, CLSID)
    hr := DllCall("oleaut32\RegisterActiveObject"
        , "ptr", &Object, "ptr", &_clsid, "uint", Flags, "uint*", cookie
        , "uint")
    if hr < 0
        throw Exception(format("Error 0x{:x}", hr), -1)
    cookieJar[Object] := cookie
}


/** RUN WATCHER VIA FILE CALL
 */
$hwnd	= %1%
$CLSID	= %2%

registerTcPane(TcPaneWatcher, $CLSID)

$TcPaneWatcher := ComObjActive($CLSID)

$TcPaneWatcher.hwnd($hwnd)

return 


WatchPane:

WinGetClass, $win_class, A

if( $win_class=="TTOTAL_CMD" )
	$TcPaneWatcher.setActivePane( WinExist("A") )

return

