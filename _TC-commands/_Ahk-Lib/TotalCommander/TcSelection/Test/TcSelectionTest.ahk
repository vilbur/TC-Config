#SingleInstance force

#Include %A_LineFile%\..\..\TcSelection.ahk

/** !!! IMPORTANT !!!
  *
  * This test file must be executed via Total Commander`s button bar.
  *	Since it`s getting current selection in Total Commander
  *
  */
dumpTestResult( $value, $title )
{
	SetTitleMatchMode, 2

	dump( $value, $title, 1 )
	
	WinActivate, Total Commander
}


/* GET SELECTED ITEMS
*/ 
getSelectedItems()
{
	dumpTestResult( new TcSelection().get(),	"Selection.get()	// get all selected items" ) 	
	dumpTestResult( new TcSelection().getFolders(),	"Selection.getFolders()	// get only selected folders" )
	dumpTestResult( new TcSelection().getFiles("(.ahk|.md)$"),	"Selection.getFiles('(.ahk|.md)$')	// get only .ahk and .md files" )
}


/* GET FOCUSED ITEMS
*/ 
getFocusedItems()
{
	dumpTestResult( new TcSelection().getFocused(),	"Selection.getFocused()	// get focused item" )
	dumpTestResult( new TcSelection().getFocused("file"),	"Selection.getFocused('file')	// get focused file" )
	dumpTestResult( new TcSelection().getFocused("folder"),	"Selection.getFocused('folder')	// get focused folder" )
}


/* GET SELECTED OR FOCUSED ITEMS
*/
getSelectedOrFocusedItems()
{
	dumpTestResult( new TcSelection().getSelectionOrFocused(),	"Selection.getFocused()	// get selection or focused item" )
	dumpTestResult( new TcSelection().getSelectionOrFocused("file"),	"Selection.getSelectionOrFocused('file')	// get selection or focused file" )
	dumpTestResult( new TcSelection().getSelectionOrFocused("folder"),	"Selection.getSelectionOrFocused('folder')	// get selection or focused folder" )	
}

/*
-----------------------------------------------
	RUN TESTS
-----------------------------------------------
*/

getSelectedItems()
getFocusedItems()
getSelectedOrFocusedItems()