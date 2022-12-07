$user_command	:= "em_TestTcButtonBar"

/** Get New ButtonBar
*/
getNewButtonBar()
{
	$commander_path	= %Commander_Path%

    $TcButtonBar   := new TcButtonBar()    $separator     := new TcButtonBarButton()    $Button_empty  := new TcButtonBarButton().empty()    $Button        := new TcButtonBarButton()
                            .cmd( $commander_path "\commands\foo.bat" )
                            .icon("%systemroot%\system32\shell32.dll", 43)

	
	/* ADD BUTTONS
	*/
	$TcButtonBar.command( $user_command )
	$TcButtonBar.button( $separator  )
	$TcButtonBar.button( $Button_empty  )
	$TcButtonBar.button( $Button.tooltip("Last Button") )
	$TcButtonBar.button( $Button.clone().tooltip("First Button") ,1 )		
	
	return $TcButtonBar
}