;#NoTrayIcon
#SingleInstance force


$temp_path	:=  A_Temp . "\TC_hardlink_test"
$source_path	:=  $temp_path . "\source"
$target_path	:=  $temp_path . "\target"


/** Create test dirs 
 *	
 */
FileCreateDir, %$temp_path%
FileCreateDir, %$target_path%
FileCreateDir, %$source_path%
FileCreateDir, %$source_path%\Test_folder_1

FileCreateDir, %$source_path%\Backup_test_of_existing_folder
FileCreateDir, %$target_path%\Backup_test_of_existing_folder

/** Create test files 
 *	
 */
FileAppend, , %$source_path%\hardlink_test_1.txt 
FileAppend, , %$source_path%\hardlink_test_2.txt 

MsgBox,262144,, Folder for testing has been created:`n`n %$temp_path% `n`n hardlink_create.ahk must be tested manually