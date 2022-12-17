/** TcTabsLoader
 *
 */
Class TcTabsLoader extends TcCore
{
	_usercmd_ini	:= "" ; save commands
	_cmd_name	:= "em_TcTabsLoader_load-tabs"
	_command_exists	:= 0
	_TcPane	:= ""
	
	/** _setTabsPath
	 */
	__New()
	{
		this._init()
		this._setIniFile( "usercmd.ini" )		
	}
	/** load tabs file
	 *		
	 * @param	string	$tab_file_path	path to *.tab file
	 * @param	string	$side	"left|right|void" load tabs to side, load to active if param empty
	 */
	load( $tab_file_path, $side:="" )
	{
		if( ! FileExist($tab_file_path) )
			return
		
		if( $side )
			 $tab_file_path := this._correntSidesOfTabs( $tab_file_path, $side )
		
		this._setCommandExistsTest()
		this._editCommandLoadTabs("OPENTABS """ $tab_file_path """")
		sleep, 100
		this._createShortcut()
		this._restartCommanderIfFirstTimeLoad()
		this._executeShortcut()
	}
	/*---------------------------------------
		2 -SIDES TAB FILE
	-----------------------------------------
	*/
	
	/** Load tabs always to one side if *.tab contains both sides
	 */
	_correntSidesOfTabs( $tab_file_path, $side )
	{
		if( this._hasOnlyActiveTabs( $tab_file_path ) || ! RegExMatch( $side, "i)left|right" ) )
			return  $tab_file_path
		
		$current_side := this._getSideOfSourcePane()
		
		if( $side==$current_side )
			return  $tab_file_path
	
		$temp_tabs_file = %temp%\temp_tabs_file.tab
			
		this._switchTabs( $tab_file_path, $temp_tabs_file )	

		return  $temp_tabs_file
	}
	/**
	 */
	_switchTabs( $tab_file_path, $temp_tabs_file )
	{
		FileDelete, %$temp_tabs_file%
		
		FileRead, $tabs_content, %$tab_file_path%
		 
		$tabs_content := RegExReplace( $tabs_content, "\[activetabs\]", "[inactivetabs_temp]" )
		$tabs_content := RegExReplace( $tabs_content, "\[inactivetabs\]", "[activetabs]" )
		$tabs_content := RegExReplace( $tabs_content, "\[inactivetabs_temp\]", "[inactivetabs]" )  				
		 
		FileAppend, %$tabs_content%, %$temp_tabs_file%
		
		sleep, 500
	}  
	
	/**
	 */
	_hasOnlyActiveTabs( $tab_file_path )
	{
		IniRead, $inactive_tabs, %$tab_file_path%, inactivetabs

		return ! $inactive_tabs || $inactive_tabs=="ERROR" ? true : false
	}  
	/**
	 */
	_getSideOfSourcePane()
	{
		if( ! this._TcPane )
			this._TcPane := new TcPane()
		
		return % this._TcPane.activePane()
	}  
	
	/*---------------------------------------
		COMMAND
	-----------------------------------------
	*/
	/** Edit command in wincmd.ini
		This command is loading tab files
	 */
	_editCommandLoadTabs( $open_tabs_cmd )
	{
		IniWrite, %$open_tabs_cmd%, % this._usercmd_ini, % this._cmd_name, cmd
	}
	/** create command in wincmd.ini
	 */
	createCommandRunTabSwitcher()
	{
		$param := """%P\""" ; "
		IniWrite, % A_ScriptDir "\TabsSwitcher.ahk",	% this._usercmd_ini, % this._cmd_run_tabswitcher, cmd
		IniWrite, %$param%,	% this._usercmd_ini, % this._cmd_run_tabswitcher, param		
	}
	/*---------------------------------------
		SHORTCUT
	-----------------------------------------
	*/
	/** create keyboard shortcut to run this._cmd_name command
		create keyboard shortcut in section "ShortcutsWin"
		section "ShortcutsWin" runs keyboard shortcuts with win key 
	 */
	_createShortcut()
	{
		$keyboard_shortcut :=  ; Ctrl + alt + Shift
		this._setShortcutToIni( "ShortcutsWin", "CAS+F9", this._cmd_name )
	}
	/**
	  create command in Usercmd.ini
	 */
	_setShortcutToIni( $section, $key, $value )
	{
		IniWrite, %$value%, % this._wincmd_ini, %$section%, %$key%
	}
	/**
		https://autohotkey.com/docs/commands/WinExist.htm#function
	 */
	_executeShortcut()
	{
		ControlSend,, {LWin down}{Ctrl down}{Alt down}{Shift down}{F9}{LWin up}{Ctrl up}{Alt up}{Shift up}, % this.ahkId()
	}
	/*---------------------------------------
		FIRST TIME EXECUTION
	-----------------------------------------
	*/
	/**
	 */
	_setCommandExistsTest()
	{
		IniRead, $command_exists, % this._usercmd_ini, % this._cmd_name, cmd, 0
		
		this._command_exists
	} 
	/** Total Commander needs restart, if command does not exists yet
	 */
	_restartCommanderIfFirstTimeLoad()
	{
		if( ! this._command_exists )
			return
			
		MsgBox, 4, , Command for loading does not exists yet.`n`nTotal Commander needs to be restarted
		IfMsgBox, Yes
			return % this._restartTotalCommander()
			
		exitApp
	}  
	/**
	 */
	_restartTotalCommander()
	{
		$commadner_process	:= this.proccesName()
		$commadner_path	= %Commander_Path%\%$commadner_process%
		
		WinClose , % this.ahkId()
		
		sleep, 200
		Run *RunAs %$commadner_path%
		
		WinWait, ahk_class TTOTAL_CMD,,2
		
		this._init()
	}  
	

	
}