#SingleInstance force
#Include  %A_LineFile%\..\..\TotalCommander\TotalCommander.ahk

class copyBakOrRestore{

	TotalCommander	:= new TotalCommander()
	file_list	:= this.TotalCommander.Selection.get()

	/** __New
	*/
	__New(){
		;dump(this.file_list, "this.file_list", 1)
		;;sleep, 20000
		this._loopFielList()
		this.TotalCommander.reload()
	}
	/** _loopFielList
	*/
	_loopFielList(){
		For $i, $path in this.file_list
			this._bakOrRestore($path)
		MsgBox,262144,, Success,1
	}
	/** _bakOrRestore
	*/
	_bakOrRestore($path){
		if(!RegExMatch( $path, "i).bak$"))
			this._bakPath($path)
		else
			this._restorePath($path)
	}
	/** _bakPath
	*/
	_bakPath($path){
		File($path).copy($path ".bak", true)

	}
	/** _restorePath
	*/
	_restorePath($path){
		$restore	:= true
		$target	:= RegExReplace( $path, "i).bak$", "" )
		If FileExist( $target )
			MsgBox, 260,RESTORED FILE EXIS, DO YOU WANT OVERRITE ?`n`n %$target%
			IfMsgBox, No
				$restore	:= false
		if($restore)
			File($path).copy($target, true)

	}
}
/* CALL CLASS FUNCTION
*/
new copyBakOrRestore()
exitApp
