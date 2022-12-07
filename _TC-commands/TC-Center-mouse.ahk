#NoTrayIcon
#SingleInstance force
;;; CENTER MOUE CURSOR IN ToTAL COMMANDER WINDOW

WinActivate, ahk_class TTOTAL_CMD
IfWinActive, ahk_class TTOTAL_CMD
{
    WinGetPos, $win_X, $win_Y, $win_width, $win_Height, ahk_class TTOTAL_CMD
    $mouse_X := $win_width /2 + 12
    $mouse_Y := $win_height /2
    MouseMove, $mouse_X, $mouse_Y, 0
}

exitApp