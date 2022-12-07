#Include %A_LineFile%\..\includes.ahk
#Include %A_LineFile%\..\TcTabsGetter\TcTabsGetter.ahk
#Include %A_LineFile%\..\TcTabsLoader\TcTabsLoader.ahk
/** TcTabs
 *
 */
Class TcTabs
{
	_TcTabsGetter 	:= new TcTabsGetter()
	_TcTabsLoader 	:= new TcTabsLoader()
	
	/** Get tabs from both side, or only one
	 * 
	 * @param	string	$side	"left|right|void" get tabs from both sides if param empty
	 */
	get( $side:="" )
	{
		return % this._TcTabsGetter.getTabs($side)
	}
	/** Save tabs file
	 *		
	 * @param	string	$tab_file_path	path to *.tab file
	 * @param	string	$side	"left|right|void" Save tabs from side, save both sides if param empty
	 */
	save( $tab_file_path, $side:="" )
	{
		if( ! $side )
			$side := "left,right"
			
		Loop, parse, $side , `,
			$tabs .= ( A_Index==1? "[activetabs]" : "[inactivetabs]" ) "`n" this._joinTabsToString( this.get(A_LoopField) )
		
		FileDelete, %$tab_file_path% 
		FileAppend, %$tabs%, %$tab_file_path% 
	}
	/** Load tabs file
	 *		
	 * @param	string	$tab_file_path	path to *.tab file
	 * @param	string	$side	"left|right|void" load tabs to side, load to active if param empty
	 */
	load( $tab_file_path, $side:="" )
	{
		this._TcTabsLoader.load( $tab_file_path, $side )
	}

	
	/**
	 */
	_joinTabsToString( $tabs )
	{
		For $t, $tab in $tabs
			if( isObject($tab) )
				For $key, $value in $tab
					$tabs_string .= $t "_" $key "=" $value "`n"
			else
				$tabs_string .= $t "=" $tab "`n" 					

		return $tabs_string
	} 
	
}