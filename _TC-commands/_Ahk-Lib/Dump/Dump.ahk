#SingleInstance force

#Include %A_LineFile%\..\..\_vendor\LV\LTVCustomColors.ahk
#Include %A_LineFile%\..\Lib\Obj.ahk 

global $Dump


;/* This function is defined in launch file "/../Dump.ahk"
;	get new class object
;*/
;Dump($object,$label:="",$expand:=0){
;	if($Dump == "") 
;		$Dump := new Dump($Hwnd_in)				
;		
;	$Dump.add($object, $label,$expand)
;}


/*
	Class Dump
*/
Class Dump {

	__NEW($Hwnd_in){
		this.createGUI()
		;this._TreeView	:= DumpTreeView($Hwnd_in)
		global DumpClassTreeView
		this._TreeView	:= new DumpTreeView("DumpClassTreeView")
	
	}

	/*
		$variable := { "nested object":{"nested KEY":"nested VALUE"} }
	*/
	add($object,$label:="",$expand:=0){
		;this.filename	:= A_ScriptName " - "
		
		this.expand := $expand		
		this._TreeView.add($object,$label,,$expand)
	}
	
	/*
	*/
	_fillEmptyObjects($object){
		if (IsObject($object)) {
			;if($object.Length() == 0)
			;	$object.insert("EMPTY")
			;	;$object.insertAt("EMPTY","shit")				
			;else
				For $key, $value in $object
					if (IsObject($value))
						this._fillEmptyObjects($object)
		}
		return %$object%
	}
	
	/*
	*/		
	createGUI(){ 

		Gui, Destroy
		;Gui, -Border
		Gui, +Resize  				
		;Gui, +Background1c1c1c
		gui, font, s10, Lucida console  ; Set 10-point Verdana.
		Gui, Color, #232323

		Gui, Show, h1024 w1024, "Dump - " %A_ScriptName%
		;MsgBox,262144,, test, 2
		;Window_setPosition( "", 38, 14.5, 40, 85, 3  )
		
		;sleep, 500
		;this._setPosition( "", 0, 50, 50, 49, 3 )		
		;Window().setActive()
		;		.setPosition(50,50)
		;		.setDimensions(50,50)
		return
		
		GuiEscape:
		ExitApp
		
	}
	_setPosition( $WinTitle:="", $position_X:=0, $position_Y:=0, $win_width:=0, $win_height:=0, $monitor_number:=1  ){
		if $WinTitle=
			WinGetActiveTitle, $WinTitle
		IfWinNotExist, %$WinTitle%
			msgBox, %$WinTitle%
			;notify("error", "WINDOW " $WinTitle " IS NOT EXIST", "WRONG $WinTitle ARGUMENT PASSED`nin function: Window_setPosition" )
	
		SysGet, $MonitorCount, MonitorCount
		If $monitor_number<=%$MonitorCount%
		{
			SysGet, $MonitorWorkArea, MonitorWorkArea, %$monitor_number%
			;;GET  WORKING DESKTOP POSITIONS
			$start_X=%$MonitorWorkAreaLeft%
			$start_Y=%$MonitorWorkAreaTop%
			$end_X  =%$MonitorWorkAreaRight%
			$end_Y  =%$MonitorWorkAreaBottom%
	
			
			;;;GET DIMENSIONS
			$monitor_width :=$end_X-$start_X
			$monitor_height:=$end_Y-$start_Y
			;;; GET WINDOW POSITION IN PERCENTS
			$win_pos_px_X :=Floor(( $monitor_width/100) *$position_X)
			$win_pos_px_Y :=Floor(( $monitor_height/100)*$position_Y)
			if $monitor_number>1
			{
				$win_pos_px_X:=$win_pos_px_X+$start_X
				$win_pos_px_Y:=$win_pos_px_Y+$start_Y
			}
			;;;CORRECT WINDOW SIZE ON WINDOWS 10
			$win_pos_px_X:=$win_pos_px_X-6
			
			;;; GET WINDOW DIMENSIONS IN PERCENTS
			$win_width_px :=Floor(( $monitor_width/100) *$win_width )+15
			$win_height_px:=Floor(( $monitor_height/100)*$win_height ) +8
			
			WinMove, %$WinTitle%, , %$win_pos_px_X%, %$win_pos_px_Y%, %$win_width_px%, %$win_height_px%
		}
	}	
	
	
}

   
/*  
	Class DumpTreeView  
*/
		  
