;
; AutoHotKey file for DJs
; Created by DJ Estrela, 2019
;
;
; User Commmands:
;   CTRL+F08: Search in Discogs
;   CTRL+ALT+F08: Search in Google
;
;   CTRL+F09: search text in File Explorer
;   CTRL+F10: search text in soulseek
;   CTRL+F11: search text in Youtube (first 5 hits to clipboard)
;   CTRL+F12: search text in Youtube (first hit)
;   
;   CTRL+ALT+F11: send chrome url to clipboard  (all tabs)
;   CTRL+ALT+F12: send chrome url to clipboard  (current tab)
;

; Diacritic characters support:
;   CTRL+WIN+ALT+A: Toggle diacritic vowels support
;
;   CTRL+A: cycle diacritic "a"
;   CTRL+E:  (same)
;   CTRL+I:  (same)
;   CTRL+O:  (same)
;   CTRL+U:  (same)
;
;
; Maintenance:  
;   CTRL+WIN+ALT+ESC = Emergency stop
;   CTRL+WIN+ALT+F11 = Debug mouse XY values (cycle)
;   CTRL+WIN+ALT+F12 = Reload/Restart this script
;
;
;
; Other program  shortcuts:
;   Win+BackSpace: windows always on top
;   Shift+MouseWheel: folder history
;   CTRL+R: show extensions
;   ` - solo track audition
;   CTRL+` - mute track audition
;
;
;
; Ideas:
;   https://www.reddit.com/r/AutoHotkey/comments/7y4k8m/automatically_search_selected_text_in_youtube_and/
;   https://autohotkey.com/board/topic/51282-auto-copy-url/
;
; References:
;   https://www.autohotkey.com/docs/Hotkeys.htm
;   https://www.autohotkey.com/docs/FAQ.htm
;   https://www.autohotkey.com/docs/Tutorial.htm
;   https://jszapp.com/autohotkey-scripting-operators/#Assignment
;  
; String functins:
;   https://www.autohotkey.com/boards/viewtopic.php?t=32985

