#SingleInstance force

#Include %A_LineFile%\..\..\TcTabs.ahk

global $TcTabs 	:= new TcTabs()

/**
 */
getTabsTest()
{
	Dump($TcTabs.get(), "TcTabs.get()", 1)
	Dump($TcTabs.get("left"), "TcTabs.get('left')", 1)
	Dump($TcTabs.get("right"), "TcTabs.get('right')", 1)

}
/** Load tabs
 */
loadTabsTest( $tab_file_path )
{
	/* Load to active pane
	*/
	$TcTabs.load( $tab_file_path)
	
	/* Load active pane to left
	*/
	sleep, 2000
	$TcTabs.load( $tab_file_path, "left")
	
	/* Load active pane to right
	*/
	sleep, 2000
	$TcTabs.load( $tab_file_path, "right")

}
/** Save tabs to files
 */
saveTabsTest( )
{
	/* Load to active pane
	*/
	$TcTabs.save( A_ScriptDir "\save-both-sides.tab" )
	
	/* Load active pane to left
	*/
	$TcTabs.save( A_ScriptDir "\save-left.tab", "left")
	
	/* Load active pane to right
	*/
	$TcTabs.save( A_ScriptDir "\save-right.tab", "right")

}

/* RUN TEST
  
*/
;getTabsTest()
;loadTabsTest(A_ScriptDir "\..\TcTabsLoader\Test\test-both-sides.tab")
saveTabsTest()
