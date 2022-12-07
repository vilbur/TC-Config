#Include %A_LineFile%\..\..\TcCommanderPath\TcCommanderPath.ahk

/* Class TcCore
*/
Class TcCore extends TcCommanderPath
{
	_wincmd_ini	:= ""	
	_process_name	:= ""	
	_hwnd	:= ""

	/** Init core
	  9 must be called in __New() mehthod in class which extends TcCore
	 */
	initCore()
	{
		this._setCommanderPath()
		this._setIniFile( "wincmd.ini" )
		this._setProcessName()
		this._setHwnd()
	}
	/**
	 */
	ahkId()
	{
		return % "ahk_id " this._hwnd
	}
	/**
	 */
	proccesName()
	{
		return % this._process_name
	}
	/**
	 */
	_setProcessName()
	{
		WinGet, $process_name , ProcessName, ahk_class TTOTAL_CMD
		this._process_name := $process_name
	}
	/**
	 */
	_setHwnd()
	{
		WinGet, $hwnd , ID, ahk_class TTOTAL_CMD
		this._hwnd := $hwnd
	}

	/*---------------------------------------
		COMMANDS
	-----------------------------------------
	*/
	/** Command: ConfigSAveSettings
	 */
	saveConfig()
	{
		SendMessage  1075, 580, 0, , % this.ahkId()
		return this
	}
	/** Command: RereadSource
	 */
	refresh()
	{
		SendMessage  1075, 540, 0, , % this.ahkId()
		return this
	}
	
	
	

}