; 
; Functions:
;   https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm
;   https://www.autohotkey.com/docs/misc/WinTitle.htm
;   https://www.autohotkey.com/docs/commands/WinGetPos.htm
;   https://www.autohotkey.com/docs/Variables.htm#CoordMode
;   https://www.autohotkey.com/docs/commands/CoordMode.htm
;   https://www.autohotkey.com/docs/commands/Click.htm
;   https://www.autohotkey.com/docs/Variables.htm
;
;
; Quoting Guide:
;   commands:
;     variables need "%"
;     strings NOT quoted
;     = (assignment)
;
;
;   expressions:
;     variables unquoted      
;     strings NEED quotes
;     := (expression assignment) 
;     .=  (string append)
;     .   (concatenate) 
;     (on commands, with the "%" operator)
;          
;
;
; Ideas:
;   https://superuser.com/questions/1203029/wsl-trailing-whitespaces-being-added-to-bash-code-pasted-into-cmd-wsl-tty-per
;
; "cant live" little programs:  https://www.neogaf.com/threads/some-of-my-cant-live-without-progams-what-are-yours.1482889/
;  Clipboard History Lite - 10 clipbaord with caps lock
;  Everything for windows file search
;  Link Clump - Chrome Extension - Open Multiple Links with "Z" key
;
;  Puretext - Strips formatting when pasting.
;  ShareX - Screenshot tool (very comprehensive 
;  Directory Opus - File Manager
;  Directory Report - find wasted space, duplicates, etc
;

; Use SetControlDelay -1;    parameter NA 6th

; Examples:
;  +!^j::
;  MsgBox, There are
; Run, notepad.exe
; WinActivate, Untitled - Notepad
; WinWaitActive, Untitled - Notepad
; Send, 7 lines{!}{Enter}
; SendInput, inside the CTRL{+}J hotkey.
; return


;+!^b::  ; CTRL+B hotkey
;Send, {Ctrl down}c{Ctrl up}  ; Copies the selected text. ^c could be used as well, but this method is more secure.
;SendInput, [b]{Ctrl down}v{Ctrl up}[/b] ; Wraps the selected text in BBCode tags to make it bold in a forum.
;return  ; This ends the hotkey. The code below this point will not get triggered.

; Send, This text has been typed{!}   ; Notice the ! between the curly brackets? That's because if it wasn't, AHK would press the ALT key.


;;;
;;;  Windows multi-tasking helpers
;;;

; windows multitasking:: 
;   (settings / multitasking / snap)
;   (always whole borders  
;   mouse drag: back to random 
;
;
;
; State definition:
;   Random, Minimized, Maximized
;   20    21    22     23
;     RR    ..    XX     (true maximized)
;     RR    ..    XX 
;
;   Corners:
;    1    2   3   4  
;     0X   X0  00  00
;     00   00  X0  0X
;
;   Half-Screen:
;    5   6   7   8 
;     XX  00  X0  0X
;     00  XX  X0  0X
;
;
; Movement definition:
;   WIN + RIGHT: 
;   20    8    7    8 
;     RR   0X   X0   OX 
;     RR   0X   X0   OX
;
;    5    1    2    1 
;     XX   0X   X0   OX
;     00   00   00   O0
;
;    6    4    3    4
;     00   00   00   00
;     xx   0X   X0   OX
;
;
;   22    8
;     XX   0X
;     XX   0x
;
;
;   WIN + LEFT: 
;   20    7    8    7
;     RR   X0   OX   x0
;     RR   X0   OX   x0
;
;    5    2    1    2
;     XX   X0   OX   x0 
;     00   00   O0   00
;
;    6    3    4    3
;     00   00   00   00
;     xx   X0   OX   x0
;
;
;   22    7
;     XX   Xo
;     XX   Xo
;
;
;
;   WIN + DOWN: 
;
;   20   21   21
;     RR   ..   ..  
;     RR   ..   ..
;
;   1   8    4   21
;    0X  0X   00   .. 
;    00  0X   0X   ..
;
;   2   7    3
;    X0  X0   00   ..
;    00  X0   X0   ..
;
;   5   6
;    XX  00   ..  
;    00  XX   ..  
;      

;
;   WIN + UP: 
;
;   20   22   22
;     RR   XX   XX  
;     RR   XX   XX
;
;    4    8    1    5    22 
;     00   0X   0x   XX    xx
;     0X   0X   00   00    xx
;      
;    3   7   2   5
;     00  X0  x0  xx
;     X0  X0  00  00
;
;    6   5
;     00  XX   ..  
;     XX  00   ..  
;
;
;


;;;;;;;;;;
;;;;;;;;;; MONITOR definitions
;;;;;;;;;;

;; note1: parameter sequence is always: location, monitor, case
;; note2: default is: 1920x 1080



Monitor(x,y, w, h){
  mon := Object()
  
  mon.x0 := x
  mon.x1 := x + floor(w/3)
  mon.x2 := x + floor(w/2)
  mon.x3 := x + floor(w*2/3)
  mon.x4 := x + w

  mon.y0 := y
  mon.y1 := x + floor(h/3)
  mon.y2 := y + floor(h/2)
  mon.y3 := x + floor(h*2/3)
  mon.y4 := y + h
  
  return mon
}


mon_2_st(mon){
  st := ""

  st .= " Monitor(" . mon.x0 
  st .= " " . mon.x2 
  st .= " " . mon.x4
  
  st .= ", " . mon.y0  
  st .= " " . mon.y2 
  st .= " " . mon.y4  . ") "
  
  return st
}
     
     
print_mon(mon){

  print( mon_2_st(mon))
}

get_monitor(){
  return "TBD"
}

     
;;;;;;;;;;
;;;;;;;;;; LOCATIONS definitions
;;;;;;;;;;



Location(x, y, w, h, max){
  loc := {}
  
  loc.x := x
  loc.y := y
  loc.w := w
  loc.h := h

  loc.max := max 
  
  return loc
}


loc_2_st(loc){
  set := ""
  
  st .= "Location(" . loc.x
  st .= ", " . loc.y
  st .= ", " . loc.w
  st .= ", " . loc.h . ", "

  if(loc.max == 1){
    st .= " Maximized"
  } else if(loc.max == -1){
    st .= " Minimized"
  } else if(loc.max == 0){
    st .= " Normal"
  } else {
    st .= " error_maximize"
  }
  
  st .= ") " 
  
  return st
}


print_loc(loc){

  print( loc_2_st(loc))
}



get_location(){
  WinGetPos, wc_X, wc_Y, wc_Width, wc_Height, A    
  WinGet, wc_Max, MinMax, A                        ; are we maximized?   https://www.autohotkey.com/docs/commands/WinGet.htm#MinMax
 
  ;print1(wc_X)
  
  loc := Location(wc_X, wc_Y, wc_Width, wc_Height, wc_Max)
  return loc
}


loc_is_equal(l1, l2){
  return l1.x == l2.x and l1.y == l2.y and l1.w == l2.w and l1.h == l2.h 

}

 
;;;;;;;;;;
;;;;;;;;;; CASES definitions
;;;;;;;;;;

 
case_2_loc(mon, case){
 
  ;; shorthands
  x0 := mon.x0
  x1 := mon.x1
  x2 := mon.x2
  x3 := mon.x3
  x4 := mon.x4
  
  y0 := mon.y0
  y1 := mon.y1
  y2 := mon.y2
  y3 := mon.y3
  y4 := mon.y4
 
 
  y1 := "error"
  y3 := "error"
  
  
  ;; target variables
  max := 0
  x := 0
  y := 0
  w := 100
  h := 100
  
  if(case == "max"){
    ; real maximize
    max := 1
    
  } else if(case == "min"){
    ; real minimize
    max := -1
    
  } else if(case == "fmax"){
    ; fake minimize
    x := x0
    y := y0
    w := x4
    h := y4     

    
  ;;;;;;;; case 2   (mid)
  } else if(case == "tl2"){
    x := x0
    y := y0
    w := x2
    h := y2     

  } else if(case == "tr2"){
    x := x2
    y := y0
    w := x2
    h := y2 
    
  } else if(case == "bl2"){
    x := x0
    y := y2
    w := x2
    h := y2 
    
  } else if(case == "br2"){
    x := x2
    y := y2
    w := x2
    h := y2 
    
  } else if(case == "l2"){  
    x := x0
    y := y0
    w := x2
    h := y4

  } else if(case == "r2"){  
    x := x2
    y := y0
    w := x2
    h := y4
    
  } else if(case == "t"){
    x := x0
    y := y0
    w := x4
    h := y2
  
  } else if(case == "b"){
    x := x0
    y := y2
    w := x4
    h := y2
    
    
    
  ;;;;;;;;;; case 1  (1/3)
  } else if(case == "tl1"){
    x := x0
    y := y0
    w := x1
    h := y2     

  } else if(case == "tr1"){
    x := x1
    y := y0
    w := x3
    h := y2 
    
  } else if(case == "bl1"){
    x := x0
    y := y2
    w := x1
    h := y2 
    
  } else if(case == "br1"){
    x := x1
    y := y2
    w := x3
    h := y2 
    
  } else if(case == "l1"){  
    x := x0
    y := y0
    w := x1
    h := y4

  } else if(case == "r1"){  
    x := x1
    y := y0
    w := x3
    h := y4
    
    
    
  ;;;;;;;;;; case 3  (2/3)
  } else if(case == "tl3"){
    x := x0
    y := y0
    w := x3
    h := y2

  } else if(case == "tr3"){
    x := x3
    y := y0
    w := x1
    h := y2
    
  } else if(case == "bl3"){
    x := x0
    y := y2
    w := x3
    h := y2
    
  } else if(case == "br3"){
    x := x3
    y := y2
    w := x1
    h := y2
    
  } else if(case == "l3"){  
    x := x0
    y := y0
    w := x3
    h := y4

  } else if(case == "r3"){  
    x := x3
    y := y0
    w := x1
    h := y4
    

    
  } else {
    ; error case = center (TBD)
    x := 100
    y := 100
    w := 300
    h := 300
    
  }
    
   
  loc := Location(x,y,w,h, max )
  return loc
}



loc_equal_case(loc, mon, case){
  new_loc := case_2_loc(mon, case)
  
  return loc_is_equal(loc, new_loc)
}


loc_2_case(loc, mon){
  ;print("Doing get_case:", loc_2_st(loc), mon_2_st(mon))

  
  if(loc.max == 1){
    ; maximize
    case := "max"
      
  } else if(loc.max == -1){
    ; minimize
    case := "min"
    
  } else if(loc_equal_case(loc, mon, "fmax" )){
    ; FAKE maximize
    case := "fmax"
  
  
  ;;;;;;; case 2
  } else if(loc_equal_case(loc, mon, "tr2")){
    case := "tr2"

  } else if(loc_equal_case(loc, mon, "tl2")){
    case := "tl2"

  } else if(loc_equal_case(loc, mon, "br2")){
    case := "br2"

  } else if(loc_equal_case(loc, mon, "bl2")){
    case := "bl2"

    
  } else if(loc_equal_case(loc, mon, "t")){
    case := "t"

  } else if(loc_equal_case(loc, mon, "b")){
    case := "b"
  
  } else if(loc_equal_case(loc, mon, "l2")){
    case := "l2"
   
  } else if(loc_equal_case(loc, mon, "r2")){
    case := "r2"
    

  ;;;;;;;;;; case 1
  } else if(loc_equal_case(loc, mon, "tr1")){
    case := "tr1"

  } else if(loc_equal_case(loc, mon, "tl1")){
    case := "tl1"

  } else if(loc_equal_case(loc, mon, "br1")){
    case := "br1"

  } else if(loc_equal_case(loc, mon, "bl1")){
    case := "bl1"

    
  } else if(loc_equal_case(loc, mon, "l1")){
    case := "l1"
   
  } else if(loc_equal_case(loc, mon, "r1")){
    case := "r1"


  ;;;;;;;;; case 3
  } else if(loc_equal_case(loc, mon, "tr3")){
    case := "tr3"

  } else if(loc_equal_case(loc, mon, "tl3")){
    case := "tl3"

  } else if(loc_equal_case(loc, mon, "br3")){
    case := "br3"

  } else if(loc_equal_case(loc, mon, "bl3")){
    case := "bl3"

    
  } else if(loc_equal_case(loc, mon, "l3")){
    case := "l3"
   
  } else if(loc_equal_case(loc, mon, "r3")){
    case := "r3"
    
    
  } else {
    ; random case  
    case := "rr"
  
  }
  
  ;print(case)
  return case
}




;;;;;;;;;;;;;;
 
move_window(loc){

  debug := False
  if(debug){
    prev_loc := get_location()
    print_loc(loc)
  }
  
  x := loc.x
  y := loc.y
  w := loc.w
  h := loc.h
 
  WinMove, A,, %x%,  %y%, %w%, %h%
  
  debug_moved_window := False
  
  if(debug_moved_window){
    sleep, 50
    actual_loc := get_location()
  
    ;print("moved to", loc_2_st(loc),  "previous: ", loc_2_st(prev_loc), "actual:" , loc_2_st(actual_loc) )
  } 
}
     


do_enlarge(which_side){  
  ;beep()
  
  GoSub, tim_WM_DISPLAYCHANGE       ; get monitor dimensions
  Gosub, wc_sub_MouseHotkey
  
  WinGet, wc_Style, Style, A
  If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows == 0) AND cr_Resizeable <> 1)
    Return
  wc_Monitor := func_GetMonitorNumber("A")

  ; get ID, current dimensions, position and maximize status
  ;WinGet, wc_WindowID, ID, A                       ; This is used for the return to last known positon. Not used at the moment

  ;;;;;;;;;;;;
  mon := Monitor(WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)

  
  
  debug := False
  ;debug := True

  debug_print( debug, wc_X, wc_Y, wc_Width, wc_Height, point_x0, point_x1, point_x2, point_x3, point_x4 )
  debug_print( debug, point_x0, point_x1, point_x2, point_x3, point_x4 )
  debug_print( debug, wc_X, wc_Y, wc_Width, wc_Height )

  
  ;;;;;;;;;; new code below
  loc := get_location()  
  cur_case := loc_2_case(loc, mon)

  ;print("current case:", cur_case)
  
  debug := False
  ; debug := True
  
  if(debug){
    print_loc(loc)
    print_mon(mon)
  }
  
  
  t := Array()
  
  if(which_side == "left"){
    ;;; Maximizes
    t["fmax"] := "l2"
    t["max"]  := "l2"
    t["min"]  := "l2"
    t["rr"]   := "l2"
    
    ;;; Half-screen
    t["l1"] := "l3"
    t["l2"] := "l1"
    t["l3"] := "l2"
    
    t["r1"] := "l2" 
    t["r2"] := "l2" 
    t["r3"] := "l2"
    
    t["t"]  := "tl2"
    t["b"]  := "bl2"
    
    ;;; Corners
    t["tl1"] := "tl3"
    t["tl2"] := "tl1"
    t["tl3"] := "tl2"
    
    t["bl1"] := "bl3"
    t["bl2"] := "bl1"
    t["bl3"] := "bl2"
    
    t["tr1"] := "l2" 
    t["tr2"] := "l2" 
    t["tr3"] := "l2" 
    
    t["br1"] := "l2"
    t["br2"] := "l2"
    t["br3"] := "l2"
    
  } 
     
  
  if(which_side == "right"){
    t["fmax"] := "r"
    t["max"] := "r"
    t["min"] := "r"
    t["rr"] := "r"
    
    t["l"] := "r"
    t["r"] := "r" 
    t["t"] := "tr"
    t["b"] := "br"
    
    t["tl"] := "tr"
    t["bl"] := "br"
    t["tr"] := "r" 
    t["br"] := "r"
    
    
    ;;; Maximizes
    t["fmax"] := "r2"
    t["max"]  := "r2"
    t["min"]  := "r2"
    t["rr"]   := "r2"
    
    ;;; Half-screen
    t["r1"] := "r3"
    t["r2"] := "r1"
    t["r3"] := "r2"
    
    t["l1"] := "r2" 
    t["l2"] := "r2" 
    t["l3"] := "r2"
    
    t["t"]  := "tr2"
    t["b"]  := "br2"
    
    ;;; Corners
    t["tr1"] := "tr3"
    t["tr2"] := "tr1"
    t["tr3"] := "tr2"
    
    t["br1"] := "br3"
    t["br2"] := "br1"
    t["br3"] := "br2"
    
    t["tl1"] := "r2" 
    t["tl2"] := "r2" 
    t["tl3"] := "r2" 
    
    t["bl1"] := "r2"
    t["bl2"] := "r2"
    t["bl3"] := "r2"    
    
  } 
    
  
  if(which_side == "up"){    
    ;;; Maximizes
    t["fmax"] := "fmax"
    t["max"]  := "t"
    t["min"]  := "fmax"
    t["rr"]   := "fmax"
    
    ;;; Half-screen
    t["r1"] := "tr1"
    t["r2"] := "tr2"
    t["r3"] := "tr3"
    
    t["l1"] := "tl1" 
    t["l2"] := "tl2" 
    t["l3"] := "tl3"
    
    t["t"]  := "fmax"
    t["b"]  := "t"
    
    
    ;;; Corners
    t["tr1"] := "t"
    t["tr2"] := "t"
    t["tr3"] := "t"
    
    t["tl1"] := "t"
    t["tl2"] := "t"
    t["tl3"] := "t"
    
    t["br1"] := "tr1"
    t["br2"] := "tr2"
    t["br3"] := "tr3"
    
    t["bl1"] := "tl1"
    t["bl2"] := "tl2"
    t["bl3"] := "tl3"        
  }
      
 
  if(which_side == "down"){
    ;;; Maximizes
    ; Should we minimize instead?
    t["fmax"] := "b"
    t["max"]  := "b"
    t["min"]  := "b"
    t["rr"]   := "b"
    
    ;;; Half-screen
    t["r1"] := "br1"
    t["r2"] := "br2"
    t["r3"] := "br3"
    
    t["l1"] := "bl1" 
    t["l2"] := "bl2" 
    t["l3"] := "bl3"
    
    t["t"]  := "b"
    t["b"]  := "b"
    
   
    ;;; Corners
    t["br1"] := "b"
    t["br2"] := "b"
    t["br3"] := "b"
    
    t["bl1"] := "b"
    t["bl2"] := "b"
    t["bl3"] := "b"
    
    t["tr1"] := "br1"
    t["tr2"] := "br2"
    t["tr3"] := "br3"
    
    t["tl1"] := "bl1"
    t["tl2"] := "bl2"
    t["tl3"] := "bl3"      
  }
  
  
  ; We always leave maximized state
  if(cur_case == "max"){
     WinRestore, A

  }
  
    
  new_case := t[cur_case]
  if(new_case == ""){
    print("AHK: unknown transform", cur_case, which_side)
    new_case = "error"
    return
  }

  new_loc := case_2_loc(mon, new_case)
  
  ;debug := True
  if(debug){
    print("Transform:", cur_case, "=>", new_case, "    ", loc_2_st(new_loc))
  }
  
  move_window(new_loc)
  
}




