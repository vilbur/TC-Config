/**  Simulate drag & drop of files into window
 *	https://autohotkey.com/board/topic/109578-simulating-drag-and-drop-file-on-to-program/#post_id_651231
 *
 * @example DropFiles( "ahk_class Notepad", "C:\SomeName.txt" )
 *
 */
DropFiles(window, files*)
{


	SetTitleMatchMode 2

	for k,v in files
	  memRequired+=StrLen(v)+1

	hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired+21)
	dropfiles := DllCall("GlobalLock", "ptr", hGlobal)

	NumPut(offset := 20, dropfiles+0, 0, "uint")

	for k,v in files
	  StrPut(v, dropfiles+offset, "utf-8"), offset+=StrLen(v)+1
	  
	DllCall("GlobalUnlock", "ptr", hGlobal)

	PostMessage, 0x233, hGlobal, 0,, %window%

	if ErrorLevel
	  DllCall("GlobalFree", "ptr", hGlobal)
}




/*---------------------------------------
	RUN DropFiles() BY CALL OF THIS FILE
-----------------------------------------
*/
$wint_title	= %1%
$file	= %2%

MsgBox,262144,wint_title, %$wint_title%,3

DropFiles( $wint_title, $file )