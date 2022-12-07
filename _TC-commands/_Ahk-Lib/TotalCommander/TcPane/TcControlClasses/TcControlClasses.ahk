/* Getting of controls class is tricky, because Total commander is changing then dynamically
   
   "file listbox" & "path" has different classes for 32-bit & 64-bit version.
		They are changing if:
			"Separate tree"	is visible
			"FTP connection"	is visible				
	  
		TC version	  File tree	  Path
		--------------	---------------	----------------
		TOTALCMD64.EXE	LCLListBox(5-1)	Window(17-9)
		TOTALCMD.EXE	TMyListBox(2-1)	TPathPanel(2-1)
		
 */
Class TcControlClasses extends TcCore
{
	_process_name	:= ""


	static _class_names :=	{"TOTALCMD.EXE":	{"listbox":	"TMyListBox"	;
			,"index":	[2, 1]	; [index of first control, value to remove for next control]
			,"path":	"TPathPanel"}	; 
		,"TOTALCMD64.EXE":	{"listbox":	"LCLListBox"	;
			,"index":	[17, 5]	; [index of first control, value to remove for next control]
			,"path":	"Window"}}	; 

	_class_nn	:= {} ; found class names
	
	/** search for existing classes for file listbox
	 *    TMyListBox(2-1) | LCLListBox(5-1)
	 *    
	 */
	_setPaneClasses()
	{
		$class_name := this._class_names[this.proccesName()].listbox
		$last_index := 5
		Loop, 2
		{
			$last_index := this._searchForPaneControl( $class_name, ( A_Index==1 ? $last_index : $last_index -1) )
			;Dump($last_index, "LISTBOX", 1)
			this._class_nn[$class_name $last_index] := {}
		}
	}
	/**
	 */
	_searchForPaneControl( $class_name, $last_index )
	{
		While, $last_index > 0
		{
			$last_index := this._searchExistingControl( $class_name, $last_index )
			ControlGetText, $text , % $class_name $last_index , % this.ahkId()

			if( $text )
				$last_index--
			else
				break
		}
		return $last_index
	} 
	
	/** search for existing classes for current path
	 * TPathPanel(2-1) | Window(17-9)
	 * 
	 * if can found disk info control then path is -1
	 * 
	 */
	_setPathClasses()
	{
		$class_name	:= this._class_names[this.proccesName()].path
		$indexes	:= this._class_names[this.proccesName()].index
		$panes_nn	:= this._getPanesClasses()

		$last_index := this._searchExistingControl( $class_name, $indexes[1] )		

		if( this._isDiskInfoControl( $class_name $last_index ) )
			$last_index--
		
		this._class_nn[$panes_nn[1]] := $class_name $last_index
		this._class_nn[$panes_nn[2]] := $class_name ($last_index - $indexes[2] )
	}
	/** If control is next "Disk space info" OR "Ftp info"
	  *
	  *  Controls next to disk dropdown menu E.G.:
	  *		1) 123 453 k of 987 654 k free
	  *		2) ftp://foo.ftp.address 
	 */
	_isDiskInfoControl( $class_name )
	{
		ControlGetText, $text , %$class_name%, % this.ahkId()

		return RegExMatch( $text, "i)(^ftp|free$)" )
	} 
	/** serach for number of control
		E.G.: LCLListBox1, LCLListBox2, LCLListBox3
	 */
	_searchExistingControl( $control_name, $number )
	{
		While $number>0
			if( this._isControlExists($control_name $number) )
				break
			else
				$number--

		return $number 		
	}

	/** find if control exists
	 */
	_isControlExists($class_nn)
	{
		ControlGet, $is_visible, Visible, , %$class_nn%,  % this.ahkId()

		return $is_visible
	}
	/** Pair LEFT "file listbox" with left "path" and vice versa
		Find right corner of list and path and compare it
		Left corner is changing if file tree is displayed
	 */
	_setListBoxAndPathToPair()
	{
		$panes_nn	:= this._getPanesClasses()
			
		ControlGetPos, $list_X,, $list_W, , % $panes_nn[1], % this.ahkId()
		
		ControlGetPos, $path_X,, $path_W, , % this._class_nn[$panes_nn[1]], % this.ahkId()		
		
		if( Round($list_X  $list_W+, -2) != Round($path_X +  $path_W, -2) )
		{
			this._class_nn :=	{$panes_nn[1]:this._class_nn[$panes_nn[2]]
				,$panes_nn[2]:this._class_nn[$panes_nn[1]]}
		}
		
	}
	/** get keys from this._class_nn
	 */
	_getPanesClasses()
	{
		$panes_nn	:= []

		For $pane_nn, $path_nn in this._class_nn
			$panes_nn.push($pane_nn)
		
		return $panes_nn	
	}
	/** get class of pane by "source|target"
	  * @param string $pane  "source|target"
	  */
	_getPaneClass( $pane )
	{
		return % $pane == "source" ? this._getSourcePaneClass() : this._getTargetPaneClass()
	}

	
}