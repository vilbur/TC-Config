;#NoTrayIcon
#SingleInstance ignore


/**
	Class TcEditors
*/
Class TcEditors {
	
	INI	:= INI()
	editors_path	:= this.INI.get("path","td_editors_dir")
	;editor_title	:= {"":1}
	__New(){
		
	}
	/** setEditorTitle
	*/
	setEditorTitle($editor_title){
		this.editor_title := $editor_title
		return this
	}
	/** openEditor
	*/
	openEditor(){
		if(!this._activateWindow())
			this._openNewInstance()

		return this		
	}

	/** _activateIfExists
	*/
	_activateWindow(){
		setTitleMatchMode, 2
		IfWinExist, % this.editor_title
		{
			WinActivate, % this.editor_title
			return true
		}
	}
	/** _openNewInstance
	*/
	_openNewInstance(){
		;Run, % this._getEditorPath()
		$pos := this.INI.get(this.editor_title)
		;SetWinDelay, 500		
		;dump(this, "TcEditors", 1)
		;dump(this._getEditorPath(), "this._getEditorPath()", 0)
		this.window := Window().run(this._getEditorPath())
								.winWait(5,1000)
								.setMonitor($pos.monitor)
								.setPosition($pos.X, $pos.Y)
								.setSize($pos.width, $pos.height)		
		;dump(this.window, ".window", 1)
		this._postOpenFn()
	}
	/** _getPath
	*/
	_getEditorPath(){
		$exe_file := RegExMatch( this.editor_title, "i)Directory|Commands" ) ? "Start Menu Editor.exe" : this.editor_title ".exe"
		;dump($exe_file, "$exe_file", 0)
		return % File(this.editors_path "\\" $exe_file).getPath()
		;return % this.editors_path "\\" this.editor_title ".exe"	
	}
	/** _postOpenFn
	  ; select section ion window
	*/
	_postOpenFn(){
		SetKeyDelay , 200

		$dropdown	:= RegExMatch(this.editor_title, "i)(Commands|Directory)",	$match ) ? ($match1=="Commands" ?"{f7}"	:"{f6}") : ""
		$treeview	:= RegExMatch(this.editor_title, "i)Commands")	? "{down}{enter}" : ""
		$listview	:= RegExMatch(this.editor_title, "i)Hotkeys|Main")	? "{PgDn}" : ""
		
		if($dropdown!="")
			ControlSend,Edit1, %$dropdown%, % this.window.getPid()
		if($treeview!="")
			ControlSend,TreeView20WndClass1, %$treeview%, % this.window.getPid()
		if($listview!="")
			ControlSend,ListView20WndClass1, %$listview%, % this.window.getPid()
			

	}

	
}

/**
	CALL CLASS FUNCTION
*/
TcEditors(){
	return % new TcEditors()
}
/**
	EXECUTE CALL CLASS FUNCTION
*/
$editor_title = %1%
TcEditors().setEditorTitle($editor_title).openEditor()
exitApp