# TcCommand  

``` php
new TcCommand()	.cmd("minimal-command")	.create()/* RESULT:[em_minimal-command]	menu=minimal command	cmd=minimal-command	tooltip=minimal command	button=%systemroot%\system32\shell32.dll,43*/new TcCommand()	.prefix("TcCommand")	.name("command-paths")	.cmd("c:\GoogleDrive\TotalComander\Path-to-Total-Comamnder-is-escaped")	.param("%P", "%T")	.menu("Escape and add trailing slash to %P and %T params")	.tooltip("Toolbar text")		.create()	/* RESULT:[em_TcCommand-command-paths]	menu=TcCommand - Escape and add trailing slash to %P and %T params	cmd=%COMMANDER_PATH%\Path-to-Total-Comamnder-is-escaped	param="%P\" "%T\"      	tooltip=TcCommand - Toolbar text	button=%systemroot%\system32\shell32.dll,43*/ 
```  
  