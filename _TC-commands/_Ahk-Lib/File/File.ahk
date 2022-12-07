/**
	Class File
*/
#Include %A_LineFile%\..\Path\Path.ahk 
#Include %A_LineFile%\..\..\RegEx\RegExMatchAll.ahk 

Class File extends Path
{

	__New($path){
		;dump($path, "----File PATH", 0)
		this.setPath($path)
	}
	/*
	-----------------------------------------------
		CRUD METHODS
	-----------------------------------------------
	*/

	/** create file
	*/
	create($content:="", $overwrite:=0, $encoding:="UTF-8"){
		;dump(this._doNotOverwrite($overwrite), "this._doNotOverwrite($overwrite)", 0)
		if (this._doNotOverwrite($overwrite))
			return ; DO NOT OVERWRITE FILE
		FileDelete, % this.path
		FileAppend,	%$content%, % this.path, %$encoding%
		return this
	}
	/** append
	*/
	append($content:=""){
		FileAppend,	%$content%, % this.path
		return this
	}
	;/** createDir
	;  @param string $dir relative path to create dir
	;*/
	;createDir($dir:=""){
	;	;dump(this.path , "createDir", 0)
	;	FileCreateDir, % this.path "\\" $dir
	;	return this
	;}
	;/** createParentDir
	;*/
	;createParentDir(){
	;	;dump(this.parentDir(), "createParentDir()", 1)
	;	FileCreateDir, % this.parentDir()
	;	return this
	;}
	/** delete file
	  @param boolean $confirm deletion
	*/
	delete($confirm:=""){
		;$delete	:= true
		if not (this.exist()) ;;; return if not exists or is not file
			return

		if($confirm!="" || $confirm!==false){
			MsgBox, 4,, % "DELETE FILE ?`n" this.path
			IfMsgBox No
				$delete	:= false
		}
		if($delete!=false)
			if(this.isFile())
				FileDelete, % this.path
			else
				FileRemoveDir, % this.path

		return this
	}
	/** filename
		@param boolean $ext filename with extension, if $ext==false return filename WITHOUT extension
		@return string full filename or without extension
	*/
	filename($ext:=true){
		SplitPath, % this.path, $filename,,, $filename_noext
		return % $ext ? $filename : $filename_noext
	}
	/** ext
	*/
	ext(){
		SplitPath, % this.path,,,$ext
		return %$ext%
	}
	/** clear file content
	*/
	clear(){
		this.create("",true)
	}
	/*
	-----------------------------------------------
		COPY\MOVE METHODS
	-----------------------------------------------
	*/
	/** copy
	*/
	copy($target_path, $overwrite:=true){
		;dump($target_path, "copy ()$target_path", 1)
		this._setTarget($target_path)
		;dump(this.target, "copy ()target", 1)

		if(this.isMaskAll())
			this.path := this.parentDir()

		;dump(this.getPath(), "this.getPath", 0)
		;dump(this.target.getPath(), "this.target", 0)

		this.target.createParentDir()
		if(this.isDir())
			FileCopyDir, % this.path, % this.target.getPath(), %$overwrite%
		else
			FileCopy, % this.path, % this.target.getPath(), %$overwrite%
		return this
	}
	;;/** _backupTarget
	;;*/
	;;_backupTarget($overwrite){
	;;	if( !RegExMatch( $overwrite, "i)[0-9]" ) && RegExMatch( $overwrite, "i)\.*[A-Z0-9]+" ))
	;;		dump($overwrite, "$overwrite", 0)
	;;		;dump(this.target.getPath(), "this.target", 0)
	;;
	;;}
	/** move
	*/
	move($target_path, $overwrite:=true){
		;;;if ($overwrite!=true && new this($target_path).exist())
			;;;return ; DO NOT OVERWRITE FILE
		this._setTarget($target_path)
		;dump($target_path, "move() target_path", 1)
		if(this.isFile())
			FileMove, % this.path, % this.target.getPath(), %$overwrite%
		else {
			$overwrite := $overwrite ? 2 :"R"
			FileMoveDir, % this.path, % this.target.getPath(), %$overwrite%
		}
		return this
	}
	/*
	-----------------------------------------------
		HARDLINK\SHORTCUT METHODS
	-----------------------------------------------
	*/
	/** hardlink
	*/
	hardlink($target_path, $backup:=true, $suffix:="linkbak"){
		if(!RegExMatch( $suffix, "i)\.[A-Z]+$" ))
			$suffix	:= "." $suffix

		this._setTarget($target_path)
		if (!this.exist() || $source.isHardlink())
			return this
		;dump(this.target, "this.target", 0)
		if(this.target.exist()){
			if($backup==true && !this.target.isHardlink())
				this.target.move(this.target.filename() $suffix, false)
			else
				this.target.delete()
		}else
			this.target.createParentDir()

		$file_or_folder	:= this.isDir() ? "/d" : "/h"
		$mklink	:= "mklink " $file_or_folder " """ this.target.getPath() """ """ this.path """"
		RunWait %comspec% /c %$mklink%,,Hide
		return this
	}
	/** shortcut
	*/
	shortcut($target_path){
		this._setTarget($target_path)
		this.target.createParentDir()
		;dump(this.target, "this.target", 1)
		;$shortcut_path	:= RegExMatch( this.target.getPath(), "i).lnk$" ) ? this.target.getPath() : this.target.getPath() ".lnk"
		$shortcut_path	:= RegExReplace( this.target.getPath(), "\.\w+$", ".lnk" )

		;dump($shortcut_path, "$shortcut_path", 0)
		FileCreateShortcut, % this.path, %$shortcut_path%
		return this
	}
	/*
	-----------------------------------------------
		PRIVATE METHODS
	-----------------------------------------------
	*/
	/** _overwrite
	*/
	_doNotOverwrite($overwrite){
		return % this.exist() && $overwrite==false
	}
	/*
	-----------------------------------------------
		TARGET METHODS
	-----------------------------------------------
	*/
	/** _setTarget
		"C:\absolute\file.txt"	; absolute path to file
		"\relative\path\to\dir"	; relative path to folder
		"\relative\copy\to\dir\"	; copy\move TO dir
		@param string $target_path path to target for copy|move|hardlink|shortcut
	*/
	_setTarget($target_path){
		this.target	:= new File($target_path)
		this._setTargetBasename()
		this._setOriginToRelativePath()
	}
	/** _setOriginToRelativePath
	*/
	_setOriginToRelativePath(){
		if(this.target.isAbsolute())
			return

		$target_origin	:= this.target.split().MaxIndex()==1 || this.isMaskAll() ? this.parentDir() : this.path
		;dump(this, "this", 0)
		;dump($target_origin, "$target_origin", 0)
		this.target	:= new this($target_origin).combine(this.target.getPath())
	}
	/** _setTargetBasename
	*/
	_setTargetBasename(){
		;dump(this.target.hasTrailingSlash(), "_setTargetBasename()", 0)
		if(this.target.hasTrailingSlash())
			this.target.combine(this.basename())
	}


}

/**
	CALL CLASS FUNCTION
*/
File($path:=""){
	return % new File($path)
}
