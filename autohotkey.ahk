; This script is modified from https://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows
; which is itself modified from: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; which is licensed under the GPLv2: https://www.autohotkey.com/docs/license.htm

Alt & LButton::
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, ALTDRAG_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGet, ALTDRAG_WinState, MinMax, ahk_id %EWD_MouseWin%
    if ALTDRAG_WinState != 0
    {
        WinRestore ahk_id %ALTDRAG_MouseWin%
        WinGetPos,,, ALTDRAG_WinWidth, EWD_WinHeight, ahk_id %EWD_MouseWin%
        WinMove, ahk_id %ALTDRAG_MouseWin%,, EWD_MouseStartX - EWD_WinWidth / 2, EWD_MouseStartY - EWD_WinHeight / 2
    }
    SetTimer, ALTDRAG_WatchMouse, 10 ; Track the mouse as the user drags it.
    return

ALTDRAG_WatchMouse:
    GetKeyState, ALTDRAG_LButtonState, LButton, P
    if ALTDRAG_LButtonState = U  ; Button has been released, so drag is complete.
    {
        SetTimer, ALTDRAG_WatchMouse, off
        return
    }
    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse:
    CoordMode, Mouse
    MouseGetPos, ALTDRAG_MouseX, EWD_MouseY
    WinGetPos, ALTDRAG_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    WinMove, ahk_id %ALTDRAG_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    ALTDRAG_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
    ALTDRAG_MouseStartY := EWD_MouseY
    return