test_arrays(){

  t := Object()
  
  t[20] := 22
  t[22] := 22

  t[4] := 8
  t[8] := 1
  t[1] := 5
  t[5] := 22

  t[3] := 7
  t[7] := 2
  t[2] := 5

  
  x := t[4]
  k := 5
  y := t[k]
  
  print(k, t[5], x, y )
  
}


test_objects(x,y){
  ret := Object()
  
  ret["k1"] := x
  ret.k2 := y
  
  xx := ret["k1"]
  yy := ret.k2
  
  print1("Testing objects")
  print1(x)
  print(y)
  print1(xx)
  print1(yy)
  print1(ret["k1"])
  print1(ret["k2"])
  return
 
}





func_GetMonitorNumber( Mode="" )
{
   global

   If Mode = Mouse
   {
      CoordMode, Mouse, Screen
      MouseGetPos, MouseX, MouseY

      Loop, %NumOfMonitors%
      {
         If (MouseX >= Monitor%A_Index%Left AND MouseX <= Monitor%A_Index%Right AND MouseY >= Monitor%A_Index%Top AND MouseY <= Monitor%A_Index%Bottom)
            Return %A_Index%
      }
   }
   Else
   {
      If (Mode == "" OR Mode == "ActiveWindow")
         Mode = A
      WinGetPos, WinX, WinY, WinW, WinH, %Mode%
      WinCenX := WinX + WinW/2
      WinCenY := WinY + WinH/2

      Loop, %NumOfMonitors%
      {
         If (WinCenX >= Monitor%A_Index%Left AND WinCenX <= Monitor%A_Index%Right AND WinCenY >= Monitor%A_Index%Top AND WinCenY <= Monitor%A_Index%Bottom)
            Return %A_Index%
      }

   }
   Return 1
}









