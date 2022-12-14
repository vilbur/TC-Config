# TcButtonBarButton  
 *		Button in button bar  

__CREATE BUTTON OF TYPES:__  
1. Custom button  
2. From command  
3. Separator  
4. Empty button  

## Create button methods  

| __TcButtonBarButton__( [$file] )	|Constructor	|  
|:---	|:---	|  
|`@param string` $file	|path to \*cmd.ini file or \*.bar file	|  

##  

| __loadCommand__( $name ) |Load command as button from cmd.ini E.G.: Usercmd.ini	|  
|:---	|:---	|  
|`@param string` $name	|Command name from "Usercmd.ini" E.G.: "em_custom-command"	|  
|`@return self`	|	|  

##  

| __loadButton__( $position )	|Load button from \*.bar file	|  
|:---	|:---	|  
|`@param int` $position	|Position of button in \*.bar file	|  
|`@return self`	|	|  

##  

| __empty__()	|Create empty button	|  
|:---	|:---	|  
|`@return self`	|	|  

##  

| __join__( $position )	|Alias for this.menu()	|  
|:---	|:---	|  
|`@param string` $position	|	|  





## Button parameters methods  
| __cmd__( [$cmd] )	|Set\Get cmd property	|  
|:---	|:---	|  
|`@param string` $cmd	|	|  
|`@return self|string`	|	|  

##  

| __param__( [$param] )	|Set\Get param property	|  
|:---	|:---	|  
|`@param string` $param	|	|  
|`@return self|string`	|	|  

##  

| __button__( [$icon], [$index] )	|Set\Get button property	|  
|:---	|:---	|  
|`@param string` $icon	|	|  
|`@param string` $index	|	|  
|`@return self|string`	|	|  

##  

| __iconic__( [$iconic] )	|Set\Get iconic property	|  
|:---	|:---	|  
|`@param string` $iconic	|	|  
|`@return self|string`	|	|  

##  

| __menu__( [$tooltip] )	|Set\Get menu property	|  
|:---	|:---	|  
|`@param string` $tooltip	|	|  
|`@return self|string`	|	|  

##  

| __icon__( $icon, [$index] )	|Set icon, alias for button()	|  
|:---	|:---	|  
|`@param string` $icon	|	|  
|`@param string` $index	|	|  
|`@return self`	|	|  

##  

| __tooltip__( [$tooltip] )	|Set tooltip, alias for menu()	|  
|:---	|:---	|  
|`@param string` $tooltip	|	|  
|`@return self`	|	|  

## Examples  
[include:\Test\TcButtonBarButtonTest.ahk]  
  