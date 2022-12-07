# TcSubButtonBar  
 * Set button bar as button  
 * Icon is assigned to button, if *.ico named as button bar exist in folder E.g.: Buttonbar.bar & Buttonbar.ico  

## Methods  

| __bar__( [$buttonbar] )	|Get\Set TcButtonBar to button	|  
|:---	|:---	|  
|`@param TcButtonBar|string` $buttonbar	|TcButtonBar object OR path to \*.bar file	|  
|`@return self|TcButtonBar`	|	|  

##  

| __save__( [$buttonbar_path] )	|Save buttonbar	|  
|:---	|:---	|  
|`@param string` $buttonbar_path	|	|  
|`@return self`	|	|  

##  

| __asBar__()	|Show subbar as bar	|  
|:---	|:---	|  

##  

| __asMenu__()	|Show subbar as menu	|  
|:---	|:---	|  

##  

| __backButton__( $main_buttonbar_path )	|Set first button of subbar as reference to main buttonbar	|  
|:---	|:---	|  
|`@param string` $main_buttonbar_path	|Path to main subbar	|  
|`@return self`	|	|  

##  

## Examples  

[include:\Test\TcSubButtonBarTest.ahk]  

## Result  
![SubButtonBarTest](Test/SubButtonBarTest.gif)  
  