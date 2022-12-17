#SingleInstance force
#NoTrayIcon

#Include %A_LineFile%\..\..\..\TcActivate\TcActivate.ahk 

global $TcPaneWatcher
global $last_win
global $CLSID

/** Watch Total Commander and get source pane every time Total commander lost focus
 *
 *	Script has own file because of it use OnMessage(), in this way OnMessage does not collide with others OnMessages
 *	TcPaneWatcher is accesable via ComObject
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
	_TcActivate	:= new TcActivate()

	__New()
	{
		this._setOnWinMessage()
	}
	/** Set hwnd for identification of Total Commander
	 *		
	 *	@param	integer	$hwnd	hwnd of Total Commander 
	 */
	hwnd( $hwnd_tc )
	{
		this._active_panes[$hwnd_tc]	:= ""
		
		;this._TcActivate.hwnd(this._hwnd)

		this._initActivePane( $hwnd_tc )
		
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
		;MsgBox,262144,source_pane, %$source_pane%,3
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
	_initActivePane( $hwnd_tc )
	{
		$last_win := $hwnd_tc
		
		if( WinActive("ahk_id " $hwnd_tc) )
			this.setActivePane( $hwnd_tc )
	} 
	/** Set callback on focus change
	 */
	_setOnWinMessage()
	{
		Gui +LastFound
		$hwnd := WinExist()
		
		DllCall( "RegisterShellHookWindow", UInt,$hwnd )
		$MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
		OnMessage( $MsgNum, "onWindowChange" )
			
		return this
	}
	/** Set last used control on Total Commander lost focus
	  * Called by onWindowChange()
	  */
	_onTotalCommanderLostFocus( $hwnd_tc )
	{
		this._TcActivate.activate($hwnd_tc)
		
		this.setActivePane( $hwnd_tc )
				
		this._TcActivate.deactivate($hwnd_tc)
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
		
	WinGetClass, $last_class, ahk_id %$last_win%
		
	if( $last_class == "TTOTAL_CMD" )
	{
		;MsgBox,262144,, Lost Focus,2 
		$TcPaneWatcher._onTotalCommanderLostFocus( $last_win )
		
		$last_win := ""
	}
	
	WinGetClass, $win_class, ahk_id %lParam%
	
	if( $win_class=="TTOTAL_CMD" )
		$last_win := lParam		
}
/*
    ObjRegisterActive(Object, CLSID, Flags:=0)
    
        Registers an object as the active object for a given class ID.
        Requires AutoHotkey v1.1.17+; may crash earlier versions.
    
    Object:
            Any AutoHotkey object.
    CLSID:
            A GUID or ProgID of your own making.
            Pass an empty string to revoke (unregister) the object.
    Flags:
            One of the following values:
              0 (ACTIVEOBJECT_STRONG)
              1 (ACTIVEOBJECT_WEAK)
            Defaults to 0.
    
    Related:
        http://goo.gl/KJS4Dp - RegisterActiveObject
        http://goo.gl/no6XAS - ProgID
        http://goo.gl/obfmDc - CreateGUID()
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

$TcPaneWatcher := new TcPaneWatcher().hwnd($hwnd)

registerTcPane($TcPaneWatcher, $CLSID)
