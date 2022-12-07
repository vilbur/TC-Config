# TcSubButtonBar   * Set button bar as button   * Icon is assigned to button, if *.ico named as button bar exist in folder E.g.: Buttonbar.bar & Buttonbar.ico  ## Methods  | __bar__( [$buttonbar] )    |Get\Set TcButtonBar to button    |  |:---    |:---    |  |`@param TcButtonBar\|string` $buttonbar    |TcButtonBar object OR path to \*.bar file    |  |`@return self\|TcButtonBar`    |    |  ##  | __save__( [$buttonbar_path] )    |Save buttonbar    |  |:---    |:---    |  |`@param string` $buttonbar_path    |    |  |`@return self`    |    |  ##  | __asBar__()    |Show subbar as bar    |  |:---    |:---    |  ##  | __asMenu__()    |Show subbar as menu    |  |:---    |:---    |  ##  | __backButton__( $main_buttonbar_path )    |Set first button of subbar as reference to main buttonbar    |  |:---    |:---    |  |`@param string` $main_buttonbar_path    |Path to main subbar    |  |`@return self`    |    |  ##  ## Examples  
``` php
global  $buttonbar_path     :=  A_ScriptDir "\ButtonBarTest.bar"
global  $sub_buttonbar_path :=  A_ScriptDir "\SubButtonBarTest.bar"/** Get New ButtonBar*/getButtonBar($loop:=2){    $TcButtonBar   := new TcButtonBar()
    $Button_empty  := new TcButtonBarButton().empty()
    $Button        := new TcButtonBarButton().cmd( "foo" )
                                             .icon("%systemroot%\system32\shell32.dll", 43)		Loop, % $loop {		$TcButtonBar.button( $Button  )		$TcButtonBar.button( $Button_empty  )			}		return $TcButtonBar}/** create button bar with sub bar*/createButtonBarWithSubBar(){    $ButtonBar     := getButtonBar(4)
    $SubButtonBar  := new TcSubButtonBar()
                        .bar(getButtonBar()) ; Link to getNewButtonBar() is below code block
                        .asBar()
                        .backButton($buttonbar_path)
                        .save($sub_buttonbar_path)							; // Add subbar as button to main button bar 	$ButtonBar.button($SubButtonBar, 1)	$ButtonBar.save($buttonbar_path)}/** */loadSubbarFromString(){	$TcSubButtonBar := new TcSubButtonBar().bar($sub_buttonbar_path)
}/** */loadSubbars(){	$TcButtonBar := new TcButtonBar().load($buttonbar_path)
}/*---------------------------------------	RUN TESTS-----------------------------------------*/createButtonBarWithSubBar()loadSubbarFromString()loadSubbars()
```  ## Result  ![SubButtonBarTest](Test/SubButtonBarTest.gif)    