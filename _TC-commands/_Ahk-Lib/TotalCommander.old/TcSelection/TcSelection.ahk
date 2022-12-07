#Include %A_LineFile%\..\..\TcCore.ahk
#Include %A_LineFile%\..\..\TcPane\TcPane.ahk

/*	Total commander Selection
*/
Class TcSelection extends TcCore
{
	_Pane 	:= new TcPane()

	__New()
	{
		this._init()
	}
	/** Get selection
	*/
	get($mask:="")
	{
		return % this._getSelection($mask)
	}
	/** Get selected files
	*/
	getFiles($mask:="")
	{
		return % this._getSelection("file", $mask)
	}
	/** Get selected folders
	*/
	getFolders($mask:="")
	{
		return % this._getSelection("folder", $mask)
	}
	/**
	 */
	getFocused($file_or_folder:="")
	{
		$active_listbox	:= this._Pane.getHwnd()
		$active_path	:= this._Pane.getPath() ; active path does not exist if selection is in result of search E.G.: https://www.google.cz/imgres?imgurl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FFvAipvYcAm0%2Fmaxresdefault.jpg&imgrefurl=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DFvAipvYcAm0&docid=-zHAQyYsPkUiGM&tbnid=PrwztdfNRjSd8M%3A&vet=10ahUKEwj40IjCj4zaAhWFF5oKHa90AEsQMwhEKAUwBQ..i&w=1280&h=720&bih=872&biw=1745&q=total%20commander%20search%20result%20feed&ved=0ahUKEwj40IjCj4zaAhWFF5oKHa90AEsQMwhEKAUwBQ&iact=mrc&uact=8
		$index	:= this._GetFocus($active_listbox)
		$item 	:= this._getPathOnIndex($active_listbox, $index)

		if( $item )
			$path =  %$active_path%\%$item%
			
		if( ! this._fileOrFolderTest($file_or_folder, $path) )
			return 
		
		return $path ? $path : false
	}
	/**
	 */
	getSelectionOrFocused($file_or_folder:="", $mask:="")
	{
		$selection	:= this._getSelection($mask, $file_or_folder)

		return % $selection.length() > 0 ? $selection : [this.getFocused($file_or_folder)]
	}

	/** _getSelection
	  *
	  * @param	string	$mask	selection mask
	  * @param	string	$file_or_folder	"file|folder" get files or folders, get both if empty
	  *
	*/
	_getSelection( $file_or_folder:="", $mask:="" )
	{
		$selection	:= []
		$indexes	:= [] ; indexes of selected items
		$folder_test	:= $file_or_folder=="folder"
		$active_listbox	:= this._Pane.getHwnd()
		$active_path	:= this._Pane.getPath() ; active path does not exist if selection is in result of search E.G.: https://www.google.cz/imgres?imgurl=https%3A%2F%2Fi.ytimg.com%2Fvi%2FFvAipvYcAm0%2Fmaxresdefault.jpg&imgrefurl=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DFvAipvYcAm0&docid=-zHAQyYsPkUiGM&tbnid=PrwztdfNRjSd8M%3A&vet=10ahUKEwj40IjCj4zaAhWFF5oKHa90AEsQMwhEKAUwBQ..i&w=1280&h=720&bih=872&biw=1745&q=total%20commander%20search%20result%20feed&ved=0ahUKEwj40IjCj4zaAhWFF5oKHa90AEsQMwhEKAUwBQ&iact=mrc&uact=8

		$count_of_items	:= this._GetSelItems($active_listbox, $indexes )
		
		if( RegExMatch($active_path, "i)^[A-Z]:" ) ) ; add slash if path exists
			$active_path = %$active_path%\
		else
			$active_path := ""			  
			
		For $i, $index in $indexes
		{
			$item := this._getPathOnIndex($active_listbox, $index)
			$path =  %$active_path%%$item%

			if( $item && ( $mask=="" || RegExMatch($path, "i)" $mask ) )  )
				if( this._fileOrFolderTest($file_or_folder, $path) )
					$selection.push( $path )
		}
		
		return %$selection%
	}
	/**
	 */
	_getPathOnIndex($listbox_hwnd, $index)
	{
		$path_raw := this._GetText($listbox_hwnd, $index) ; E.G.: "test.ahk30 02827.03.2018 00:00-a--"

		RegExMatch( $path_raw, "i)^[^\s]+", $path_match )

		return % $path_match!=".." ? $path_match : ""
	}
	/** Is path file or folder 
	 */
	_fileOrFolderTest( $file_or_folder, $path )
	{
		if( ! $path )
			return false
		
		if( ! $file_or_folder )
			return true
		
		$folder_test := $file_or_folder=="folder"
		
		return % InStr(FileExist($path), "D") == $folder_test
	} 

	/*
		-----------------------------------------------
				LISTBOX METHODS
		-----------------------------------------------
	*/
	_GetSelItems(HLB, ByRef ItemArray, MaxItems := 0) {
		Static LB_GETSELITEMS := 0x0191
		ItemArray := []
		If (MaxItems = 0)
			MaxItems := this._GetSelCount(HLB)
		If (MaxItems < 1)
			Return MaxItems
		VarSetCapacity(Items, MaxItems * 4, 0)
		SendMessage, % LB_GETSELITEMS, % MaxItems, % &Items, , % "ahk_id " . HLB
		MaxItems := ErrorLevel
		If (MaxItems < 1)
			Return MaxItems
		Loop, % MaxItems
			ItemArray[A_Index] := NumGet(Items, (A_Index - 1) * 4, "UInt") + 1
		Return MaxItems
	}
	_GetSelCount(HLB) {
		Static LB_GETSELCOUNT := 0x0190
		SendMessage, % LB_GETSELCOUNT, 0, 0, , % "ahk_id " . HLB
		Return ErrorLevel
	}
	_GetText(HLB, Index) {
		Static LB_GETTEXT := 0x0189
		Len := this._GetTextLen(HLB, Index)
		If (Len = -1)
			Return ""
		VarSetCapacity(Text, Len << !!A_IsUnicode, 0)
		SendMessage, % LB_GETTEXT, % (Index - 1), % &Text, , % "ahk_id " . HLB
		Return StrGet(&Text, Len)
	}
	_GetTextLen(HLB, Index) {
		Static LB_GETTEXTLEN := 0x018A
		SendMessage, % LB_GETTEXTLEN, % (Index - 1), 0, , % "ahk_id " . HLB
		Return ErrorLevel
	}
	_GetFocus(HLB) {
		Static LB_GETCARETINDEX := 0x019F
		SendMessage, % LB_GETCARETINDEX, 0, 0, , % "ahk_id " . HLB
		Return (ErrorLevel + 1)
	}


}
