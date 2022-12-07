# TcButtonBar  
* Actions with \*.bar file  

## Bar methods  

| __load__( [$buttonbar_path] )	|Load \*.bar file	|  
|:---	|:---	|  
|`@param string` $buttonbar_path	|If empty, current \*.bar is used	|  
|`@return self`	|	|  

##  

| __save__( [$buttonbar_path] )	|Save button bar	|  
|:---	|:---	|  
|`@param string` $buttonbar_path	|Path to button bar	|  
|`@return self`	|	|  

##  

| __path__( [$buttonbar_path] )	|Get\Set path	|  
|:---	|:---	|  
|`@param string` $buttonbar_path	|Path to button bar	|  
|`@return self|string`	|	|  


## Button methods  

| __command__( $command, [$position] )	|Add command from usercmd.ini	|  
|:---	|:---	|  
|`@param string` $command	|Command name E.g.:  "em_custom-command"	|  
|`@param int` $position	|Position of button, add as last if not defined	|  
|`@return self`	|	|  

##  


| __button__( $Button, [$position] )	|Get\Set button object to \_buttons	|  
|:---	|:---	|  
|`@param TcButtonBarButton|int` $Button	|Button to be added, or button position to get	|  
|`@param int` $position	|Position of button, add as last if not defined	|  
|`@return self`	|	|  

##  

| __remove__( $position )	|Remove button at position	|  
|:---	|:---	|  
|`@param int` $position	|Position of button	|  

##  


## Examples  

__Get TcButtonBar object__  
[include:\Test\Helpers\getNewButtonBar.ahk]  

__Save\load button bars__  
[include:\Test\TcButtonBarTest.ahk]  


































  