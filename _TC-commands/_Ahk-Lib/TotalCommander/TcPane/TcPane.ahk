#Include %A_LineFile%\..\includes.ahk

global $CLSID

$CLSID	:= "{6B39CAA1-A320-4CB0-8DB4-352AA81E460E}"

/*	Pane

*/
Class TcPane extends TcControlClasses
{
	_TcPaneWatcher	:= ""
	_panes	:= {}	

	/** EXAMPLE OF _panes OBJECT:
	 *
	 * _panes := {paneClass:	{"side": "right|left"
	 *	,"hwnd":	integer
	 *	,"path":	{"class":	string
	 *	,"hwnd":	integer}}}
	 */
	__New()
	{
		this.initCore()
		
		this._setPaneClasses()
		this._setPathClasses()
		this._setListBoxAndPathToPair()
		
		this._setPanes()
		
		this._setTcPaneWatcher()
	}
	/** @return string path of active pane
	 *	
	 *	@param string pane 'left|right|source|target'
	 *	
	 *	@return string	path of required pane
	 */
	getPath($pane:="source")
	{
		return % this._getPathFromControl($pane)
	}
	
	/** Set\Get active pane
	 *	
	 *	@param string	$side "left|right|target" pane
	 *	
	 *	@return string "left|right"
	 */
	activePane($side:="")
	{
		$source_side	:= this._getPaneSide( this._getPaneClass("source") )
		
		if( ! $side )
			return $source_side
				
		if( $side!=$source_side )
			this._switchPanes()
		
		return this
	}

	/** Refresh pane
	 * 	Get current path and browse it again
	 * 
	 * @param string pane 'left|right|source|target'
	 */
	refresh($pane:="source")
	{
		$process_name	:= this._process_name
		$dir	:= """" . this.getPath($pane) . """"
		$pane	:= $pane == "source" ? "L" : "R"
		
		Run, %COMMANDER_PATH%\%$process_name% /O /S /%$pane%=%$dir%

		return this  
	}
	/**
	 */
	getHwnd( $pane:="source", $path_control:="" )
	{
		;$class := this._getPaneClass($pane)
		;Dump($class, $pane, 1)
		
		$pane_obj := this._panes[this._getPaneClass($pane)]
			
		return % $path_control ? $pane_obj.path.hwnd : $pane_obj.hwnd
	} 
	/*---------------------------------------
		GET PANES DATA
	-----------------------------------------
	*/
	/** @return string ClassNN of active pane
	 * 
	 * @param string pane 'left|right|source|target'
	 *
	 * @return	string	ClassNN of required pane
	 */
	_getPaneClass($pane)
	{
		if( RegExMatch( $pane, "i)left|right" ) )
			return % this._getPaneClassBySide($pane)
		
		$source_pane := this._TcPaneWatcher.activePane(this._hwnd)
		
		return % $pane=="source" ? $source_pane : this._getTargetPaneClass($source_pane)
	}
	/** @return string ClassNN of active pane
	 */
	_getTargetPaneClass($source_pane)
	{
		For $pane_class, $o in this._class_nn
			if( $pane_class != $source_pane )
				return $pane_class
	}
	
	/** Get pane class by side
	 * 
	 * @param string $side 'left|right'
	 * 
	 * @return	string	ClassNN of required pane
	 */
	_getPaneClassBySide($side)
	{		
		For $pane_class, $o in this._class_nn
			if( $side=="right" && A_Index == 1 || $side=="left" && A_Index == 2 )
				return $pane_class
	}
	/**
	 */
	_getPathFromControl($pane)
	{
		ControlGetText, $path,, % this._getAhkId($pane, "path")
		
		/* remove mask like "*.*" from end of path
		 */
		$path := RegExReplace( $path, "[\\\/]\*\.\*", "" ) 
		
		return $path
	}
	
	/*---------------------------------------
		SET _panes OBJECT
	-----------------------------------------
	*/
	/**
	 */
	_setPanes()
	{
		For $pane_class, $path_class in this._class_nn
			this._panes[$pane_class] := this._getPaneObject($pane_class, $path_class, A_Index)
	}
	/**
	 */
	_getPaneObject($pane_class, $path_class, $index)
	{
		return %	{"side":	$index == 1 ? "right" : "left"
			,"hwnd":	this._getControlHwnd($pane_class)
			,"path":	{"class":	$path_class
				,"hwnd":	this._getControlHwnd($path_class)}}
	}
	/**
	 */
	_getControlHwnd( $class_nn )
	{
		ControlGet, $hwnd, Hwnd,, %$class_nn%,  % this.ahkId()
		
		return $hwnd 
	}

	/*---------------------------------------
		TcPaneWatcher
	-----------------------------------------
	*/
	/** Get focused control (file list) when Total commander window lost focus
	 *		
	 */  
	_setTcPaneWatcher()
	{
		if( ! this._TcPaneWatcher )
			try
			{
				this._TcPaneWatcher := ComObjActive($CLSID).hwnd(this._hwnd)
			}
			catch
			{
				this._runTcPaneWatcher()
				
				sleep, 100
				
				this._setTcPaneWatcher()
			}
	}
	/** Get focused control (file list) when Total commander window lost focus
	  * 
	 */  
	_runTcPaneWatcher()
	{
		$hwnd := this._hwnd
		
		Run, %A_LineFile%\..\TcPaneWatcher\TcPaneWatcher.ahk %$hwnd% %$CLSID%
	}
	/**
	 */
	_getAhkId( $pane, $path_control:="" )
	{
		;$hwnd := this.getHwnd( $pane, $path_control )
		;Dump($hwnd, "hwnd", 1)
		
		;return % "ahk_id " $hwnd
		return % "ahk_id " this.getHwnd( $pane, $path_control )		
	}
	/** Get side of pane
	 * 
	 * @return string "left|right"
	 */
	_getPaneSide($pane_class_get)
	{
		For $pane_class, $o in this._class_nn
			if( $pane_class==$pane_class_get )
				return A_Index == 1 ? "right" : "left"
	}
	/*---------------------------------------
		HELPERS
	-----------------------------------------
	*/
	/**
	 */
	_switchPanes()
	{
		this._TcPaneWatcher.setactivePane( this._hwnd, this._getPaneClass("target") )

		ControlFocus, , % this._getAhkId( "target" )
	} 
	/*---------------------------------------
		FALLBACKS FOR OBSOLETE METHODS
	-----------------------------------------
	*/
	getSourcePaneClass(){
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getSourcePaneClass()`n`nCHANGE IT TO:`n	TcPane._getSourcePaneClass()"
	}
	getTargetPaneClass(){
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getTargetPaneClass()`n`nCHANGE IT TO:`n	TcPane._getTargetPaneClass()"
	}
	getPanedHwnd( $pane:="source" ){
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getPanedHwnd()`n`nCHANGE IT TO:`n	TcPane._getPanedHwnd()"
	}
	setActivePane(){
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.setActivePane()`n`nCHANGE IT TO:`n	TcPane.activePane('left|right')"
	}
	getActivePane(){
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getActivePane()`n`nCHANGE IT TO:`n	TcPane.activePane()"
	}
	getSourcePath()
	{
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getSourcePath()`n`nCHANGE IT TO:`n	TcPane.getPath('source')"
	}
	getTargetPath()
	{
		MsgBox,262144,, % "OBSOLETE METHOD:`n	TcPane.getTargetPath()`n`nCHANGE IT TO:`n	TcPane.getPath('target')"
	}
	
}



OnExit("KillTcPaneWatcher")

KillTcPaneWatcher(ExitReason, ExitCode)
{
	try
	{
		ComObjActive($CLSID).exit()
	}	
	
}