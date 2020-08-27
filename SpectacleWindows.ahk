#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include WinGetPosEx.ahk

#!Left::ResizeToggle(False)
return

#!Right::ResizeToggle(True)
return

#!f::ResizeFull()
return

prev_x := 0
prev_y := 0
prev_w := 0
prev_h := 0

ResizeWin(x, y, w, h) 
{ 
    WinMove, A,, x, y, w, h 
}

ResizeFull() 
{
    WinGet mx, MinMax, A
    if (mx)
    {
        WinRestore A
    }
    else
    {
        WinMaximize, A
    }
}

ResizeToggle(r) {
    ; get primary monitor info
    SysGet, pi, MonitorPrimary
    ; SysGet, pm, Monitor, pi
    SysGet, pm, MonitorWorkArea, pi
    ; MsgBox, Left: %pmLeft% Top: %pmTop% Right: %pmRight% Bottom: %pmBottom%

    ; get active window info
    ; WinGetPos, x, y, w, h, A
    ; gotta use the invisible border offset
    WinGetPosEx(WinExist("A"), x, y, w, h, off_x, off_y)
    x := x + off_x
    w := w - off_x * 2

    ; define sizes
    half := pmRight / 2 - off_x * 2
    two3rd := pmRight * 2 / 3 - off_x * 2
    one3rd := pmRight / 3 - off_x * 2

    ; define positions if left side
    pos_half := 0 + off_x
    pos_two3rd := 0 + off_x
    pos_one3rd := 0 + off_x

    ; redefine positions if right side
    if (r)
    {
        pos_half := pmRight - half - off_x
        pos_two3rd := pmRight - two3rd - off_x
        pos_one3rd := pmRight - one3rd - off_x
    }

    ; expected position
    pos_expected := False
    if (!r)
    {
        ; right side is always 0
        ; in some cases it's less, not sure why
        pos_expected := x <= 0 
    }
    else
    {
        ; left side expected pos depends on current window size
        if (w = half)
        {
            pos_expected := x = pos_half
        }
        else if (w = two3rd)
        {
            pos_expected := x = pos_two3rd
        }
        else if (w = one3rd)
        {
            pos_expected := x = pos_one3rd
        }
    }

    ; logic for switching between sizes
    ; if position is not expected, start with half
    ; then cycle:
    ; half -> two3rd -> one3rd
    ; if (w != half  && w != two3rd)
    if (!pos_expected || w != half  && w != two3rd)
    {
        WinMove, A,, pos_half, 0, half, pmBottom - off_y * 2
    }
    else if (w = half)
    {
        WinMove, A,, pos_two3rd, 0, two3rd, pmBottom - off_y * 2
    }
    else
    {
        WinMove, A,, pos_one3rd, 0, one3rd, pmBottom - off_y * 2
    }
}