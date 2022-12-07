 /** Get current tabs from total commander
  * 
  * @method	object|array	getTabs(string $side )	
  * 
  */
Class TcTabsGetter extends TcCore
{
	_tabs := {}
	
	/**
	 */
	__New()
	{
		this.initCore()
	}
	/** Get tabs from both side, or only one
	 * 
	 * @param	string	$side	"left|right|void" get tabs from both sides if param empty
	 */
	getTabs($side:="")
	{
		$tabs_both := {}

		if( ! RegExMatch( $side, "i)left|right") )
			$side := "left,right"
		
		this.saveConfig()
		
		if( $side=="left,right" )
			Loop, parse, $side , `,
				$tabs_both[A_LoopField] := this._getTabsFromPane(A_LoopField)
		else
			return % this._getTabsFromPane($side)				

		return $tabs_both
	}
	/** Get current tabs from one side
	 * @param	string	$side	"left|right|void" get tabs from both sides if param empty
	 */
	_getTabsFromPane($side)
	{
		this._tabs := {}		
		$tabs_side := $side "tabs"
		
		IniRead, $tabs_ini, % this._wincmd_ini, %$tabs_side%
			Loop Parse, $tabs_ini, `n
				this._setTab( this._parseLine(A_LoopField)* )
				
		this._setActiveTabs( $side )
		
		return this._tabs
	}
	/**
	 */
	_setTab( $index, $key, $value )
	{
		if( ! this._tabs[$index] )
			this._tabs[$index] := {}
		
		this._tabs[$index][$key] := $value
	}
	/**
	 */
	_parseLine( $line )
	{
		RegExMatch( $line, "^(\d+)_([^=]+)=(.*)", $line_match )
		
		if( $line_match )
			return [ $line_match1, $line_match2, $line_match3]
		
		RegExMatch( $line, "^(active[^=]+)=(.*)", $line_match )
			return [ "active", $line_match1, $line_match2]
	} 
	/**
	 */
	_setActiveTabs( $side )
	{
		IniRead, $current_path, % this._wincmd_ini, %$side%, path

		
		$active_tab :=	{"path":	$current_path
			,"options":	"1|0|0|0|0|2|0"}
		
		if( $tabs.active.activecaption )
			$active_tab.caption := $tabs.active.activecaption 
		
		this._tabs.activetab := this._tabs.active.activetab
		
		this._tabs.insertAt(this._tabs.activetab, $active_tab)
		
		this._tabs.delete("active")
	} 

}