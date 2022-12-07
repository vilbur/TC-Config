#Include %A_LineFile%\..\..\..\RegEx\RegExMatchAll.ahk

/* Class Path manipulate with path
   strips path out of quotes, and whitespace on init
   replace environment variables on init
*/
Class Path {

	__New($path:=""){
		this.setPath($path)
	}
	/** setPath
	*/
	setPath($path){
		this.path := $path
		;dump($path, "----PATH", 0)
		this._replaceVariables()
		this._strip()
		this.replaceSlash()
		return this
	}
	/** getPath
	*/
	getPath(){
		;MsgBox,262144,, test, 2
		return % this.path
	}
	/** replaceSlash
	*/
	replaceSlash($slash:="\"){ ;"
		this.path := RegExReplace( this.path, "[\\\/]+", $slash )
	}
	/** basename
	*/
	basename(){
		$split := this.split()
		return % $split[$split.MaxIndex()]
	}
	/** createDir
	  @param string $dir relative path to create dir
	*/
	createDir($dir:=""){
		;dump(this.path , "createDir", 0)
		FileCreateDir, % this.path "\\" $dir
		return this
	}
	/** createParentDir
	*/
	createParentDir(){
		;dump(this.parentDir(), "createParentDir()", 1)
		FileCreateDir, % this.parentDir()
		return this
	}
	/** isSymbolicLink TODO
	*/
	isSymbolicLink(){

	}
	/** is Path Absolute
	*/
	isAbsolute(){
		return RegExMatch( this.path, "i)^[A-Z]:\\" )
	}
	/* Get path to parent dir
	*/
	parentDir() {
		$path_noslash := RegExReplace(this.path, "[\\\/]+$", "" )
		;dump($path_noslash, "$path_noslash", 0)
		SplitPath, $path_noslash,,$path_parent
		;dump($path_parent, "$path_parent", 0)
		return %$path_parent%
	}
	/* Get name parent folder of path
		parentDir("c:\dir3\dir2\dir1\file.txt", 1)	; Return parent folder: "dir1"
		parentDir("c:\dir3\dir2\dir1", 1)	; Return grandparent folder: dir2"

		@index int $index number of parent folder to return
		@return string parent folder name
	*/
	parentDirName($index:=1) {
		return % this._reverse_array(this.split())[$index +1]
	}

	/** Get path of current process
	  E.G: return "C:|TotalCommander\Totalcmd.exe" if scripts is launched from Total Commander
	  @return string
	*/
	currentProcess(){
		$PID = 0
		WinGet, $hWnd,, A
		DllCall("GetWindowThreadProcessId", "UInt", $hWnd, "UInt *", $PID)
		$hProcess := DllCall("OpenProcess",  "UInt", 0x400 | 0x10, "Int", False
										 ,  "UInt", $PID)
		$PathLength = 260*2
		VarSetCapacity($current_proccess_path, $PathLength, 0)
		DllCall("Psapi.dll\GetModuleFileNameExW", "UInt", $hProcess, "Int", 0
									 , "Str", $current_proccess_path, "UInt", $PathLength)
		DllCall("CloseHandle", "UInt", $hProcess)
		Return %$current_proccess_path%
	}
	/* Combine absolute with relative path		http://stackoverflow.com/questions/29783202/combine-absolute-path-with-a-relative-path-with-ahk
	   @param string $path_combine absolute or relative path to combine with this.path
	   @return strin full combined path
	*/
	combine($relative_path) {
		$absolute_path	:= this.path
		$relative_path	:= new this($relative_path).getPath()
		;dump($absolute_path, "$absolute_path", 0)
		;dump($relative_path, "$relative_path", 0)

		if ( FileExist($absolute_path) == "A") ;;; get dir if path to file
			SplitPath, $absolute_path ,, $absolute_path

		$absolute_path := RegExReplace( $absolute_path, "\\$", "" ) ;;; remove last  slash\
		$relative_path := RegExReplace( $relative_path, "^\\", "" ) ;;; remove first \slash
		$relative_path := RegExReplace( $relative_path, "/", "\" ) ;;; "

		VarSetCapacity($dest, (A_IsUnicode ? 2 : 1) * 260, 1) ; MAX_PATH
		DllCall("Shlwapi.dll\PathCombine", "UInt", &$dest, "UInt", &$absolute_path, "UInt", &$relative_path)
		this.path := $dest
		;dump(this.path, "combine()", 0)
		return this
	}

	/* 	test if path exist
		@param string|boolean $error_message if path does not exist: true=default message|string=custom message|blank=no message


		@return boolean
	*/
	exist($error_message:=""){
		$file_exists	:= FileExist(this.path)
		$message	:= $error_message==true ?  "PATH DOES NOT EXISTS`n`n"this.path : $error_message

		if(!$file_exists && $error_message!=""){
			MsgBox,262144,, %$message%
			ExitApp
		}

		return % $file_exists ? 1 : 0
	}
	/** isFile
	*/
	isFile(){
		return InStr(FileExist(this.path), "D") ? 0 : 1
	}
	/** isDir
	*/
	isDir(){
		return InStr(FileExist(this.path), "D")
	}
	/** isMaskAll Test if paths ends with "*.*"
	*/
	isMaskAll(){
		return % RegExMatch( this.path, "i)\*\.\*$" ) ? 1 : 0
	}
	/** isFileMask Test if paths ends with "*.*"
	*/
	isFileMask(){
		return % RegExMatch( this.path, "i)\*\.[A-Z0-9]+$" ) ? 1 : 0
	}
	/** hasTrailingSLash Test if paths ends with "*.*"
	*/
	hasTrailingSlash(){
		return % RegExMatch( this.path, "i)[\\\/]+$") ? 1 : 0
	}

	/** isHardlink
	   dir /s "c:\Users\All Users\" | find /i "<SYMLINK"
	   dir "c:\Users\vilbur\AppData\Local\Temp\_AHK_FileTest\SubDir1\" | find /i "<SYMLINK"
	*/
	isHardlink(){
		$objShell	:= ComObjCreate("WScript.Shell")
		$objExec	:= $objShell.Exec(comspec " /c dir """ this.parentDir() """ | find /i ""<SYMLINK""")
		$counter := 0
		While !$objExec.Status && $counter <= 100 {
			Sleep 100
			$counter++
		}
		$result := $objExec.StdOut.ReadAll()
		;dump($result, "$result", 0)
		if($counter==100){
			MsgBox,262144,, "INFINITE LOOP`n Path.isHardlink()`n PATH:" this.path
			return
		}

		return RegExMatch( $result, "<SYMLINKD*>\s+" this.basename()) ? 1 : 0
	}

	/** split path by spalshes
	  @return array
	*/
	split(){
		;if RegExMatch( this.path, "^\\*(\w+)\\*$", $folder ) ;;; return $Path if $Path is onnly 1 folder long E.G.: $Path := "fooFolder\"
			;return % $folder1
		;$splitted := RegExMatchAll(this.path, "([\\\/])*([^\\\/]+)")[2]
		;dump($splitted, "$splitted", 1)
		$path_slash_prefixed := RegExReplace(  this.path, "i)^([A-Z]:[\\/])*(.*)", "\$2" ) ; replace "c:\" or prefix path with "\"
		return % RegExMatchAll( $path_slash_prefixed, "([\\\/])([^\\\/]+)")[2]
	}

	/** getFileMask
	*/
	getFileMask(){
		if(this.isFileMask()){
			$split := this.split()
			return % $split[$split.Length()]
		}
	}
	/** getFiles
	*/
	getFiles($files_or_folders:=0, $recursive:=0){
		$files := []
		;if(this.isFileMask()){
			;$mask := this.getFileMask()
			loop, % this.path, %$files_or_folders%, %$recursive%
				$files.push(A_LoopFileFullPath)
		;}
		return %$files%
		;dump(this.path, "this.path", 0)
	}
	/* get relative path of this.path to $target_path
	  @param string $target_path from this.path
	  @return string relative path to $target_path
	  */
	relative($target_path, $slash:="\"){ ;"
		$from	:= this.path
		$to	:= new Path($target_path).getPath()
		;MsgBox,262144,, %$from%
		;MsgBox,262144,, %$to%

		static PathRelativePathTo:=DllCall("GetProcAddress","PTR",DllCall("LoadLibrary","Str","Shlwapi.dll"),"AStr","PathRelativePathTo" (A_IsUnicode?"W":"A"),"PTR")
				,FAD:=16,pszPath,init:=VarSetCapacity(pszPath,MAX_PATH:=260)
		If DllCall(PathRelativePathTo,"PTR",&pszPath,"STR",$from,"UInt",InStr($from,"D")?FAD:0,"Str",$to,"UInt",InStr($to,"D")?FAD:0)
			$relative := $slash StrGet(&pszPath)
		else return -1

		return % RegExReplace( $relative, "[\\\/]+", $slash )

	}


	/** strip single & double quotes
		trim whitespace
	*/
	_strip(){
		this.path := RegExReplace(this.path, "(^[\s""']+|[\s""'\r\n]+$)", "" )
	}
	/** replace environment variables like "C:\Users\%username%"
		@Example
			Path_Get("C:\Users\%username%")	returns "C:\Users\vilbur"
			Path_Get("%AppData%")	returns "C:\Users\vilbur\AppData"
	*/
	_replaceVariables(){
		;MsgBox,262144,, _replaceVariables, 2
		;if (this._RegExMatchAll( this.path, "(%[^\\\s]+%)" ).length())
		;	this.path := ComObjCreate("WScript.Shell").Exec("cmd.exe /q /c echo """ this.path """").StdOut.ReadAll()
		;

		$env_variable_match := RegExMatchAll( this.path, "%([^\\\s]+)%" )

		if ($env_variable_match[1].length()>0) {
			$matches := $env_variable_match[1]
			;dump($matches, "$matches", 0)
			For $index, $env_var in $matches
			{
				;RegExMatch( $env_var, "%(\w+)%", $env_match )	;;; GET eg: "%A_AppData%" with "AppData"
				EnvGet, $env_var_value, %$env_var%
				;dump($env_var_value, "$env_var_value", 0)
				this.path := RegExReplace( this.path, "%" $env_var "%", $env_var_value ) ;;; Replace eg: "%A_AppData%" with "AppData"
			}
		}

	}

	/** Match multiple matches
	  @return array of  matches
	  */
	_RegExMatchAll($string, $regex){
		$rx_pos = 1
		$matches := Array()
		/* IF MULTIPLE MATCHES
		*/
		While $rx_pos := RegExMatch($string,  $regex, $match, $rx_pos+StrLen($match)) {
			;;; SET EMPTY SUB ARRAYS FOR SELECTIONS
			if ( $matches.length() == 0 )
				While ( $match%A_Index% !="" )
					$matches.push(Array())
				While ( $match%A_Index% !="" )
					$matches[A_Index].push( $match%A_Index% )
		}

		/* IF FULL MATCH E.G: $test := RegExMatchAll( "test", "test" )
		*/
		if ( $matches.length() == 0 ) {
			$string_match_count := RegExMatch( $string, $regex, $url_match )
			if($string_match_count)
				return % [$url_match]
		}
		return %$matches%
	}

	/* reverse_array
	*/
	_reverse_array($array){
		$array_reversed := Array()
		Loop, % $len:=$array.MaxIndex()
			$array_reversed[$len-(A_Index-1)] := $array[A_Index]
		return %$array_reversed%
	}

}
/** GET NEW CLASS OBJECT
	All Function should be rewritten to this class
*/
Path($path := ""){
	return % new Path($path)
}
