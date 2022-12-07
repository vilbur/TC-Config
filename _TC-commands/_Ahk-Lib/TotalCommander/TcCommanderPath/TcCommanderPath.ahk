/* Work with path to Total Commander 
 *  
*/
Class TcCommanderPath
{
	static _paths	:= {}

	/** SEARCH:
	 *		"%COMMANDER_PATH%"
	 *	REPLACE:
	 *		"C:\TotalCommander"
	 */
	pathFull( $path )
	{
		return % RegExReplace( $path, "i)%COMMANDER_PATH%", this._paths.commander  ) 
	}
	/** SEARCH:
	 *		"C:\TotalCommander"
	 *	REPLACE:
	 *		"%COMMANDER_PATH%"
	 */
	pathEnv( $path )
	{
		$commander_path_rx := RegExReplace( this._paths.commander, "i)[\\\/]+", "\\" )
		return % RegExReplace( $path, "i)" $commander_path_rx, "%COMMANDER_PATH%" ) 
	}

	/** Set absolute path to Total Commander 
	 */
	_setCommanderPath()
	{
		$commander_path	= %Commander_Path%
		this._paths.commander	:= $commander_path
	}
	
	/*---------------------------------------
		SET GET FILES
	-----------------------------------------
	*/
	/** Set ini file as property
	 *  
	 * @param	string	$ini_file	Relative path to file in Total Commander 
	 * @param	string	$key	Key to save to this object, if empty then sanitized ini file name is used E.G.: "wincmd.ini" WILL BE this._wincmd_ini
	 *
	 */
	_setIniFile( $ini_file, $key:="" )
	{
		
		if( ! $key )
		{
			SplitPath, $ini_file, $filename
			$key := "_" RegExReplace( $filename, "\.", "_" )
		}
		
		this[$key] := this.getIniFile( $ini_file )
	}
	/**
	 */
	getIniFile( $ini_file )
	{
		$ini_file_path	= %Commander_Path%\%$ini_file%

		return $ini_file_path	
	} 

}