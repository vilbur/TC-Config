#SingleInstance force


/** Class CreateClassFile
*/
Class CreateClassFile
{
	_class_name	:= ""
	_class_folder	:= ""	
	_path_dir	:= ""
	_path_file	:= ""	
	_test_file	:= "" 		
	_includes	:= false ; create includes file
	
	__New()
	{		
		this._askClassName()
		this._askClassFolder()		
		
		this._setPathDir()
		this._setPathFile()			
		
		this._createFolder()
		this._createTestFile()
		
		this._setToIncludes()
		
		this._appendClassFile()
		this._appendTestFile()
		
	}
	
	/**
	 */
	_askClassName()
	{
		InputBox, $class_name, CREATE CLASS FILE, Enter Class name,, , 128,
		;X, Y, Font, Timeout, Default
		if ( ErrorLevel || ! $class_name )
			ExitApp
		
		this._class_name	:= $class_name
		
		clipboard	= %$class_name% 
	}
	/**
	 */
	_askClassFolder()
	{
		MsgBox, 4, CREATE CLASS FOLDER, Create folder for file ?
		IfMsgBox, No
			return 
		
		this._class_folder := this._class_name "\\"
	}
	/**
	 */
	_setPathDir()
	{
		this._path_dir	:= A_WorkingDir "\\" this._class_folder
	}
	/**
	 */
	_setPathFile()
	{
		this._path_file	:= RegExReplace( this._path_dir "\\" this._class_name ".ahk", "\\+", "\" ) ; "
	}

	/**
	 */
	_createFolder()
	{
		FileCreateDir, % this._path_dir 
	}
	/**
	 */
	_createTestFile()
	{
		MsgBox, 4, CREATE TEST FILE, Create test file ?
		IfMsgBox, No
			return 
		
		this._test_file := true
		FileCreateDir, % this._path_dir "\\Test"
	}
	/**
	 */
	_appendClassFile()
	{
		FileDelete, % this._path_file
		FileAppend, % this._getClassDefinition( this._class_name ), % this._path_file
	}
	/**
	 */
	_appendTestFile()
	{
		$test_file	:= this._path_dir "\Test\\" this._class_name "Test.ahk"
		
		FileDelete, %$test_file% 
		FileAppend, % this._getTestFileContent(this._class_name), %$test_file%
	}
	/**
	 */
	_getClassDefinition( $class_name )
	{
		$includes = \..\includes.ahk
		
		$class_def :=	[(this._includes ? "#Include %A_LineFile%\..\includes.ahk`n`n": "") "/** " $class_name
			," *"
			," */"
			,"Class " $class_name
			,"{"
			,"	"
			,"}"]
		
		return this._joinObject($class_def)	
	}
	/**
	 */
	_getTestFileContent( $class_name )
	{
		;$include_path	:= this._test_file ? ""
		$include_path	= \..\..\%$class_name%
		
		$test_file_content :=	["#SingleInstance force"
			,""			
			,"#Include %A_LineFile%" $include_path ".ahk"
			,""
			,"$" $class_name " 	:= new " $class_name "()"
			,""
			,"/** " $class_name "Test","*/"
			,$class_name "Test()" ,"{" ,"" ,"}"
			,""			
			,"/*---------------------------------------"
			,"	RUN TESTS"
			, "-----------------------------------------"
			,"*/"		
			,$class_name "Test()"
			,""]
		
		
		
		return this._joinObject($test_file_content)	
	}
	/** join object
	 */
	_joinObject($object, $delimeter:="`n")
	{
		For $key, $value in $object
			$string .= $value $delimeter
		
		return % SubStr( $string, 1, StrLen($string) - (StrLen($delimeter)) )
	}
	
	
	/** search for in tree for .git folder
	 */
	_setToIncludes()
	{
		MsgBox, 4, INSERT TO INCLUDES, Insert to include files ?
		IfMsgBox, No
			return this._createIncludeFile()
		
		$includes_path := this._findIncludeFile()
		
		if( $includes_path ){
			MsgBox, 4, INSERT TO INCLUDES, % "Include to ?`n`n" $includes_path
			IfMsgBox, No
				return
		}else
			FileSelectFile, $includes_path , , % this._path_dir, Select Include File, Ahk files (*.ahk)


		if( $includes_path )
		{
			$relative_path := this.PathRelativePathTo( $includes_path, this._path_file )			

			$relative_path = \%$relative_path%
			
			FileAppend, % "`n#Include %A_LineFile%" $relative_path, %$includes_path%
		}
	}
	/**
	 */
	_createIncludeFile()
	{
		MsgBox, 4, CREATE INCLUDE FILE, % "Create includes.ahk ?"
			IfMsgBox, No
				return
		
		this._includes := true
		
		FileAppend, % "/**`n *`n */", % this._path_dir "\includes.ahk"
	} 
	/**
	 */
	_findIncludeFile()
	{
		$path	:= this._path_dir
		
		While $path != $drive
		{
			if( FileExist($path "\includes.ahk") ){
				$includes_path	:= $path "\includes.ahk"
				break
			}
			SplitPath, $path,, $path,,, $drive
		}
		
		return % RegExReplace( $includes_path, "\\+", "\" ) 	; "
	} 
	
	
	/** Combine absolute and relative paths
	 */
	PathRelativePathTo(from,to)
	{
		static PathRelativePathTo:=DllCall("GetProcAddress","PTR",DllCall("LoadLibrary","Str","Shlwapi.dll"),"AStr","PathRelativePathTo" (A_IsUnicode?"W":"A"),"PTR")
				,FAD:=16,pszPath,init:=VarSetCapacity(pszPath,MAX_PATH:=260)
		If DllCall(PathRelativePathTo,"PTR",&pszPath,"STR",from,"UInt",InStr(from,"D")?FAD:0,"Str",To,"UInt",InStr(to,"D")?FAD:0)
			Return StrGet(&pszPath)
		else return -1
	}
	
	
}


new CreateClassFile()

ExitApp








