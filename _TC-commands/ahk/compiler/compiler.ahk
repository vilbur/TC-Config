 /** Compile *.ahk file to *exe
  *		
  *		@param	string	$source_file
  *		
  *		Auto assign icon if icon match "/filename.ico" OR "/icon/filename.ico" OR "/icons/filename.ico"
  *		Auto delete old compiled file
  *		
  */
Class Compiler
{
	_compiler_path	:= ""
	_compiled_file	:= ""	
	_icon_path	:= ""	
	
	__New()
	{
		$compiler_path	= %A_AhkPath%\..\Compiler\Ahk2Exe.exe	
		this._compiler_path	:= $compiler_path
				
	}
	
	/**
	 */
	sourceFile( $source_file )
	{
		SplitPath, $source_file, $file_name, $file_dir, $file_ext, $file_noext
		
		this._source_file	:= $source_file
		this._file_name	:= $file_noext
		this._source_dir	:= $file_dir

		this._confirmSourceFile()
		
		return this
	}
	/**
	 */
	compile()
	{
		this._setCompiledFilePath()
		this._deleteCompiledFile()				
		this._setIconPath()
		this._runCompiler()
		this._refresh()
		
		MsgBox,262144,, % this._file_name " Compiled",1
	}
	/**
	 */
	_runCompiler()
	{
		$icon := this._icon_path ? " /icon " this._icon_path : ""
	
		Run, % this._compiler_path " /in " this._source_file " /out  " this._compiled_file $icon
	} 
	
	/**
	 */
	_setCompiledFilePath()
	{
		this._compiled_file := this._source_dir "\\" this._file_name ".exe"
	}  
	/** _get Icon Path
		Default icon name = ScriptName.ico
	
		1. this._source_dir\icons\A_ScriptName.ico
		2. this._source_dir\A_ScriptName.ico
	
		@return string path to icon
	*/
	_setIconPath()
	{
		$paths := 	[this._source_dir "\\Icon"
			,this._source_dir "\\Icons"
			,this._source_dir]
	
		$icon_name	:= "\\" this._file_name ".ico"
	
		For $i, $path in $paths
			if(FileExist($path $icon_name))
				this._icon_path	:= $path $icon_name
	}
	/**
	 */
	_deleteCompiledFile()
	{
		if( FileExist(this._compiled_file) )
			FileDelete, % this._compiled_file   
			
	}  
	/**
	 */
	_confirmSourceFile()
	{
		if( ! FileExist(this._source_file) )
		   $message := "Source file does not exists"
		   
		if( ! RegExMatch( this._source_file, "i)\.ahk" ) )
			 $message := "Source file is not *.ahk`n`n" this._source_file

		if( ! $message )
			return
			
		MsgBox,262144,, %$message%
		
		ExitApp
	}  
	/** Command: RereadSource
	 */
	_refresh()
	{
		While( ! FileExist(this._compiled_file) )
			sleep, 100
		
		SendMessage  1075, 540, 0, , ahk_class TTOTAL_CMD

	}
}

$source_file	= %1%

$Compiler 	:= new Compiler().sourceFile($source_file).compile()