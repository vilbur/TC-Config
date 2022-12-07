#SingleInstance force

;;; return multiarray for all mathes
;;; E.G.: 1st level of array is selections of regex and 2nd level are matches
;;;     $string := "c:\temp\subfolder"
;;;     $regex  := "(\\)([^\\]+)"
;;;     return [
;;;         ["\"],
;;;         [
;;;             "temp",
;;;             "subfolder"
;;;         ]
;;;     ]
;;;
RegExMatchAll($string, $regex){

    $rx_pos = 1
	$matches := Array()

	/*
		IF MULTIPLE MATCHES
	*/
	While $rx_pos := RegExMatch($string,  $regex, $match, $rx_pos+StrLen($match)) {
        ;;; SET EMPTY SUB ARRAYS FOR SELECTIONS
        if ( $matches.length() == 0 )
        	While ( $match%A_Index% !="" )
                $matches.push(Array())
        	While ( $match%A_Index% !="" )
                $matches[A_Index].push( $match%A_Index% )
	}

	/*
		IF FULL MATCH E.G: $test := RegExMatchAll( "test", "test" )
	*/
	if ( $matches.length() == 0 ) {
		$string_match_count := RegExMatch( $string, $regex, $url_match )
		if($string_match_count)
			return % [$url_match]
	}

	return %$matches%
}



;$folders := RegExMatchAll("c:\d3\d2\d1\file.txt", "([\\\/])([^\\\/]+)")
;;$folders := RegExMatchAll("c:\d1\file.txt", "([\\\/])([^\\\/]+)")
;;MsgBox,262144,, folders: %$folders%, 5
;dump($folders, 50)