;;;
;;;  Diacritic characters support (ie, accented characters)
;;;


diacritic_teste(shift)
{
  Clipboard = 
  send, +{left}
  send, ^x
  ClipWait, 1
  
  got := Clipboard
  msgbox, |%got%|
  diacritic_do_operation(got, shift)

}
  
  
diacritic_get_char(letter, shift, count){
  ; https://www.autohotkey.com/docs/misc/Arrays.htm
  ; https://github.com/nuj123/AutoHotKey/blob/master/misc/Typing%20Accents%20-%20Emulating%20Macs
  ; https://autohotkey.com/board/topic/16920-how-to-enter-basic-spanish-accented-characters/
  
  
  ret := "None"
  
  if(letter == "a"){
    if(shift == False){
      ret := ["{asc 0224}"  ; à
      , "{asc 0225}"  ; á
      , "{asc 0226}"  ; â
      , "{asc 0227}"]  ; ã
    } else {
      ret := ["{asc 0192}"  ; À
      , "{asc 0193}"  ; Á
      , "{asc 0194}"  ; Â
      , "{asc 0195}"]  ; Ã   
    }
  }
  
  if(letter == "e"){
    if(shift == False){
      ret := ["{asc 0232}"	; è
	, "{asc 0233}"	; é
	, "{asc 0234}"	; ê
	, "{asc 0101}"]	; e
     } else {
      ret := [ "{asc 0200}" 	; È
	, "{asc 0201}"	; É
	, "{asc 0202}"	; Ê
	, "{asc 0069}" ]	; E
     }
  }

  if(letter == "i"){
    if(shift == False){
      ret := ["{asc 0236}"	; ì
	, "{asc 0237}"	; í
	, "{asc 0238}"	; î
	, "{asc 0105}"	] ; i
     } else {
      ret := [ 	 "{asc 0204}"	; Ì
	, "{asc 0205}"	; Í
	, "{asc 0206}"	; Î
	, "{asc 0073}"]	; I

     }
  }


  if(letter == "o"){
    if(shift == False){
      ret := ["{asc 0242}"	; ò
        , "{asc 0243}"	; ó
        , "{asc 0244}"	; ô
        , "{asc 0245}" ]	; õ
     } else {
      ret := ["{asc 0210}"	; Ò
        , "{asc 0211}"	; Ó
        , "{asc 0212}"	; Ô
        , "{asc 0213}"]	; Õ
     }
  }
  
  
  if(letter == "u"){
    if(shift == False){
      ret := ["{asc 0249}"	; ù
	, "{asc 0250}"	; ú
	, "{asc 0251}"	; û
	, "{asc 0117}"	] 
      
     } else {
     
      ret := ["{asc 0217}"	; Ù
	, "{asc 0218}"	; Ú
	, "{asc 0219}"	; Û
	, "{asc 0085}"] 	; U
     }
  }
    
  if(ret == "None"){
    ret := letter
  } else  {    
    ret := ret[count]
  }
  return ret
}
 


diacritic_do_operation(letter, shift)
{
  global diacritic_current
  global diacritic_cycling
  
  diacritic_cycling := 1
 
  diacritic_current += 1
  if(diacritic_current > 4){
    diacritic_current := 1
  }
  
  to_send := diacritic_get_char(letter, shift, diacritic_current)
  
  if(diacritic_cycling){
    send, {BackSpace}
  }
  
  send, %to_send%
  
  diacritic_cycling := 1
  ; msgbox, |%to_send%| %current%
  
}



diacritic_toggle()
{
  global diacritic_enabled
  
  beep()
  ; msgbox % diacritic_enabled
  
  diacritic_enabled := ! diacritic_enabled
}

  
; how to get all open tabs
; https://autohotkey.com/board/topic/84158-generic-way-to-get-urls-from-multi-tab-browser/




;;;
;;; Functions
;;;

strip(String, OmitChars := " `t"){
  return Trim(String, OmitChars)
}

len(String){
  return StrLen(String)
}


