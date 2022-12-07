#SingleInstance force

/** Purpose of test: Get focused control (file list) when Total commander window lost focus
  *
  *
  *
  * HOW TO TEST:
  *		1) Run this file in Total Commander  
  *		2) Focus any other window
  *		3) ClassNN of last focused pane will be writen in log.txt
  *       
 */
global $TcPaneWatcherCom
global $CLSID
global $last_win

$CLSID	:= "{6B39CAA1-A320-4CB0-8DB4-352AA81E460E}"


/** Set TcPaneWatcher to global variable
  *
  * If TcPaneWatcher is not runnning, then start it and Set 
  *
  *
  *
 */  
setPaneWatcher()
{
	$hwnd := WinExist("A")
		
	$last_win 	:= $hwnd

	try
	{
		$TcPaneWatcherCom := ComObjActive($CLSID)
		
		if( $TcPaneWatcherCom )
			$TcPaneWatcherCom.hwnd($hwnd)
			
		;MsgBox,262144,, Watcher exists,2 
	}
	catch
	{
		runPaneWatcher($hwnd)
		
		sleep, 100 ;;; Wait, ither wise watcher is executed multiple times
		
		setPaneWatcher()
	}
	
}
/** 
  * 
 */  
runPaneWatcher($hwnd)
{	
	Run, %A_LineFile%\..\..\TcPaneWatcher.ahk %$hwnd% %$CLSID%

	;setPaneWatcher()
}
/**  
 */
deleteLogFile()
{
	FileDelete, %A_LineFile%\..\log.txt
}

/**
 */
bindMessageOnWindowChange()
{
	Gui +LastFound
	hwnd := WinExist()
	
	DllCall( "RegisterShellHookWindow", UInt,hwnd )
	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
	OnMessage( MsgNum, "ShellMessage" )
}
/**
 */
ShellMessage(wParam, lParam)
{
	if( wParam!=32772 )
		return

	WinGetClass, $last_class, ahk_id %$last_win%
	
	/** ON TOTAL COMMANDER GET FOCUS 
	 */
	if( $last_class == "TTOTAL_CMD" )
	{
		if( ! $TcPaneWatcherCom )
			$TcPaneWatcherCom := ComObjActive($CLSID)
		
		sleep, 50 ; WAIT THEN TcPaneWatcher set active pane
		
		/** LOG LAST CONTROL TO FILE 
		 */
		;WinGetTitle, $win_title, ahk_id %$last_win%
		FileAppend, % (InStr( $win_title, "x64" )?"64bit":"32bit") ": " $TcPaneWatcherCom.activePane($last_win) "`n", %A_LineFile%\..\log.txt
		
		/** MESsAGE LAST CONTROL TO FILE 
		 */
		;MsgBox,262144,, % (InStr( $win_title, "x64" )?"64bit":"32bit") ": " $TcPaneWatcherCom.activePane($last_win),1
		
		$last_win := ""
	}
	
	WinGetClass, $active_class, ahk_id %lParam%

	/** ON TOTAL COMMANDER BLUR
	 */
	if( $active_class=="TTOTAL_CMD" )
		$last_win := lParam
	
}

/** RUN TEST 
 */  
deleteLogFile()
setPaneWatcher()
bindMessageOnWindowChange()