Class DumpTreeView {  
	 
	/*TEST SNIPPET
	*/	 
	__NEW($hwnd){
		this.items	:= 1
		this.hwnd	:= $hwnd
		this.icons_file	:= "shell32.dll" 
		this.TVM_SETITEMHEIGHT	:= 0x111B
		this.itemsHeight	:= 90 ; pixels
		;this.icons	:= [ 74, 111, 280, 300, 268, 326 ]
		;this.icons_list	:= {	"object":	300
		;		,"array":	309
		;		,"arrows":	268
		;		,"bullet":	295}
		/*
		   REMOVE ALL ICONS
		*/
		this.icons_list	:= {	"object":	999
				,"array":	999
				,"arrows":	999
				,"bullet":	999}		
		this.colors	:= {	"object":	"0xFFF0DB"
				,"array":	"0xFF6BE8"
				,"string":	"0x7272FF"
				;,"string":	"0x00FF00"				
				,"integer":	"0x0099ff"}		
		$IconList	:= this._getIconList()
		
		;$hwnd := this.hwnd
		Gui, Add, TreeView , v%$hwnd% h1024 w2048  x8 R20  ImageList%$IconList% hwnd%$hwnd% +Background1c1c1c ; -Buttons
		;;;this._setIconTest()  ;;; DEBUG - show all icons in treeView

		TV_Change( %$hwnd% )
		 SendMessage, 0x111B , 90, 0, , ahk_id %$hwnd%
	}
	
	
	/*
		add 
	*/	
	add($object_source,$label:="", $parent := "", $expand:=0){
		this.expand := $expand
		if (IsObject( $object_source)) {
			
			$object	:= this._sortItems($object_source)
			$label	:= this._getLabelForObject($label, $object_source)
			$ParentKey	:= this._addObject($object_source,$label, $parent)
			;;; loop all datatypes in object
			For $type, $type_data in $object
				;;; loop all items in object
				For $key, $data in $type_data
					; Loop this function again if item is object
					if($type == "object") 
					    this.add($data, $key , $ParentKey,  $expand)
					
					; Loop this function again if item is object					
					else if($type == "value")                             
						this._addItem($data,$key,$ParentKey)	;
			   
		} else 
			this._addItem($object_source, $label, $parent )
	}
		
	/*
	*/		
	_getObjLength($array){
		for $key, $value in $array
		$count++
		return %$count%
	}
	
	/*
	*/	
	_Array_IsArray($obj) {
		return	!!$obj.MaxIndex()
	}
	

	/*
	*/
	_getIconList(){
		$IconList := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
		;;; LOAD ICONS FROM DLL FILE UP TO COUNT
		;Loop 10  ; Load the ImageList with some standard system icons.
		;	IL_Add($IconList, "shell32.dll", A_Index)

		;$icons := [4,268]
		;Loop % this.icons.Length()
		;	IL_Add($IconList, this.icons_file, this.icons[A_Index] )
		
		For $icon, $index in this.icons_list
			IL_Add($IconList, this.icons_file, $index )
			;MsgBox,262144,, index:`n%$index%, 20

		
		;TV_SetColor($ParentKey, "#FCFCFC" )
		TV_SetColor($ParentKey, "0xFCFCFC" )		
		

		return %$IconList%
	}
	/*
	*/
	_getIcon($name){
		;$icon	:=  " Icon" Obj_indexOf(this.icons_list, $name) " "
		;MsgBox,262144,, $icon:`n%$icon%, 20
		return % " Icon" Obj_indexOf(this.icons_list, $name) " "
	}
	
	/*
	   set item for every icon imagelist
	   @parameter	array	$icons of indexes in source file e.g: "shell32.dll", 2	// will show icon 2 from "shell32.dll" file
	   
	   @example of adding icons from "shell32.dll"
	   		$icons	:= {	"object":	300
					,"array":	111
					,"item":	268}
					
			$IconList := IL_Create(10) 
			For $icon, $index in $icons
				IL_Add($IconList, "shell32.dll" , $index )
	   
			_setIconTest($icons)
		
	*/
	_setIconTest($icons:=""){
			
		if($icons=="")
		    $icons:= this.icons_list
						
		$icon_test_parent := TV_Add( this.icons_file,, " +Expand"  )
		
		;TV_SetColor($icon_test_parent, "0xFFBB77" )
		TV_SetColor($icon_test_parent, "0xFFBB77" )		

		For $name, $index in $icons
		{
			;$ParentKey	:= TV_Add( "name - " this.icons[A_Index], ," Icon" A_Index )
			$icon_test	:= TV_Add( "icon" A_Index ", index: " $index ", name: " $name, $icon_test_parent ," Icon" A_Index )					
			TV_SetColor($icon_test, "0xFCFCFC" )
		}
		
	}

	/**
	*/
	_addObject($object_source, $label, $parent){
		if ( $parent=="" ) {   
			$parent	:= "P" this.items++ 
			$expand	:= " +Expand" 
		}
		
		$icon	:= this._Array_IsArray($object_source) ?  this._getIcon("array") : this._getIcon("object")
		;MsgBox,262144,, % this.expand, 2
		$expand 	:= this.expand==1 ? " +Expand" : ""

		
		$ParentKey	:= TV_Add( $label "                                   ", $parent, $icon $expand  )
		;$ParentKey	:= TV_Add( $label "                                   ", $parent, "icon99" $expand  )					
		
		
		TV_SetColor($ParentKey, this._Array_IsArray($object_source) ?	this.colors.array:  this.colors.object )		
		return %$ParentKey%
	}
	

	/*
	*/	
	_addItem($variable,$label,$ParentKey:=""){ 
 		;MsgBox,262144,, variable:`n%$variable%, 20
		$ParentKey_new	:= TV_Add( this._getLabelItem($label,10) $variable, $ParentKey, this._getIcon("arrows")  )		
		TV_SetColor($ParentKey_new, this._getItemColor($variable,$label), "0x1C1C1C")
		return %$ParentKey_new%
	}

	/*
		get label for object and array suffixed with obj\array length
		@example
			"[ARRAY]	- 3"	; array	with length of 3 items
			"{Object}	- 3"	; object	with length of 3 items
	*/
	_getLabelForObject($label, $object ){
		
		$length := this._getObjLength($object)
		;
		if $label is integer 
			return % "[" $label "]"
		;	;$label := "" $label ""			
	
		if ( this._Array_IsArray($object))
			$label := $label==""	?	"X"	 :$label
			;$label := $label==""	?	"ARRAY"	 :$label 			
		else
			;$label := $label==""	?	"Object"	:$label
			$label := $label==""	?	"x"	:$label 			
		
		;if($label != "")
		;	$label := $label " " ($length is integer ? $length : "0")			
			
		
		return %$label%
		;return % A_ScriptName " - " $label ":"
		
	}

	/*
	*/	
	_getLabelItem($label,$lenght:=10) {
		
		StringLen, $label_length, $label
		if($label_length == 0)
			return ""

		Loop, % ($lenght - $label_length )
			$label := $label " "	
		
		return % $label ":"
		;return % A_ScriptName " - " $label ":"
	}

	/*
	*/
	_getItemColor($variable,$label:=""){
		
		;if($label == "key")
			;return "0xd68251"
		;else if($label == "value")
			;return "0x34AD46"
		;
		;MsgBox,262144,, variable:`n%$variable%, 20
		if $variable is number 
			return this.colors.integer
		;	
		;else if $variable.isArray()
		;	return "#46AD34"
		;
		;;else if (isObject($variable))		
		;;	return "#8CD6FF" ; if string				
		;;
		;else
			return this.colors.string ; if string
	}
	
	
	
	/*
	*/	
	_sortItems($Object){
		$sorted := {"object":{},"value":{}}
		
        For $key, $data in $Object
			if (IsObject($data)) 
				$sorted.object.Insert($key,$data)

		For $key, $data in $Object
			if (!IsObject( $data)) 
				$sorted.value.Insert($key,$data)
	
		return %$sorted%
	}
	

	
}	
