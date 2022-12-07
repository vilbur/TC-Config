#SingleInstance force

#Include %A_LineFile%\..\..\..\Lib\Ahk\Args.ahk
#Include %A_LineFile%\..\..\..\Lib\Ahk\Path.ahk

/*
   !!! IMPORTANT: COMPILED VERSION OF THIS FILE DOES NOT WORK CORRECTLY, it gets 1 file less (some problem with getting of passed parameters)

    write file list selection to file
    @param string $file_selection selected files,   	Total Commander parameter %S%
    @param string $paths folder paths,                	Total Commander parameter %P\%
    @param string $selection_file file for selection export	DEFAULT: "%temp%\tc_selection_filelist.txt"

    EXAMPLE in Total Commander:
        c:\Selection_filelist_to_file.ahk "%temp%\selection_list.txt" "%P\" %S

*/

/* Class GetSelectionListToFile
*/
Class GetSelectionListToFile
{

	selection_file	:= ""
	paths	:= ""
	files	:= ""
	file_list	:= []
	
	__New(){
		;MsgBox,262144,, GetSelectionListToFile,2 
		this.Args := Args()
		this._setSelectionFile()
		this._setPaths()
		this._setFiles()
		this._setFileList()
		;dump(this.file_list, "this.file_list", 1)
		;sleep, 5000
	}
	/** _setSelectionFile
	*/
	_setSelectionFile(){
		;Dump(this.selection_file, "this.selection_file", 1)
		this.selection_file := Path(this.Args.shift()).getPath()
	}
	/** _setPaths
	*/
	_setPaths(){
		this.paths := this.Args.shift()
	}
	/** _setFiles
	*/
	_setFiles(){
		if(this.Args.length())
			this.files := this.Args.get()
	}

	/** _setFileList
	*/
	_setFileList(){
		if(this.files)
			this._setFileListForOneFolder()
		else
			this._setFileListForMultipleFolders()
	}

	/** createFile
	*/
	createFile(){
		FileDelete, % this.selection_file
		$list_length := this.file_list.Length()
		Loop %$list_length%
			FileAppend, % this.file_list[A_Index] (A_Index<$list_length ? "`n":""), % this.selection_file
	}
	/** _setFileListForOneFolder
	*/
	_setFileListForOneFolder(){
		For $i, $file in this.files
			this.file_list.push(this.paths $file)
	}
	/** _setFileListForMultipleFolders
	*/
	_setFileListForMultipleFolders(){
		loop, Parse, % this.paths, %A_Space%
			this.file_list.push(A_LoopField)
	}

}

/* CALL CLASS FUNCTION
*/
GetSelectionListToFile(){
	return % new GetSelectionListToFile()
}

/* EXECUTE CALL CLASS FUNCTION
*/
GetSelectionListToFile().createFile()
exitApp