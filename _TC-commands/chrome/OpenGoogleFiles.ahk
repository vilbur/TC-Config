/*
   Open Google files like '.gdsheet' in browser

   Example:
		OpenGoogleFiles.ahk "GoogleDrive\FooGoogleSheet.gdsheet"

*/

$file	= %1%

FileReadLine, $content, %$file%, 1
$match_count := RegExMatch( $content, "i)(https:\/\/[^""]+)", $url_match )

if($match_count)
	Run, %$url_match%

exitApp