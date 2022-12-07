#SingleInstance force


Class Project {

	_path := {"project":"", "public":"", "parent":""}
	_name := ""

	__new($path){
		this._setPath($path)
		this._setName()
		;Dump(this, "this.", 1)
	}


	/* Find path to Project root by finding '.env' path

	*/
	_setPath($path)
	{
		$path := RegExReplace( $path, "[\\\/]+$", "" ) ; remove trailng slashes

		While $path != $drive
		{
			if( FileExist($path "\.env") ){
				SplitPath, $path,, $base_path
				this._path.project	:= $path
				this._path.parent	:= $base_path
				break
			}
			SplitPath, $path,, $path,,, $drive
		}
	}
	/** _setName
	 */
	_setName()
	{
		if(this.path()){
			SplitPath, % this.path(), $dir_name
			this._name := $dir_name
		}
		return this
	}

	/** @return string path to project root
	 */
	path(){
		return this._path.project
	}

	/** @return string path to project parent folder
	 */
	parent(){
		return this._path.parent
	}
	/** @return string name of project
	 */
	name(){
		return this._name
	}

}


/** ====== TESTS ======
*/
LaravelPath_Test( )
{
	;$path_to_laravel	:= "c:\wamp64\www\portfolio\database"
	$path_to_laravel	:= "c:\wamp64\www\portfolio\\"
	;$path_to_laravel	:= "c:\wamp64\www\portfolio"
	$Project	:= new Project($path_to_laravel)
	Dump( $Project.path()=="c:\wamp64\www\portfolio",	"Project.path()", 1)
	Dump( $Project.parent()=="c:\wamp64\www",	"Project.parent()", 1)
	Dump( $Project.name()=="portfolio",	"Project.name()", 1)
}

;LaravelPath_Test()
