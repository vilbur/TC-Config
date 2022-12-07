# TcShortcut  
* Create keyboard shortcut  

## Constructor  
| __TcShortcut__( [$name] )	|__ New	|  
|:---	|:---	|  
|`@param string` [ $name="" ]	|Name of command	|  

## Methods  

| __name__( $name )	| Name of command E.G.: "em_user-command"	|  
|:---	|:---	|  
|`@param string` $name	|	|  
|`@return self`	|	|  

##  

| __shortcut__( [$keys*], $keys )	|Set control keys	|  
|:---	|:---	|  
|`@param string` [ $keys* ]	|	|  
|`@return self`	|	|  
>Last parameter can be boolean for __force__ or __suspend__ creation  

##  

| __delete__()	|Delete shortcut	|  
|:---	|:---	|  
|`@return self`	|	|  

## Examples  
[include:\TcShortcutTest\TcShortcutTest.ahk]  
  