/** TcTabs
 *
 */
Class TcTabs
{
	static _Parent := {"address":""}

	/*---------------------------------------
		GET TABS
	-----------------------------------------
	*/
	/**
	 */
	getTabs($side:="right")
	{
		$tabs := {}

		this.Parent().saveConfig()
		;Dump(this.Parent()._wincmd_ini, "this.Parent()._wincmd_ini", 1)
		$tabs_side := $side "tabs"
		
		IniRead, $tabs_ini, % this.Parent()._wincmd_ini, %$tabs_side%
			Loop Parse, $tabs_ini, `n
				this._setTab( $tabs, this._parseLine(A_LoopField)* )
				
		this._setActiveTabs( $tabs, $side )
		
		return $tabs
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
	_setTab( ByRef $tabs, $index, $key, $value )
	{
		if( ! $tabs[$index] )
			$tabs[$index] := {}
		
		$tabs[$index][$key] := $value
	}
	/**
	 */
	_setActiveTabs( ByRef $tabs, $side )
	{
		IniRead, $current_path, % this.Parent()._wincmd_ini, %$side%, path

		
		$active_tab :=	{"path":	$current_path
			,"options":	"1|0|0|0|0|2|0"}
		
		if( $tabs.active.activecaption )
			$active_tab.caption := $tabs.active.activecaption 
		
		$tabs.activetab := $tabs.active.activetab
		
		$tabs.insertAt($tabs.activetab, $active_tab)
		
		$tabs.delete("active")
	} 
	
	/** set\get parent class
	 * @return object parent class
	*/
	Parent($Parent:=""){
		if($Parent)
			this._Parent.address	:= &$Parent
		return % $Parent ? this : Object(this._Parent.address)
	} 
}