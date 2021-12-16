!l::
    Run, nircmd.exe monitor off
    DllCall("LockWorkStation")

!h::
    DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)

; This script is modified from https://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows
; which is itself modified from: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; which is licensed under the GPLv2: https://www.autohotkey.com/docs/license.htm

Alt & LButton::
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, ALTDRAG_MouseStartX, ALTDRAG_MouseStartY, ALTDRAG_MouseWin
    WinGet, ALTDRAG_WinState, MinMax, ahk_id %ALTDRAG_MouseWin%
    if ALTDRAG_WinState != 0
    {
        WinRestore ahk_id %ALTDRAG_MouseWin%
        WinGetPos,,, ALTDRAG_WinWidth, ALTDRAG_WinHeight, ahk_id %ALTDRAG_MouseWin%
        WinMove, ahk_id %ALTDRAG_MouseWin%,, ALTDRAG_MouseStartX - ALTDRAG_WinWidth / 2, ALTDRAG_MouseStartY - ALTDRAG_WinHeight / 2
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
    MouseGetPos, ALTDRAG_MouseX, ALTDRAG_MouseY
    WinGetPos, ALTDRAG_WinX, ALTDRAG_WinY,,, ahk_id %ALTDRAG_MouseWin%
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    WinMove, ahk_id %ALTDRAG_MouseWin%,, ALTDRAG_WinX + ALTDRAG_MouseX - ALTDRAG_MouseStartX, ALTDRAG_WinY + ALTDRAG_MouseY - ALTDRAG_MouseStartY
    ALTDRAG_MouseStartX := ALTDRAG_MouseX  ; Update for the next timer-call to this subroutine.
    ALTDRAG_MouseStartY := ALTDRAG_MouseY
    return

; This is based on https://www.howtogeek.com/howto/44915/how-to-change-window-transparency-in-windows-7/ but rewritten
TransparencyDelta() {
    return 32
}

WinGetTransparency()
{
    local Transparency
    WinGet, Transparency, Transparent, A
    if (Transparency = "")
    {
        Transparency = 255
    }
    return Transparency
}

Clamp(Value, MinV, MaxV)
{
    return Min(MaxV, Max(MinV, Value))
}

WinChangeTransparency(Delta)
{
    local Transparency := WinGetTransparency()
    local NewTransparency := Clamp(Transparency + Delta, TransparencyDelta(), 255)
    WinSet, Transparent, %NewTransparency%, A
}

#o::
    ToggleTransparency()
    {
        local Transparency := WinGetTransparency()
        if Transparency = 255
        {
            WinSet, Transparent, 127, A
        }
        else
        {
            WinSet, Transparent, OFF, A
            WinSet, Transparent, 255, A
        }
        return
    }

#WheelUp::
    IncreaseTransparency()
    {
        WinChangeTransparency(TransparencyDelta())
    }

#WheelDown::
    DecreaseTransparency()
    {
        WinChangeTransparency(-TransparencyDelta())
    }
