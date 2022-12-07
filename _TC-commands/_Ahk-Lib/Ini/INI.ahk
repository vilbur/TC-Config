/**
	Class INI

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	ENCODING of ini file MUST BE ASCII - UTF-8 DOES NOT READ FIRST LINE
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/
Class INI {
	
	static ini := { "path":""}

	/*
		@param string $file_path path to ini file, DEFAULT: A_ScriptDir\scriptName.ini
	*/
	__New($file_path:=""){
		this.file($file_path)
	}
	
	/*
	-----------------------------------------------
		PUBLIC METHODS
	-----------------------------------------------
	*/
	/** set ini File
	  	@param string $file_path path to ini file, DEFAULT: A_ScriptDir\scriptName.ini

	*/
	file($file_path:="")
	{		
		this.ini.path := ! $file_path ? this._repalceExtensionToIni(A_ScriptFullPath) : $file_path
	
		if( ! this._isPathAbsolute() )
			this.ini.path := this._getAbsolutePath(A_ScriptDir, this.ini.path)
				
		this._loadIni()
		return this
	}
	/** create
	*/
	create(){
		FileAppend,, % this.ini.path
		return this
	}
	/*
	*/
	set($section,$key:="",$value:=""){
		
		if(isObject($section))
			this._setSectionObject($section)
		else if(isObject($key))
			this._setKeyObject($section, $key)
		else
			this._setValue($section, $key, $value)

		return this
	}
	/*
	*/
	delete($section,$key:=""){
		if ($key)
			this._deleteKey($section, $key)
		else
			this._deleteSection($section)
		return this
	}
	/*
	*/
	get($section:="",$key:=""){
		;dump($section, "$section", 1)
		if ($section!="" && $key!="")
			return % this[$section][$key]
		if ($section!="")
			return % this[$section]
		return % this
	}
	/* @return array of all sections in ini file
	*/
	getSections(){
		;$sections := Array()
		;For $section, $data in % this
		;	$sections.insert($section)
		IniRead, $sections, % this.ini.path
		return % StrSplit( $sections, "`n")
	}
	
	/* @return array of all keys in section
	*/
	getKeys($section)
	{
		$keys := []
		For $key, $value in % this[$section]
			$keys.push($key)
		return %$keys%
	}
	/* @return array of all values in section
	*/
	getValues($section)
	{
		$values := []
		For $key, $value in % this[$section]
			$values.push($value)
		return %$values%
	}
	
	/**
		@return int length of section or all ini
	  */
	length($section:="")
	{
		if($section!="")
			return % this._objectLength(this[$section])
		else {
			$all_count := 0
			For $i, $section in this.getSections()
				$all_count += this._objectLength(this[$section])
			return %$all_count%
		}
	}
	/* get all values for key from all sections
	   @return array of listed values
	*/
	lists($key, $array:=0)
	{
		$items_array	:= []
		$items_object	:= {}	
		For $section, $section_data in this
			if($section_data[$key])
				if($array)
					$items_array.push($section_data[$key])
				else
					$items_object[$section] := $section_data[$key]

		return % $array ? $items_array : $items_object
	}


	/** flattern whole ini to one object
		@return {key:value}
	*/
	flattern(){
		$flattern := {}
		For $section, $section_data in this
			$flattern := this._mergeObjects($flattern, $section_data)

		return %$flattern%
	}
	/** setDefaults
	*/
	setDefaults($default_data:="", $overwrite:=0){
		;dump($default_data, "$default_data", 1)
		If ( this.length()==0 || $overwrite==1 ){
			;if(FileExist( this.ini.path ))
			this._deleteFile().create()
			if($default_data!="")
				this.set($default_data)
		}
		;sleep,50000
		return this
	}
	/*---------------------------------------------
		PRIVATE METHODS
	-----------------------------------------------
	*/
	
	/*
		====== LAOD DATA ======
	*/
	/** _loadIni
	*/
	_loadIni()
	{
		IniRead, $sections, % this.ini.path
			loop, Parse, $sections, `n
				this[A_LoopField] := this._loadSection(A_LoopField)
	}
	/* @return object of sections keys and values
	*/
	_loadSection($section)
	{
		IniRead, $section_data, % this.ini.path, %$section%
		return % this._loadSectionValues($section_data)
	}
	/* @return object of keys and values parsed from ini string
	*/
	_loadSectionValues($section_data)
	{
		$section := Object()
		loop, Parse, $section_data, "`n", "`r"
		{
			RegExMatch( A_LoopField, "i)^([^\=]+)\=*(.*)", $key_value )
			$section[$key_value1] := $key_value2
		}
		return %$section%
	}
	/*
		====== SET DATA ======
	*/

	/** _setSectionObject
	*/
	_setSectionObject($data)
	{
		For $section, $pair_obj in $data
			this._setKeyObject($section, $pair_obj)
	}
	/** _setKeyObject
	*/
	_setKeyObject($section, $pair_obj)
	{
		For $key, $value in $pair_obj
			this._setValue($section, $key, $value)
	}
	/** _setValue
		@param	string $section	for keep in order, can be prefixed with index E.G: "{1}section-1"
		@param	string $key	for keep in order, can be prefixed with index E.G: "{1}key-1"
		@param	string $value
	*/
	_setValue($section,$key:="",$value:="")
	{
		$section	:= this._removeIndexPrefix($section)
		$key	:= this._removeIndexPrefix($key)

		IniWrite, %$value%, % this.ini.path, %$section%, %$key%
		this._setDataValue($section, $key, $value)
	}
	/** _setDataValue
	*/
	_setDataValue($section,$key:="",$value:="")
	{			
		if( ! this[$section] )
			this[$section]	:= {}
		this[$section][$key] := $value

		return this
	}

	/*
		====== DELETE DATA ======
	*/
	/*
	*/
	_deleteSection($section){
		IniDelete, % this.ini.path, %$section%
		;this.delete($section)
		this[$section] := ""		
		
	}
	/*
	*/
	_deleteKey($section, $key){
		IniDelete, % this.ini.path, %$section%, %$key%
		this[$section].delete($key)
	}

	
	
	/*
		====== HELPERS ======
	*/
	/**
	 */
	_isPathAbsolute( $path )
	{
		return % RegExMatch( this.ini.path, "i)^[A-Z]:[\\\/]" )
	} 
	/** _repalceExtensionToIni
	*/
	_repalceExtensionToIni($file_path)
	{
		return %  RegExReplace( $file_path, "\.(ahk|exe)$", ".ini" )
	}
		
	 /** Combine absolute and relative paths
	 */
	_getAbsolutePath( $absolute, $relative)
	{
		$absolute := RegExReplace( $absolute, "\\$", "" ) ;;; remove last  slash\
		$relative := RegExReplace( RegExReplace( $relative, "^\\", "" ), "/+", "\" ) ;" ; remove first \slash, flip slashes

		VarSetCapacity($dest, (A_IsUnicode ? 2 : 1) * 260, 1) ; MAX_PATH
		DllCall("Shlwapi.dll\PathCombine", "UInt", &$dest, "UInt", &$absolute, "UInt", &$relative)
		return RegExReplace( $dest, "\\+", "\" ) ; "
	}
		
	/**	remove key index prefix E.G: "{1}fooKey" >>> "fooKey"
	*/
	_removeIndexPrefix($string:=""){
		return % RegExReplace( $string, "^(;)*{\d+}", "$1" )
	}	
	/** _objectLength
	*/
	_objectLength($obj){
		$count	:= 0
		for $key, $value in $obj
			$count++
		return %$count%
	}


	/** _mergeObjects
	*/
	_mergeObjects($obj_1, $obj_2){
		For $key, $value in $obj_2
			$obj_1[$key] := $value
		return %$obj_1%
	}
	


	/** delete
	*/
	_deleteFile(){
		FileDelete, % this.ini.path
		return this
	}


}

/**
	CALL CLASS FUNCTION
*/
INI($file_path:=""){
	return % new INI($file_path)
}