; removes all special characters, makes lowercase, keeps "\n" for breaking lines later
normalize_query( query , remove_digits := true ){
  StringLower, query, query
  StringReplace, query, query, `r`n, `n, All   ; support both windows and unix text
  
  query := RegExReplace(query, "[^a-z0-9\n]", " ")
  if(remove_digits){
    query := RegExReplace(query, "[^a-z\n]", " ")
  }  
  query := strip(query)
  
  return query
}

; cleans 
url_prepare_query( query ){
  ; query := "Layo & Bushwa2cka*	Lo4ve 4"
  
  query := normalize_query(query)
  query := StrReplace(query, " ", "+")
  
  return query
}


get_search_engine_url(query, what)
{
  query := url_prepare_query(query)
  
  if(what == "google"){ 
    url := "http://www.google.com/search?q=" query
  }
  else if (what == "discogs"){ 
    url := "https://www.discogs.com/search?q=" query
  }
  return url
}

; gets the first youtube result for a string
open_search_engine( query , what)
{
	url := get_search_engine_url(query, what)
  Run % url
}


gen_youtube_url(query){
  query := url_prepare_query( query )
	url := "https://www.youtube.com/results?search_query=" query

  return url
}

; returns the first youtube result for a string
all_youtube_results( query ){
	url := gen_youtube_url(query)

	Run % url
}


; returns the HTML text for further processing
query_youtube_as_html(query)
{
  url := gen_youtube_url(query)

  ;MsgBox, %url%
  ;return
  
	r := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	r.Open("GET", url, true)
	r.Send()
	r.WaitForResponse()

  return r.ResponseText
}


; returns the first youtube result for a string
first_youtube_result( query ){
  text := query_youtube_as_html(query)

	if RegExMatch( text, "/watch\?v=.{11}", match ){
		url := "https://www.youtube.com" match
  } else {
    url := ""
  }  
	return url
}


RxMatches(Haystack, Needle) 
{
  debug := true
  debug := false
  Result := []   ;new MatchCollection()
  start := 1

  ;https://www.autohotkey.com/docs/commands/RegExMatch.htm
  Needle := "O)" . Needle

  ;debug_print_kv(debug, "finding Haystack", Haystack )
  debug_print_kv(debug, "finding needle", needle )

  loop
  {
    if(!RegexMatch(haystack, needle, M, start)){
        ;printd("stopped RegexMatch")
        break
    }

    debug_print_kv(debug, "found from regex:", M.value)
    Result.Insert(M.value)
    start := M.Pos + M.Len
  }

  return Result
}

;To use: 
; for i,m in RxMatches(needle, haystack)   ; i is 1..n, m is a Match object
;     i, m.Value, m.Pos, m.Len, m[1], m["groupName"]
;  
; ret := RxMatches(needle, haystack)
; for i, m in ret 
;     printd(i, m)


; query youtube and return an array with all the anwers
get_all_youtube_results_as_array( query, limit := 5 )
{
  debug := false

  ret := Array()
  text := query_youtube_as_html(query)

  ; printd(text)
  
  ret := RxMatches(text, "/watch\?v=.{11}" )
  ret := array_remove_duplicates(ret)  
  ret := array_limit(ret, limit)  
  ret := array_prepend_string_to_entries(ret, "https://www.youtube.com" )
  
  debug_print_array(debug, "returned from youtube", ret)
 
	return ret
}




init_beep(){
  SoundBeep, 3000, 100

}

beep(){
  SoundBeep, 5000, 100

}

debug_beep(){
  ; SoundBeep, 7000, 100
  
}





get_active_window_id(){
  WinGet, current_ID, ID, A
  return current_ID
}

set_active_window_id(new_id){
  WinActivate, ahk_id %new_id%
}



; get the current window's handle
remember_previous_state()
{
  global previous_state_window_ID
  global previous_state_mouse_x
  global previous_state_mouse_y

  previous_state_window_ID := get_active_window_id()
  
  CoordMode, Mouse, screen
  MouseGetPos, previous_state_mouse_x, previous_state_mouse_y
}


; activate the previous window
return_to_previous_state(){


  global previous_state_window_ID
  global previous_state_mouse_x
  global previous_state_mouse_y

  set_active_window_id(previous_state_window_ID)

  CoordMode, Mouse, screen
  mouse_move(previous_state_mouse_x, previous_state_mouse_y)
  beep()

}
  

find_in_explorer( query ){
	remember_previous_state()
  
  if WinExist("ahk_class ExploreWClass") or WinExist("ahk_class CabinetWClass")
     WinActivate
  else
     Send, #e
     Sleep, 400
       
  sleep, 50
  
  Send, ^1
  Sleep, 50 

  ; Send, ^f  ;broken at windows 1909
  
  Send, ^e  ; new for windows 1909
  Sleep, 50
  
  send, ^a
  sleep, 50
  
  SendInput, %query%
  sleep, 150
  
  SendInput, {enter}
  sleep, 100
  
  return_to_previous_state()
}


set_clipboard(text){
  clipboard = %text%
  ClipWait      ; Wait for the clipboard to contain text.
  return 
}

copy_selection_to_clipboard(normalize := True){
  ; see also: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63356&start=20#p271551

  clipboard =   ; Start off empty to allow ClipWait to detect when the text has arrived.
  Send ^c
  ClipWait, 0      ; Wait for the clipboard to contain text.
  
  ;if ErrorLevel
  ;{
  ;    MsgBox, The attempt to copy text onto the clipboard failed.
  ;    ;  in this case always test query == ""
  ;    return
  ;}

  ; MsgBox, "CTRL-C copied this to the clipboard:`n`n" %clipboard% 

  if(normalize){
    clipboard := normalize_query(clipboard)
  }
  
  return clipboard
}

slow_send(what)
{
  send % what
  sleep, 25
}


get_chrome_url(){
  Clipboard = ; empty clipboard
  
  slow_send("^l")        ;gives focus to the URL
  slow_send("^c")        
  ClipWait,0
  url := Clipboard
    
  return url
}


XY_analyse_init(){
  global analyse_XY_coord
  
  beep()
  
  if(analyse_XY_coord == "window"){
    analyse_XY_coord := "none"
    SetTimer, XY_analyse_timer, OFF
    ToolTip, 
    return
  } else if(analyse_XY_coord == "screen"){
    analyse_XY_coord := "window"
  } else {
    analyse_XY_coord := "screen"
  }
   
  SetTimer, XY_analyse_timer, 100
}


XY_analyse_timer(){
  global analyse_XY_coord
  
  CoordMode, ToolTip, %analyse_XY_coord%
  CoordMode, Pixel, %analyse_XY_coord%
  CoordMode, Mouse, %analyse_XY_coord%
  CoordMode, Caret, %analyse_XY_coord%
  CoordMode, Menu, %analyse_XY_coord%

  MouseGetPos, xpos, ypos 
  ToolTip, xpos: %xpos%`nypos: %ypos%`ntype: %A_CoordModeMouse%
}



exe_activate(exe){
  beep()
  query := "ahk_exe " + exe
  
  ; WinExist("ahk_exe SoulseekQt.exe")
  WinActivate, %query%
  
  ; msgbox, %query%
  sleep,  200
}


slsk_activate(){
  if not WinExist("ahk_exe SoulseekQt.exe"){
   MsgBox, Soulseek window not present
   return
  } 
  
  WinExist("ahk_exe SoulseekQt.exe")
  WinActivate
  Sleep, 200
  
  return get_active_window_id()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


print1( var )
{
  st := "|" . var . "|"
  
  msgbox, %st%
}

print2( sep, surround, values )
{
  #sep := " "
  st := ""
  
  for index, value in values {
    if(len(value) == 0 ){
      value := "<EMPTY>"
    }
    st .= sep . value . sep
  }
    
  if(surround){
    st := sep . st . sep  
  }
  
  msgbox, %st%
}

print( values* )
{
  print2( " ", False, values )
}

printd( values* )
{
  print2( "|", True, values )
}




debug_print( debug, var* )
{
  global_do_debug := True
  ; global_do_debug := False
  
  if(global_do_debug){
    if(debug){
      printd(var)
    }  
  }
}
 
 
 
debug_print_kv(debug, key, value){
  if(len(value) == 0 ){
    value := "<empty>"
  }
 
  global_do_debug := True
  ; global_do_debug := False
  
  if(global_do_debug){
    if(debug){
      msgbox, %key% = |%value%|
      msgbox, %key% = |%value%|
    }
  }
}


debug_print_array(debug, name, array, show_elements := false)
{
  if(debug){
    print_array(name, array, show_elements)
  
  }
}


print_array(name, array, show_elements := true)
{
  debug := true

  debug_print(debug, "Array '" . name . "' elements: " . array.count() )
  
  if(!show_elements)
    return
    
  for index, element in array
  {
      debug_print(debug, "Element " . index . " is |" . element . "|")
  }
}



mouse_move(win_x, win_y)
{
  ;velocity := 10
  velocity := 0
  
  MouseMove, %win_x%, %win_y%, %velocity%
  sleep 50
}


mouse_click(win_x, win_y)
{
  mouse_move(win_x, win_y)
  click
  sleep 200
}


do_soulseek_one_query(query)
{
  set_clipboard(query)
  
  CoordMode, Mouse, window
  if(!slsk_activate()){
    return
  }
  
  ;return
  
  WinGetPos, , , slsk_width, slsk_height
  
  ; focus on "search" tab
  mouse_click(264, 83)
  
  ; focus on "search" box
  mouse_click(94, 156)
  
  Send, ^a
  sleep 100  
  Send, ^v 

  ; click "search" button
  mouse_click(slsk_width - 246, 158)
}




; Find correct bash.exe file
get_bash_exe()
{
  bash_exe = %A_WinDir%\sysnative\bash.exe
  if (!FileExist(bash_exe)) {
      bash_exe = %A_WinDir%\system32\bash.exe
  } if (!FileExist(bash_exe)) {
      MsgBox, 0x10, , WSL(Windows Subsystem for Linux) must be installed.
      ExitApp, 1
  }
  return bash_exe
}



do_open_search_engine(what := "google")
{
	debug_beep()
  query := copy_selection_to_clipboard()
  if(query == "")
    return
  
  open_search_engine( query , what)
  return
}  


do_open_google()
{
  do_open_search_engine("google")

}

do_open_discogs()
{
  do_open_search_engine("discogs")

}


do_find_explorer(){
	debug_beep()
  query := copy_selection_to_clipboard()
  if(query == "")
    return
    
  find_in_explorer(query)
}
  

do_get_chrome_tab_url()
{
  debug_beep()
  
  url := get_chrome_url()
  if(url == "")
    return
  
  ; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
  ; debug_print("bash found at: " %bash_exe% )
  ; Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
  ; Run, "%bash_exe%" -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause' 
  ; ShellRun("C:\vim\vim80\gvim.exe", "+SLoad", "", "", 3)
  ; run, bash.exe -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause
  ;run, C:\windows\system32\bash.exe    ;  -c 'echo ola '
}  


is_chrome_active()
{
  ret := WinActive("ahk_class MozillaWindowClass") 
    or WinActive("ahk_class Chrome_WidgetWin_0")
    or winactive("ahk_class Chrome_WidgetWin_1")
  
  return ret
}  
  
  
array_to_ml(Array, sep="`n")
{
  ret := ""
  For k, v In Array
  {
    ret .= v . sep
  
  } 
  
  return ret
}  
  
  
array_to_ml_space(Array, sep=" ")
{
  return array_to_ml(Array, sep)

}


 
duplicate_string(st, count=2)
{
  ret := 
  
  ;debug(count)
  
  Loop, %count%
  {
    ;debug(ret)
    ret .= ret . st
  }  
  
  ;debug(ret)
  return ret
}


array_to_ml_spaced(Array, seperator_lines=3)
{
  sep := duplicate_string("`n", seperator_lines)
  
  ;debug(sep)
  return array_to_ml(Array, sep)
}  
  
  
do_get_all_chrome_tab_url()
{
  beep()
  
  if(not is_chrome_active())
    return
  
  ClipSave := Clipboard
  Clipboard = ; empty clipboard
  url_list := []
  
  first_url := ""
  count := 1
  url := ""
  
  
  Loop
  {
    if(A_Index > 30){
      break
    }
    
    url := get_chrome_url()
 
    if (url == first_url){
        break
     }
     if A_Index = 1
        first_url := url
        
    url_list.push(url)
    Send, ^{tab}

    ; count := count + 1    
  }
  
  ; Clipboard := ClipSave
  ; MsgBox % array_to_ml(url_list)
  Clipboard := array_to_ml_spaced(url_list)
  
  beep()  
}

 
  

  
do_search_youtube_list(){
	debug_beep()
  
  query := copy_selection_to_clipboard()
  if(query == "")
    return

  all_youtube_results(query)
}
  
   
  
do_open_several_urls(array)
{  
  ;#/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe
  chrome_exe := "c:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

  if(array.count()){
  
    urls := array_to_ml_space(array)
    
    to_exec := chrome_exe . " " . urls
    
    run % to_exec
  }
}


copy_selection_to_array()
{
  ret := Array()
  
  query := copy_selection_to_clipboard()
  if(query == "")
    return ret
    
    
  query := normalize_query( query )
  
  Loop, Parse, query, `n, `r
  {
		index := A_Index
    line := A_LoopField
    
    line := strip(line)
    
    if(len(line)){
      ret.Push(line)
    }
  }
  
  return ret
}


return_to_previous_state_if_single(array)
{
  if(array.count() <= 1){
    return_to_previous_state()
  } else {
    beep()
  }
}  
  
  
do_search_youtube_first_hit()
{
	debug_beep()
  debug := True
  debug := False
  
  
  query := copy_selection_to_array()
  if(!query.count())
    return
    
  debug_print_array(debug, "query", query)
  remember_previous_state()
  results := Array()

  for index, line in query
  {
      url := first_youtube_result( line )
      results.Push(url)
  }    

  debug_print_array(debug, "results", results)
  return_to_previous_state_if_single(results)
    
  do_open_several_urls(results)  
}



do_soulseek()
{
	debug_beep()
  debug := True
  debug := False
    
  query := copy_selection_to_array()
  if(!query.count())
    return
    
  debug_print_array(debug, "query", query)
  remember_previous_state()
  
  for index, line in query
  {
      do_soulseek_one_query(line)
  }    
  
  return_to_previous_state_if_single(results)
}


do_collect_all_youtube_results_to_clipboard()
{
  debug_beep()
  debug := True
  debug := False
  
  query := copy_selection_to_array()
  if(!query.count())
    return
    
  debug_print_array(debug, "query", query)
  remember_previous_state()
  results := Array()

  for index, line in query
  {
      ret := get_all_youtube_results_as_array( line )
      array_concat(results, ret)
  }    

  
  debug_print_array(debug, "results", results)
  return_to_previous_state_if_single(results)
    
  array_to_clipboard(results)
}


array_append_string_to_entries(array, st)
{ 
  ret := array()
  
  for index, value in array {
    new_st := value . st 
    ret.push( new_st )

  }
  return ret
}


array_prepend_string_to_entries(array, st)
{ 
  ; print_array("prepend", sarray)
  ret := array()

  
  for index, value in array {
    new_st := st . value 
    ret.push( new_st )
    
    ;print(new_st)
  }
  return ret
}


array_remove_duplicates(arr) 
{ 
  ; Leaves the original intact, only loops once, preserves order:


    hash := {}, newArr := []

    for e, v in arr
        if (!hash.Haskey(v))
            hash[(v)] := 1, newArr.push(v)

    return newArr
}


array_concat(array1, array2)
{
  for index, value in array2
  {
    array1.push(value)
  }
  
  return array1
}


array_to_clipboard(array)
{
  st := array_to_ml(array)
  set_clipboard(st)
}


array_limit(array, top := 5)
{
  count := 0
  ret := Array()
  
  for index, value in array
  {
    count += 1
    if(count > top)
      break
      
    ret.push(value)  
  }
  
  return ret
}


;; options to launching WSL commands in windows

;  https://stackoverflow.com/questions/41225711/wsl-run-linux-from-windows-without-spawning-a-cmd-window

;https://devblogs.microsoft.com/commandline/a-guide-to-invoking-wsl/ 

; bash_exe =  %A_WinDir%\sysnative\bash.exe
; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
; debug_print("bash found at: " %bash_exe% )
; Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
; Run, "%bash_exe%" -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause' 
; ShellRun("C:\vim\vim80\gvim.exe", "+SLoad", "", "", 3)
; run, bash.exe -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause
;run, C:\windows\system32\bash.exe    ;  -c 'echo ola '


;;;
;;;  AutoExec Actions
;;;

#SingleInstance force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, window
bash_exe := get_bash_exe()
debug_XY_coord := "none"

diacritic_current := 1
diacritic_cycling := 1
diacritic_enabled := 0

window_move_enabled :=0
window_move_enabled :=1
  
GoSub, tim_WM_DISPLAYCHANGE       ; get monitor dimensions
   
init_beep()              ; Signal that we finished autoexec section


wc_sub_MouseHotkey:
   If A_ThisHotkey contains MButton,LButton,RButton,XButton1,XButton2
   {
      MouseGetPos,,,wc_MouseID
      IfWinNotactive, ahk_id %wc_MouseID%
      {
         WinActivate, ahk_id %wc_MouseID%
         WinWaitActive, ahk_id %wc_MouseID%
      }
   }
Return






tim_WM_DISPLAYCHANGE:
   ; Anzahl der Monitore und Arbeitsfläche ermitteln
   SysGet, NumOfMonitors, 80
   SysGet, WorkArea, MonitorWorkArea

   ; Maße vom Standardmonitor
   SysGet, Monitor, Monitor
   MonitorHeight := MonitorBottom-MonitorTop
   MonitorWidth := MonitorRight-MonitorLeft

   
   SysGet, WorkAreaPrimary, MonitorWorkArea
   WorkAreaPrimaryWidth := WorkAreaPrimaryRight - WorkAreaPrimaryLeft
   WorkAreaPrimaryHeight := WorkAreaPrimaryBottom - WorkAreaPrimaryTop

   If NumOfMonitors < 1
      NumOfMonitors = 1

      
   Loop, %NumOfMonitors%
   {
      SysGet, tempArea, MonitorWorkArea, %A_Index%
      SysGet, WorkArea%A_Index%, MonitorWorkArea, %A_Index%
      SysGet, Monitor%A_Index%, Monitor, %A_Index%
      WorkArea%A_Index%Width := WorkArea%A_Index%Right - WorkArea%A_Index%Left
      
      WorkArea%A_Index%Height := WorkArea%A_Index%Bottom - WorkArea%A_Index%Top
      Monitor%A_Index%Width := Monitor%A_Index%Right - Monitor%A_Index%Left
      Monitor%A_Index%Height := Monitor%A_Index%Bottom - Monitor%A_Index%Top

      If tempAreaLeft < %WorkAreaLeft%
         WorkAreaLeft := tempAreaLeft
      If tempAreaRight > %WorkAreaRight%
         WorkAreaRight := tempAreaRight
      If tempAreaTop < %WorkAreaTop%
         WorkAreaTop := tempAreaTop
      If tempAreaBottom > %WorkAreaBottom%
         WorkAreaBottom := tempAreaBottom

   }

   WorkAreaWidth  := WorkAreaRight-WorkAreaLeft
   WorkAreaHeight := WorkAreaBottom-WorkAreaTop
   SysGet, MonitorAreaWidth, 78
   SysGet, MonitorAreaHeight, 79
   SysGet, MonitorAreaLeft, 76
   SysGet, MonitorAreaTop, 77
   If MonitorAreaWidth = 0 ; Win95/NT
   {
      MonitorAreaWidth := MonitorWidth
      MonitorAreaHeight := MonitorHeight
      MonitorAreaLeft := MonitorLeft
      MonitorAreaTop := MonitorTop
   }
   MonitorAreaBottom := MonitorAreaTop+MonitorAreaHeight
   MonitorAreaRight := MonitorAreaLeft+MonitorAreaWidth

   SysGet, BorderHeight, 32 ;7
   SysGet, SM_CXBORDER, 5
   BorderHeightToolWindow := BorderHeight-SM_CXBORDER
   SysGet, CaptionHeight, 4
   SysGet, MenuBarHeight, 15
   SysGet, SmallCaptionHeight, 51
   SysGet, ScrollBarVWeight, 9
   SysGet, ScrollBarHWeight, 10

   If ((WorkAreaWidth <> LastWorkAreaWidth OR WorkAreaHeight <> LastWorkAreaHeight) AND LastWorkAreaHeight <> "")
   {
      ;printd("STATUS", A_LineNumber, A_LineFile, "Display settings changed ...")
      Loop
      {
         If Extension[%A_Index%] =
            break
         Function := Extension[%A_Index%]
         ;;If ( IsLabel("DisplayChange_" Function) )
            ;;  Gosub, DisplayChange_%Function%
      }
   }

   LastWorkAreaWidth = %WorkAreaWidth%
   LastWorkAreaHeight = %WorkAreaHeight%
   LastMonitorAreaWidth = %MonitorAreaWidth%
   LastMonitorAreaHeight = %MonitorAreaHeight%

   ; ac'tivAid automatisch deaktiveren, wenn der Installer sichtbar ist.
   DetectHiddenWindows, On
   If (WinActive("License - ac'tivAid v") OR WinActive("Lizenzbestimmungen - ac'tivAid v") OR WinActive("ac'tivAid v","Installationsfortschritt") OR WinActive("ac'tivAid v","Installation progress") OR WinExist("##### NEXTBUILD.ahk"))
   {
      DetectHiddenWindows, Off
      If A_IsSuspended = 0
      {
         ;;Gosub, sub_MenuSuspend
         InstallerVisible = 1
      }
   }
   Else If InstallerVisible = 1
   {
      DetectHiddenWindows, Off
      InstallerVisible =
      ;; Gosub, sub_MenuSuspend
   }
   
Return


StatisticsToClipboard:
   WinGetText, AllStatistics, A
   ExtendedStatistics := "Statistics:`r`n---------------------------------------------------------------------"
   Loop, Parse, AllStatistics, `n, `r
   {
      If (A_Index = 1 OR A_LoopField = lng_StatisticsToClipboard)
         continue
      ;If (func_StrRight(A_LoopField,1) = ":")
      ;   ExtendedStatistics .= "`r`n" A_LoopField
      ;Else
      ;   ExtendedStatistics .= "`t" A_LoopField
   }
   ExtendedStatistics .= "`r`n---------------------------------------------------------------------`r`n"
   ExtendedStatistics .= "`r`nScreenareas:`r`n---------------------------------------------------------------------"

   ExtendedStatistics .= "`r`nMonitor:`t" MonitorLeft ", " MonitorTop ", " MonitorRight ", " MonitorBottom " = " MonitorWidth " x " MonitorHeight
   ExtendedStatistics .= "`r`nMonitorArea:`t" MonitorAreaLeft ", " MonitorAreaTop ", " MonitorAreaRight ", " MonitorAreaBottom " = " MonitorAreaWidth " x " MonitorAreaHeight
   ExtendedStatistics .= "`r`nWorkArea:`t" WorkAreaLeft ", " WorkAreaTop ", " WorkAreaRight ", " WorkAreaBottom " = " WorkAreaWidth " x " WorkAreaHeight

   Loop, %NumOfMonitors%
   {
      ExtendedStatistics .= "`r`n`r`nMonitor" A_Index ":`t" Monitor%A_Index%Left ", " Monitor%A_Index%Top ", " Monitor%A_Index%Right ", " Monitor%A_Index%Bottom " = " Monitor%A_Index%Width " x " Monitor%A_Index%Height
      ExtendedStatistics .= "`r`nWorkArea" A_Index ":`t" WorkArea%A_Index%Left ", " WorkArea%A_Index%Top ", " WorkArea%A_Index%Right ", " WorkArea%A_Index%Bottom " = " WorkArea%A_Index%Width " x " WorkArea%A_Index%Height
   }

   ExtendedStatistics .= "`r`n`r`nBorderHeight:`t" BorderHeight
   ExtendedStatistics .= "`r`nBorderHeightToolWindow:`t" BorderHeightToolWindow
   ExtendedStatistics .= "`r`nCaptionHeight:`t" CaptionHeight
   ExtendedStatistics .= "`r`nSmallCaptionHeight:`t" SmallCaptionHeight
   ExtendedStatistics .= "`r`nMenuBarHeight:`t" MenuBarHeight
   ExtendedStatistics .= "`r`nScrollBarHWeight:`t" ScrollBarHWeight
   ExtendedStatistics .= "`r`nScrollBarVWeight:`t" ScrollBarVWeight

   Loop
   {
      actExtension := Extension[%A_Index%]
      If actExtension =
         Break

      ExtendedStatistics .= "`r`n---------------------------------------------------------------------`r`n"
      ExtendedStatistics .= "`r`n" actExtension ":`r`n---------------------------------------------------------------------"
      ExtendedStatistics .= "`r`nEnable_" actExtension ":`t" Enable_%actExtension%
      ExtendedStatistics .= "`r`nExtensionVersion:`t" ExtensionVersion[%actExtension%]
      ExtendedStatistics .= "`r`nExtensionPrefix:`t" ExtensionPrefix[%actExtension%]
      ExtendedStatistics .= "`r`nExtensionMenuName:`t" ExtensionMenuName[%actExtension%]
      ExtendedStatistics .= "`r`nExtensionHideSettings:`t" ExtensionHideSettings[%actExtension%]
      ExtendedStatistics .= "`r`nExtension:`t" Extension[%actExtension%]
      ExtendedStatistics .= "`r`nExtensionLoadingTime:`t" ExtensionLoadingTime[%actExtension%] " ms"
      ExtendedStatistics .= "`r`nExtensionGuiTime:`t" ExtensionGuiTime[%actExtension%] " ms"
      ExtendedStatistics .= "`r`nEnableTray_" actExtension ":`t" EnableTray_%actExtension%
      ExtendedStatistics .= "`r`n"

      If (IsLabel( "Statistics_" actExtension ))
         Gosub, Statistics_%actExtension%
   }

   Clipboard = %ExtendedStatistics%
   AllStatistics =
   ; Gosub, StatisticsGuiClose
Return


  


;;;
;;; To change shortcuts: 
;;;   https://www.autohotkey.com/docs/Hotkeys.htm
;;;   https://www.autohotkey.com/docs/KeyList.htm
;;;
;;; #	Win
;;; !	Alt
;;; ^	Control
;;; +	Shift
;;;




^#!esc:: exitapp
^#!F11:: XY_analyse_init()
^#!F12:: reload

;; temporary for testing
#s:: reload

^F8::   do_open_discogs()
^!F8::   do_open_google()

^F9::   do_find_explorer()
^F10::  do_soulseek()  
;^F11::  do_search_youtube_list()
^F11:: do_collect_all_youtube_results_to_clipboard()
^F12::  do_search_youtube_first_hit()
	  
^!F11:: do_get_all_chrome_tab_url()
^!F12:: do_get_chrome_tab_url()


;;;;;

^#!a:: diacritic_toggle()

#if diacritic_enabled
^a::  diacritic_do_operation("a", False)
^+a:: diacritic_do_operation("a", True)

^e::  diacritic_do_operation("e", False)
^+e:: diacritic_do_operation("e", True)

^o::  diacritic_do_operation("o", False)
^+o:: diacritic_do_operation("o", True)

^i::  diacritic_do_operation("i", False)
^+i:: diacritic_do_operation("i", True)

^u::  diacritic_do_operation("u", False)
^+u:: diacritic_do_operation("u", True)
#if 


#if window_move_enabled
; Activaid shortcuts
#Left::   do_enlarge("left")
#Right::  do_enlarge("right")
#Up::  do_enlarge("up")
#Down::  do_enlarge("down")

;#!Left::   do_enlarge("alt_left")
;#!Right::  do_enlarge("alt_right")
;#!Up::  do_enlarge("alt_up")
;#!Down::  do_enlarge("alt_down")


#if 




