# TcCommandSetter  

``` php
$prefix := "TcCommand Test"              ;;;COMMAND           MENU         TOOLTIP                ICON                             PARAMETERS$commands := {"command-full":["Menu Text", "Tooltip", "%systemroot%\system32\shell32.dll,23", ["multiple", "params"]]							             ,"command-path":[         "",        "",                                     "", "%P"                 ]}			 new TcCommandSetter()		.prefix($prefix)		.commands($commands)		.createCommands()/* RESULT TO COMMANDS:   [em_TcCommand_Test-command-full]	menu=TcCommand Test - Menu Text	cmd=command-full	param=multiple params         	tooltip=TcCommand Test - Tooltip	button=%systemroot%\system32\shell32.dll,23 [em_TcCommand_Test-command-path]	menu=TcCommand Test - command path	cmd=command-path	param="%P\"       	tooltip=TcCommand Test - command path	button=%systemroot%\system32\shell32.dll,43	*/
```  
  