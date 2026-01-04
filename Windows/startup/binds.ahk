#Requires AutoHotkey v2.0
#SingleInstance force
SendMode("Input")
SetCapsLockState("alwaysoff")

#a:: Send("ä")
#+a:: Send("Ä")
#o:: Send("ö")
#+o:: Send("Ö")
#u:: Send("ü")
#+u:: Send("Ü")
#s:: Send("ß")
#+2:: Send("€")

VOLUME_STEPS := 3
$Volume_Down:: Send("{Volume_Down " . VOLUME_STEPS . "}")
$Volume_Up:: Send("{Volume_Up " . VOLUME_STEPS . "}")

CapsLock Up:: {
    if (A_PriorKey == "CapsLock") {
        Send("{Escape}")
    }
    ; TODO copy QMK logic instead -- track via variable
    if !GetKeyState("Control", "P") {
         Send("{Ctrl Up}")
    }
}


#HotIf GetKeyState("CapsLock", "P")
    ; Media controls
    Escape:: Send("{Media_Play_Pause}")
    F1:: Volume_Down
    F2:: Volume_Up
    
    ; Playback controls
    Left:: Media_Prev
    Right:: Media_Next
    
    ; Tab controls
    *Tab:: {
        ; TODO copy QMK logic instead -- track via variable
        Send("{Ctrl down}") 
        Send("{Tab}") 
    }
    2:: ^PgUp
    3:: ^PgDn
    
    ; Page controls
    ,:: PgUp
    .:: PgDn

    *Backspace:: *Delete
    
    ; Vim arrow bindings
    *h:: Left
    *n:: Down
    *e:: Up
    *i:: Right
    
    ; Vim controls
    u:: ^u
    d:: ^d

    q:: !f4  ; cmd-q
    1:: ^f4  ; cmd-w
    
    w:: #1
    f:: #2
    p:: #3
	
    a:: #4
    r:: #5
	s:: #6
	t:: #7
	
	x:: #8
	c:: #9
#HotIf
