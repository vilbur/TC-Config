 ;;;;Define the base class.
class _Object {

	_keys := [] ; store keys of object, keep order of keys

    __SET($key, $value){
		this._keys.push($key)
    }
;    __GET($key){
;		MsgBox,262144,__GET, %$key%,3
;    }
    __Call($fn, $aParams*){

		if($fn=="delete"){
			
			
			this._keys.delete(this._keys.indexOf($aParams[1]))
		}
    }
	/** get array of all keys in object
	*/
	keys(){
		return % this._keys
	}
	/** join
	*/
	join($delimeter:=" ", $object:="") {
		;if(!$object)
		;$object := $object?$object:this
		;	For $index, $item in $object
		;		$string .= (isObject($item)?this.join($delimeter, $item):$item) (A_Index<$object.length()?$delimeter:"")
		$object := $object?$object:this.keys()
			For $index, $key in $object
				$string .= (isObject($item)?this.join($delimeter, this[$key]):this[$key]) (A_Index<$object.length()?$delimeter:"")
		return %$string%
	}

	/** @return length of array
	  */
	length(){
		return % this.GetCapacity()
		;return % this.array.MaxIndex()
	}
	/** find
	*/
	find($needle){
		for $key, $value in this
			if ($value == $needle)
				return $key
		return 0
	}
	/* merege
	*/
	merge($obj){
		For $key, $value in $obj
			this[$key] := $value
		return this
	}


	/** test
	*/
	test(){
		MsgBox,262144,, % "Obj.TEST" ,2
		;Dump(this, "this.", 1)
	}
}


; https://autohotkey.com/board/topic/89380-lets-play-with-objects-and-base/

Obj(param:=""){


	$obj	:= {}
	$obj.base	:= new _Object()
	For $key, $value in param?param:{}
		$obj[$key] := $value

	Return %$obj%
}














Obj_Max($object,$value_key:="value") {

	MsgBox,262144,, FUNCTION Obj_Max() is DEPRECATED`nWrite method in Obj.ahk`nuse:Obj().max(),2
    For $key, $value in $object
        if ( $max_value < $value ) {
            $max_value  = %$value%
            $max_key    = %$key%
        }
    return %  $value_key=="value" ? $max_value : $max_key
}

Obj_Min($object,$value_key:="value") {
 	MsgBox,262144,, FUNCTION Obj_Min() is DEPRECATED`nWrite method in Obj.ahk`nuse:Obj().min(),2
   For $key, $value in $object
        if ( $min_value > $value ) {
            $min_value  = %$value%
            $min_key    = %$key%

        return %  $value_key=="value" ? $min_value : $min_key
    }
}
/*
	@return index of given item
*/
Obj_indexOf($object, $key_search ) {
	;MsgBox,262144,, FUNCTION Obj_indexOf() is DEPRECATED`nuse:Obj().find(),2

    ;MsgBox,262144,, Obj_ToArrayPairs, 2
    $joined_pairs := Array()
    ;;; JOIN key - value pair
    For $key, $value in $object
		if ($key==$key_search)
			return %A_Index%
    ;{
    ;    $joined_pair = %$key%%$delimetr%%$value%
    ;    $joined_pairs.insert( $joined_pair )
    ;    ;MsgBox,,, % $value, 3
    ;}
    ;dump($joined_pairs, 50)
    ;return %$joined_pairs%


}
;;;; ------------------------------------------------------------------------------------------------------------------------
;;;; GEt count of assoc array
;;;;
;;;; return integer
;;;; ------------------------------------------------------------------------------------------------------------------------
Obj_Length($array){
	MsgBox,262144,, FUNCTION Obj_Length() is DEPRECATED`nuse:Obj().length(),2

    for $key, $value in $array
    $count++
    return %$count%
}


Obj_ToArray($object){
 	MsgBox,262144,, FUNCTION Obj_ToArray() is DEPRECATED`nWrite method in Obj.ahk`nuse:Obj().ToArray(),2
   $array := Array()
    For $key, $value in $object
        $array.insert( $value )
    return %$array%
}


;;; ------------------------------------------------------------------------------------------------------------------------
;;; Convert associative object into key=value pair array
;;; E.G.: Obj_ToArrayPairs( {"key":"value"}, "=") RETURNS [key=value]
;;;
;;; return array
;;; ------------------------------------------------------------------------------------------------------------------------
Obj_ToArrayPairs($object, $delimetr:="=") {
 	MsgBox,262144,, FUNCTION Obj_ToArrayPairs() is DEPRECATED`nWrite method in Obj.ahk`nuse:Obj().ToArray(),2

    ;MsgBox,262144,, Obj_ToArrayPairs, 2
    $joined_pairs := Array()
    ;;; JOIN key - value pair
    For $key, $value in $object
    {
        $joined_pair = %$key%%$delimetr%%$value%
        $joined_pairs.insert( $joined_pair )
        ;MsgBox,,, % $value, 3
    }
    ;dump($joined_pairs, 50)
    return %$joined_pairs%


}
;/** get array of all keys in object
;*
;*
;*/
;Obj_Keys($object){
;	$keys	:= []
;	For $key, $value in $object
;	    $keys.push( $key )
;
;	return %$keys%
;
;}