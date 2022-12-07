#SingleInstance force

#Include %A_LineFile%\..\..\TcPane.ahk

global $TcPane := new TcPane()

/* Get ClassNN of pane
*/
getClassTest()
{
	Dump($TcPane._getPaneClass("source"), "_getPaneClass('source')", 1)
	Dump($TcPane._getPaneClass("target"), "_getPaneClass('target')", 1)
	
	Dump($TcPane._getPaneClass("left"), "_getPaneClass('left')", 1)
	Dump($TcPane._getPaneClass("right"), "_getPaneClass('right')", 1)
}
/**
 */
getPathControlHwnd()
{
	Dump($TcPane.getHwnd("source"), "getHwnd('source')", 1)
	Dump($TcPane.getHwnd("source", "path"), "_getPaneClass('source')", 1)	

}

/* Get path of current pane
*/
getPathTest()
{
	Dump($TcPane.getPath("source"),	"getPath('source')", 1)
	Dump($TcPane.getPath("target"),	"getPath('target')", 1)
	;
	Dump($TcPane.getPath("left"), "  getPath('left')", 1)
	Dump($TcPane.getPath("right"), " getPath('right')", 1)
}

/* Get Active pane
*/
getActivatePaneTest()
{
	Dump($TcPane.activePane(), "activePane()", 1)
}


/* Set Active pane
*/
setActivatePaneTest()
{
	sleep, 1000
	$TcPane.activePane("right")
	
	sleep, 1000
	$TcPane.activePane("left")
	
	sleep, 1000
	$TcPane.activePane("right")
	
	sleep, 1000
	$TcPane.activePane("target")
	
	sleep, 1000
	MsgBox,262144,, Total commander has set focus to panes 4x times,2 
}

/**
 * 1) create test file in target pane
 * 2) refresh target pane 	
 * 3) after 3seconds test file is deleted
 */
refreshPaneTest()
{
	$test_file := $TcPane.getPath("target") "\REFRESH_PANE_TEST.txt"
	FileAppend, "", %$test_file% 
	
	$TcPane.refresh("target")
	
	sleep, 3000
	FileDelete, %$test_file%
	
	$TcPane.refresh("target")
}
/* RUN TEST
  
 */
;getClassTest()
;getPathControlHwnd()
getPathTest()
;getActivatePaneTest()
;setActivatePaneTest()
;refreshPaneTest()
