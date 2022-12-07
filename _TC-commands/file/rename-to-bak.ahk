#SingleInstance force

#Include %A_LineFile%\..\..\_Ahk-Lib\TotalCommander\TcSelection\TcSelection.ahk

class copyBakOrRestore
{
	file_list	:= new TcSelection().getSelectionOrFocused()
	_message	:= ""
	
	/** __New
	*/
	__New()
	{
		if( this.file_list.length() > 0)
		{
			this._loopFielList()

			this._updateTotalCommander(this.file_list[1])
		}
	}
	/** _loopFielList
	*/
	_loopFielList()
	{
		For $i, $path in this.file_list
			this._bakOrRestore($path)
	}
	/** _bakOrRestore
	*/
	_bakOrRestore($path)
	{
		if( ! RegExMatch( $path, "i).bak$"))
			this._bakPath($path)
		else
			this._restorePath($path)
	}
	/** _bakPath
	*/
	_bakPath($path)
	{
		;MsgBox,262144,path, %$path%,3 
		FileCopy, %$path%, % $path ".bak", 1
		
		this._message := "File Backuped"
	}
	/** _restorePath
	*/
	_restorePath($path)
	{
		$restore	:= true
		$target	:= RegExReplace( $path, "i).bak$", "" )
		
		If FileExist( $target )
			MsgBox, 260,RESTORED FILE EXIS, DO YOU WANT OVERRITE ?`n`n %$target%
			IfMsgBox, No
				$restore	:= false
		if($restore)
			FileCopy, %$path%, %$target%, 1

		this._message := "File Restored"		
	}
	
	/**
	 */
	_updateTotalCommander($dir)
	{
		WinGet, $process_name , ProcessName, ahk_class TTOTAL_CMD
		Run, %COMMANDER_PATH%\%$process_name% /O /S /L=%$dir%
	}
	  
	
}
/* CALL CLASS FUNCTION
*/
new copyBakOrRestore()
exitApp
