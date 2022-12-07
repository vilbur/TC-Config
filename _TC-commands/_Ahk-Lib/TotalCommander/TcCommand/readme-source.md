# TCcommand  
 * Call default and custom command in Total Commander  

## Methods  

| __TcCommand__( [$cmd], [$wait] )	|Constructor	|  
|:---	|:---	|  
|`@param string` [ $cmd="" ]	|Command name	|  
|`@param int` [ $wait=0 ]	|Wait before call	|  

##  

| __cmd__( $cmd, [$wait] )	|Set command	|  
|:---	|:---	|  
|`@param string` $cmd	|Command name	|  
|`@param int` [ $wait=0 ]	|Wait before call	|  
|`@return self`	|	|  

##  

| __call__()	|Call commands	|  
|:---	|:---	|  
|`@return self`	|	|  

##  

| __keyDelay__( $delay, $press_duration )	|Set key dealy for calling user commands	|  
|:---	|:---	|  
|`@param string` $delay	|	|  
|`@param string` $press_duration	|	|  
>Default is SetKeyDelay, 50, 10  

##  


## Examples  
[include:\Test\TcCommandTest.ahk]  




  