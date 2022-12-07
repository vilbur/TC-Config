##  
# TcCommandCreator  
* Create command in Total Commander  

## Constructor  

| __TcCommandCreator__( [$name] )	|Constructor	|  
|:---	|:---	|  
|`@param string` [ $name="" ]	|Name of command	|  

## Parameters methods  

| __prefix__( [$prefix] )	|Set prefix for commands name, menu and tooltip text	|  
|:---	|:---	|  
|`@param string` [ $prefix="" ]	|	|  
|`@return self`	|	|  

##  

| __name__( $name )	|Set name of command	|  
|:---	|:---	|  
|`@param string` $name	|Name of command	|  
|`@return self`	|	|  

##  

| __cmd__( $cmd )	|Set of command	|  
|:---	|:---	|  
|`@param string` $cmd	|cmd key in Usercmd.ini	|  
|`@return self`	|	|  

##  

| __param__( $params*, $params )	|Set params of command	|  
|:---	|:---	|  
|`@param string` $params*	|	|  
|`@param string` $params	|Any number of parmeters, param key in Usercmd.ini	|  
|`@return self`	|	|  

##  

| __menu__( $menu )	|Set menu text of command	|  
|:---	|:---	|  
|`@param string` $menu	|Menu key in Usercmd.ini	|  
|`@return self`	|	|  

##  

| __tooltip__( $tooltip )	|Set tooltip of command	|  
|:---	|:---	|  
|`@param string` $tooltip	|Menu key in Usercmd.ini	|  
|`@return self`	|	|  

##  

| __icon__( $icon )	|Set Icon of command	|  
|:---	|:---	|  
|`@param string` $icon	|button key in Usercmd.ini	|  
|`@return self`	|	|  

## Create & delete command  

| __create__()	|write command to Usercmd.ini	|  
|:---	|:---	|  
|`@return self`	|	|  

##  

| __delete__()	|Delete command from Usercmd.ini	|  
|:---	|:---	|  
|`@return self`	|	|  

##  

| __shortcut__( [$keys*] )	|Create keyboard shortcut or get TcShortcut if params are empty	|  
|:---	|:---	|  
|`@param string` [ $keys* ]	|Keys for shortcut	|  
|`@return self|[TcShortcut](/TcShortcut)`	|	|  

##  



## Examples  
[include:\Test\TcCommandCreatorTest.ahk]  