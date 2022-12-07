/** Class TCcommand
*/
Class TCcommand
{
	_process_name	:= ""
	_hwnd	:= ""
	
	_command_line	:= ""
	_codes_ini	:= "" ; save 	
	
	_cmd	:= ""	; command name
	_CM	:= 0 	; command code
	_EM	:= false	; is user command
	
	/** _setTabsPath
	 */
	__New()
	{
		this._setProcessName()
		this._setHwnd()
		this._setCommandLineControl()		
		
		$_usercmd_ini	= %Commander_Path%\usercmd.ini
		this._usercmd_ini	:= $_usercmd_ini
		
		$_codes_ini	= %Commander_Path%\TOTALCMD.INC				
		this._codes_ini	:= $_codes_ini
	}
	/**
	 */
	call( $cmd, $wait:=0 )
	{
		this._cmd := $cmd		
		
		this._findDefaultCommand()

		if( ! this._CM )
			this._findUserCommand()
		
		this._wait($wait)
		
		if( this._CM )
			this._callDefaultCommand()
			
		else if( this._EM )
			this._calllUserCommand()
			
		return this
	}

	/**
	 */
	_findDefaultCommand()
	{
		if( InStr( this._cmd, "em_" ) )
			return 
		
		$cmd_search := InStr( this._cmd, "cm_" )? this._cmd : "cm_" this._cmd
		
		loop Read, % this._codes_ini
			if( InStr(A_LoopReadLine, $cmd_search) )
			{
				this._CM := RegExReplace( A_LoopReadLine, "^[^=]+=(\d+).*", "$1" )
				break			
			}
	}
	/**
	 */
	_findUserCommand()
	{
		$cmd_search := InStr( this._cmd, "em_" )? this._cmd : "em_" this._cmd
		
		IniRead, $command_found, % this._usercmd_ini, %$cmd_search%
		
		this._EM := $command_found!="ERROR" ? true : false
	}
	/**
	 */
	_callDefaultCommand()
	{			
		SendMessage  1075, this._CM, 0, , ahk_class TTOTAL_CMD
	} 
	/**
	 */
	_calllUserCommand()
	{
		this._focusCommandLine()
		this._sendCommand()
		this._fireCommand()		
	}
	/**
	 */
	_wait($wait)
	{
		if( $wait )
			sleep, %$wait%
	}
	
	/*---------------------------------------
		INIT
	-----------------------------------------
	*/
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
		Total commander command line
	-----------------------------------------
	*/
	/**
	 */
	_setCommandLineControl()
	{
		this._command_line := this._process_name == "TOTALCMD.EXE" ? "Edit1" : "Edit2"
	} 
	/**
	 */
	_focusCommandLine()
	{
		ControlFocus, % this._command_line, % "ahk_id " this._hwnd
	} 
	/**
	 */
	_sendCommand()
	{
		$user_cmd	:= InStr( this._cmd, "em_" )? this._cmd : "em_" this._cmd
		$BackUpClip 	:= ClipboardAll ; ClipboardAll must be on its own line
		Clipboard	:= $user_cmd
		
		ClipWait, 10
		SendInput, ^v
		Clipboard := $BackUpClip
	}
	/**
	 */
	_fireCommand()
	{
		ControlSend, % this._command_line, {Enter}, % "ahk_id " this._hwnd
	} 

 
}
