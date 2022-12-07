#SingleInstance force

#Include %A_LineFile%\..\..\TcSelection.ahk

/**
  *
  */
Access_via_class()
{

	dump(new TcSelection().get(), "Selection.get() get all", 1)	
	;dump(new TcSelection().getFolders(), "Selection.getFolders()", 1)
	;dump(new TcSelection().getFiles("(.ahk|.md)$"), "Selection.getFiles('(.ahk|.md)$')", 1)
	;
	;dump(new TcSelection().getFocused(), "Selection.getFocused() get focused item", 1)
	;dump(new TcSelection().getFocused("file"), "Selection.getFocused('file') get focused file", 1)
	;dump(new TcSelection().getFocused("folder"), "Selection.getFocused('folder') get focused folder", 1)
	;
	;dump(new TcSelection().getSelectionOrFocused(), "Selection.getFocused() get selection or focused item", 1)
	;dump(new TcSelection().getSelectionOrFocused("file"), "Selection.getSelectionOrFocused('file') get selection or focused file", 1)
	;dump(new TcSelection().getSelectionOrFocused("folder"), "Selection.getSelectionOrFocused('folder') get selection or focused folder", 1)	
}



/*
-----------------------------------------------
	RUN TEST
-----------------------------------------------

*/

Access_via_class()
