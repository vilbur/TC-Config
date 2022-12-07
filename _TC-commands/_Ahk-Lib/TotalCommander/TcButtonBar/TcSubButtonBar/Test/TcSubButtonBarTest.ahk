#SingleInstance force

#Include %A_LineFile%\..\..\..\TcButtonBar.ahk
#Include %A_LineFile%\..\..\..\Test\Helpers\userCommandHelpers.ahk 

global  $buttonbar_path     :=  A_ScriptDir "\ButtonBarTest.bar"
global  $sub_buttonbar_path :=  A_ScriptDir "\SubButtonBarTest.bar"

/** Get New ButtonBar
*/
getButtonBar($loop:=2)
{
    $TcButtonBar   := new TcButtonBar()
    $Button_empty  := new TcButtonBarButton().empty()
    $Button        := new TcButtonBarButton().cmd( "foo" )
                                             .icon("%systemroot%\system32\shell32.dll", 43)
	
	Loop, % $loop {
		$TcButtonBar.button( $Button  )
		$TcButtonBar.button( $Button_empty  )		
	}
	
	return $TcButtonBar
}

/** create button bar with sub bar
*/
createButtonBarWithSubBar()
{
    $ButtonBar     := getButtonBar(4)
    $SubButtonBar  := new TcSubButtonBar()
                        .bar(getButtonBar()) ; Link to getNewButtonBar() is below code block
                        .asBar()
                        .backButton($buttonbar_path)
                        .save($sub_buttonbar_path)
						
	; // Add subbar as button to main button bar 
	$ButtonBar.button($SubButtonBar, 1)

	$ButtonBar.save($buttonbar_path)
}
/**
 */
loadSubbarFromString()
{
	$TcSubButtonBar := new TcSubButtonBar().bar($sub_buttonbar_path)
	;Dump($TcSubButtonBar, "TcSubButtonBar", 0)
}

/**
 */
loadSubbars()
{
	$TcButtonBar := new TcButtonBar().load($buttonbar_path)
	;Dump($TcButtonBar, "TcButtonBar", 0)
}

/*---------------------------------------
	RUN TESTS
-----------------------------------------
*/
createButtonBarWithSubBar()
loadSubbarFromString()
loadSubbars()