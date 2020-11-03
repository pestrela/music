;
; AutoHotKey file for DJs
; Created by DJ Estrela, 2019
;
; Please see the complete list of shortcuts at the very bottom of this file

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
; AHK Quoting Guide:
;   commands:
;     variables need "%"
;     strings NOT quoted
;     = (assignment)
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
; Ideas:
;     https://superuser.com/questions/1203029/wsl-trailing-whitespaces-being-added-to-bash-code-pasted-into-cmd-wsl-tty-per
;    
;     "cant live" little programs:  https://www.neogaf.com/threads/some-of-my-cant-live-without-progams-what-are-yours.1482889/
;     Clipboard History Lite - 10 clipboard with caps lock
;     Everything for windows file search
;     Link Clump - Chrome Extension - Open Multiple Links with "Z" key
;    
;     Puretext - Strips formatting when pasting.
;     ShareX - Screenshot tool (very comprehensive )
;     Directory Opus - File Manager
;     Directory Report - find wasted space, duplicates, etc
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  Print functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print( values* )
{
  print2( " ", False, values* )
}

error( values* )
{
  print("Error:", values*)

}

warning( values* )
{
  print("Warning:", values*)
  

}

die( values* )
{
  error( values* )
  ; raise exception ?
}



printd( values* )
{
  print2( "|", True, values* )
}

pause( )
{
  print("Press enter to continue")
}



print1( var )
{
  st := "<" . var . ">"
  
  msgbox, %st%
}

print2( sep, surround := False , values* )
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



debug_print( debug, var* )
{
  global_do_debug := True
  ; global_do_debug := False
  
  if(global_do_debug){
    if(debug){
      printd(var*)
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

  count := array.count()
  if(count == ""){
    count := 0   ; needed ??
  
  }
  
  print("Array '" . name . "' has " . count . " elements")
  
  if(!show_elements)
    return
    
  for index, element in array
  {
      print("Element " . index . ":  <" . element . ">")
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ahk_reload()
{
  ; warning("Going to reload AHK script")
  reload
  
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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



Monitor(x,y, w, h)
{
  mon := Object()
  
 ; more info: https://github.com/pacobyte/AutoHotkey-Lib-WinGetPosEx/blob/master/WinGetPosEx.ahk
  margin := 8
  
  ;x := x - margin
  ;y := y - margin
  ;w := w - margin * 1
  ;h := h - margin * 1
  
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


mon_2_st(mon)
{
  st := ""

  st .= " Monitor(" . mon.x0 
  ;st .= " " . mon.x2 
  st .= " " . mon.x4
  
  st .= ", " . mon.y0  
  ;st .= " " . mon.y2 
  st .= " " . mon.y4  . ") "
  
  return st
}
     
     
print_mon(mon)
{

  print( mon_2_st(mon))
}

get_monitor()
{
  return "TBD"
}

     
;;;;;;;;;;
;;;;;;;;;; LOCATIONS definitions
;;;;;;;;;;



Location(x, y, w, h, max)
{
  loc := {}
  
  x := x 
  
  loc.x := x
  loc.y := y
  loc.w := w
  loc.h := h

  loc.max := max 
  
  return loc
}


loc_2_st(loc)
{
  st := ""
  
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


print_loc(loc)
{

  print( loc_2_st(loc))
}



get_location()
{
  WinGetPos, x, y, w, h, A    
  WinGet, wc_Max, MinMax, A                        ; are we maximized?   https://www.autohotkey.com/docs/commands/WinGet.htm#MinMax
 
  ;print1(wc_X)
  
  x := x + 7
  
  loc := Location(x, y, w, h, wc_Max)
  return loc
}


loc_is_equal(l1, l2)
{
  return l1.x == l2.x and l1.y == l2.y and l1.w == l2.w and l1.h == l2.h 

}

 
;;;;;;;;;;
;;;;;;;;;; CASES definitions
;;;;;;;;;;

 
case_2_loc(mon, case)
{
 
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



loc_equal_case(loc, mon, case)
{
  new_loc := case_2_loc(mon, case)
  
  return loc_is_equal(loc, new_loc)
}


loc_2_case(loc, mon)
{
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
;;;;;;;;;;;;;;
;;;;;;;;;;;;;;
 
 
WinGetPosEx(hWindow,ByRef X="",ByRef Y="",ByRef Width="",ByRef Height=""
			,ByRef Offset_Left="",ByRef Offset_Top=""
			,ByRef Offset_Right="",ByRef Offset_Bottom="")
{
  ; Source:  https://github.com/pacobyte/AutoHotkey-Lib-WinGetPosEx/blob/master/WinGetPosEx.ahk
  ; Original author: jballi (https://autohotkey.com/boards/viewtopic.php?t=3392)
  ; Update author: RiseUp

    Static Dummy5693
          ,RECTPlus
          ,S_OK:=0x0
          ,DWMWA_EXTENDED_FRAME_BOUNDS:=9

    ;-- Workaround for AutoHotkey Basic
    PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

    ;-- Get the window's dimensions
    ;   Note: Only the first 16 bytes of the RECTPlus structure are used by the
    ;   DwmGetWindowAttribute and GetWindowRect functions.
    VarSetCapacity(RECTPlus,32,0)
    DWMRC:=DllCall("dwmapi\DwmGetWindowAttribute"
        ,PtrType,hWindow                                ;-- hwnd
        ,"UInt",DWMWA_EXTENDED_FRAME_BOUNDS             ;-- dwAttribute
        ,PtrType,&RECTPlus                              ;-- pvAttribute
        ,"UInt",16)                                     ;-- cbAttribute

    if (DWMRC<>S_OK)
        {
        if ErrorLevel in -3,-4  ;-- Dll or function not found (older than Vista)
            {
            ;-- Do nothing else (for now)
            }
         else
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unknown error calling "dwmapi\DwmGetWindowAttribute".
                RC=%DWMRC%,
                ErrorLevel=%ErrorLevel%,
                A_LastError=%A_LastError%.
                "GetWindowRect" used instead.
               )

        ;-- Collect the position and size from "GetWindowRect"
        DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECTPlus)
        }

    ;-- Populate the output variables
    X:=Left       := NumGet(RECTPlus,0,"Int")
    Y:=Top        := NumGet(RECTPlus,4,"Int")
    Right         := NumGet(RECTPlus,8,"Int")
    Bottom        := NumGet(RECTPlus,12,"Int")
    Width         := Right-Left
    Height        := Bottom-Top
    Offset_Left   := 0
    Offset_Top    := 0
    Offset_Right  := 0
    Offset_Bottom := 0

    ;-- If DWM is not used (older than Vista or DWM not enabled), we're done
    if (DWMRC<>S_OK)
        Return &RECTPlus

    ;-- Collect dimensions via GetWindowRect
    VarSetCapacity(RECT,16,0)
    DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECT)
	GWR_Left   := NumGet(RECT,0,"Int")
	GWR_Top    := NumGet(RECT,4,"Int")
	GWR_Right  := NumGet(RECT,8,"Int")
	GWR_Bottom := NumGet(RECT,12,"Int")
	
	;-- Calculate offsets and update output variables
	NumPut(Offset_Left   := Left       - GWR_Left,RECTPlus,16,"Int")
	NumPut(Offset_Top    := Top        - GWR_Top ,RECTPlus,20,"Int")
	NumPut(Offset_Right  := GWR_Right  - Right   ,RECTPlus,24,"Int")
	NumPut(Offset_Bottom := GWR_Bottom - Bottom  ,RECTPlus,28,"Int")
	
    Return &RECTPlus
}
    
 
 
ResizeWin_dwm(Left = 0, Top = 0, Width = 0, Height = 0)
{
    ; Source: https://www.damirscorner.com/blog/posts/20200522-PositioningWithAutoHotkey.html

    ; restore the  window first because maximized window can't be moved
    WinRestore,A

    ; get the active window handle for the WinGetPosEx call
    WinGet,Handle,ID,A

    ; get the offsets
    WinGetPosEx(Handle,X,Y,W,H,Offset_Left,Offset_Top,Offset_Right,Offset_Bottom)

    If %Width% = 0
        Width := W

    If %Height% = 0
        Height := H

    ; adjust the position using the offsets
    Left -= Offset_Left
    Top -= Offset_Top
    Width += Offset_Left + Offset_Right
    Height += Offset_Top + Offset_Bottom

    ; finally position the window
    WinMove,A,,%Left%,%Top%,%Width%,%Height%
} 
 
 
move_window(loc)
{

  debug := False
  ; debug := True
  
  if(debug){
    prev_loc := get_location()
    print_loc(loc)
  }
  
  x := loc.x
  y := loc.y
  w := loc.w
  h := loc.h
  
  x := x - 7 ;- 4
 
  ; pestrela: trying DWM-fixed version
  WinMove, A,, %x%,  %y%, %w%, %h%
  ; ResizeWin_dwm(x,y,w,h)
  
  debug_moved_window := False
  
  if(debug_moved_window){
    sleep, 50
    actual_loc := get_location()
  
    ;print("moved to", loc_2_st(loc),  "previous: ", loc_2_st(prev_loc), "actual:" , loc_2_st(actual_loc) )
  } 
}
     

get_translation_table(which_side)
{
  ;return get_translation_table_1(which_side)
  return get_translation_table_2(which_side)

}

 
      
     
;;;;;;;;;;;
get_translation_table_2(which_side)
{

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
    
    ;;; Corners
    t["tl1"] := "tl1"
    t["tl2"] := "tl1"
    t["tl3"] := "tl2"

    t["t"]  := "tl3"
    
    t["tr1"] := "t" 
    t["tr2"] := "tr1" 
    t["tr3"] := "tr2" 

    t["bl1"] := "bl1"
    t["bl2"] := "bl1"
    t["bl3"] := "bl2"
    
    t["b"]  := "bl3"
    
    t["br1"] := "b" 
    t["br2"] := "br1" 
    t["br3"] := "br2" 
    
  } 
     
  
  if(which_side == "right"){
    t["fmax"] := "r2"
    t["max"] := "r2"
    t["min"] := "r2"
    t["rr"] := "r2"
    
    ;;; Half-screen
    t["l1"] := "r2"
    t["l2"] := "r2"
    t["l3"] := "r2"
    
    t["r1"] := "r3" 
    t["r2"] := "r1" 
    t["r3"] := "r2"
    
    
    
    ;;; Corners
    t["tl1"] := "tl2"
    t["tl2"] := "tl3"
    t["tl3"] := "t"
    
    t["t"]  := "tr1"

    t["tr1"] := "tr2" 
    t["tr2"] := "tr3" 
    t["tr3"] := "tr3" 

    t["bl1"] := "bl2"
    t["bl2"] := "bl3"
    t["bl3"] := "b"
    
    t["b"]  := "br1"
    
    t["br1"] := "br2" 
    t["br2"] := "br3" 
    t["br3"] := "br3"     
  } 
    
  ;;;;;;;;;;;;;;;;;  
  
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
    t["tl1"] := "t"
    t["tl2"] := "t"
    t["tl3"] := "t"

    t["tr1"] := "t"
    t["tr2"] := "t"
    t["tr3"] := "t"


    t["bl1"] := "l1"
    t["bl2"] := "l2"
    t["bl3"] := "l3"

    t["br1"] := "r1"
    t["br2"] := "r3"
    t["br3"] := "r3"
    
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
    
    t["tr1"] := "r1"
    t["tr2"] := "r2"
    t["tr3"] := "r3"
    
    t["tl1"] := "l1"
    t["tl2"] := "l2"
    t["tl3"] := "l3"      
  }
  
  return t
}  
     

do_windows_enlarge(which_side)
{
  ;beep()
  
  
  mon := tim_WM_DISPLAYCHANGE()
  wc_sub_MouseHotkey()

  
  ; unknonw variables
  wc_ResizeFixedWindows := 0
  cr_Resizeable := 0
  
  
  WinGet, wc_Style, Style, A
  If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows == 0) AND cr_Resizeable <> 1)
    Return
 
  ;mon := func_GetMonitorNumber("A")

  ; get ID, current dimensions, position and maximize status
  ;WinGet, wc_WindowID, ID, A                       ; This is used for the return to last known positon. Not used at the moment

  ;;;;;;;;;;;;
  ;mon := Monitor(WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)

  
  
  debug := False
  ;debug := True

  
  ;;;;;;;;;; new code below
  loc := get_location()  
  cur_case := loc_2_case(loc, mon)

  ;print("current case:", cur_case)
  
  debug := False
  ;debug := True
  
  debug_tmp := true
  debug_tmp := false
  
  if(debug or debug_tmp){
    print_loc(loc)
    print_mon(mon)
  }
  
  ; We always leave maximized state
  if(cur_case == "max"){
     WinRestore, A

  }
  
  t := get_translation_table(which_side)
    
  new_case := t[cur_case]
  if(new_case == ""){
    print("AHK: unknown transform", cur_case, which_side)
    new_case = "error"
    return
  }
  
  ;print(cur_case, "->", new_case)

  new_loc := case_2_loc(mon, new_case)
  
  ;debug := True
  if(debug){
    print("Transform:", cur_case, "=>", new_case, "    ", loc_2_st(new_loc))
  }
  
  move_window(new_loc)
  
}


;
; resolution: 
;  1920, 1080
;
; location:   (maximized)
;   -8,-8, 1936, 1056 
;
; location: moved to the right
;   1913
;
; monitor:  
;   0, 0, 1920, 1040
;


test_arrays()
{

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


test_objects(x,y)
{
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
   global NumOfMonitors

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
  
  
diacritic_get_char(letter, shift, count)
{
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
normalize_query( query , remove_digits := true )
{
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
url_prepare_query( query )
{
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
first_youtube_result( query , what )
{
  if(what == "show_entries"){
    text := query_youtube_as_html(query)

    if RegExMatch( text, "/watch\?v=.{11}", match ){
      url := "https://www.youtube.com" match
    } else {
      url := ""
    }  
    
  } else if(what == "show_search_page" ){
    url := gen_youtube_url(query)
    
  } else {
    die("unknown operation", what)
    return ""
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


; query youtube and return an array with all the answers
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
  SoundBeep, 7000, 100
  
}





get_active_window_id()
{
  WinGet, current_ID, ID, A
  return current_ID
}

set_active_window_id(new_id)
{
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
return_to_previous_state()
{

  global previous_state_window_ID
  global previous_state_mouse_x
  global previous_state_mouse_y

  set_active_window_id(previous_state_window_ID)

  CoordMode, Mouse, screen
  mouse_move(previous_state_mouse_x, previous_state_mouse_y)
  beep()

}
  

find_in_explorer( query )
{
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


clipboard_get()
{
  ClipWait, 0.2, 1       ; Wait for the clipboard to contain text. Also exits with timeout
  if ErrorLevel 
  {
    clip := ""
    return clip
  }
  
  clip := "empty"
  clip = %clipboard%
  return clip
}

clipboard_set(text)
{
  clipboard = %text%
  return clipboard_get()
}

clipboard_reset()
{
  clipboard_set("")

}

 

clipboard_copy()
{
  ; reference:  
  ;   https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63356&start=20#p271551
  ;   https://www.autohotkey.com/docs/misc/Clipboard.htm

  clipboard := ""   ; Start off empty to allow ClipWait to detect when the text has arrived.
  Send ^c
  return clipboard_get()
}
 

clipboard_cut()
{
  clip := clipboard_copy()
  if(clip != ""){
     Send Backspace
  }
  
  return clip
}

clipboard_paste(text)
{
  clipboard_set(text)
  Send ^v
}

;a
;b
;c

;clipboard_get()
;clipboard_set(text)
;selection_copy_normalize(normalize := True)
;clipboard_cut(normalize := True)
;clipboard_paste(text){
    
  

slow_send(what)
{
  send % what
  sleep, 25
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Multi line Query support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


selection_copy_normalize(normalize := True)
{
  clipboard_copy()

  if(normalize){
    clipboard := normalize_query(clipboard)
  }
  
  return clipboard
}


selection_copy_normalize_to_array( debug := False)
{
  ret := Array()
  
  query := selection_copy_normalize()
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
  
  ;debug := True
  
  debug_print_array(debug, "Processing query:", ret)
  
  return ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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
  
  if(!(WinExist("ahk_exe SoulseekQt.exe"))){
    MsgBox, Soulseek window not present
    return 0
  } else {
    WinActivate
    Sleep, 200
    
    return get_active_window_id()
  
    WinMove, 40, 40 
    MsgBox, Moved
    return 0
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



soulseek_one_query(query)
{
  clipboard_set(query)
  
  CoordMode, Mouse, window
  if(!slsk_activate()){
    
    return
  }
  
  ;MsgBox, Soulseek window  present

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
  query := selection_copy_normalize()
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


;;;;;

is_chrome_runnning()
{
  ret := WinExist("ahk_class MozillaWindowClass") 
    or WinExist("ahk_class Chrome_WidgetWin_0")
    or WinExist("ahk_class Chrome_WidgetWin_1")
  
  return ret
}



require_chrome()
{
  if(!is_chrome_runnning()){
     die("Chrome not running")
     return False
  }

  return True
}

chrome_activate(){
  if(!require_chrome()){
    return False
  }  
   
  ;print("chrome is runnnig")
 
  ; https://autohotkey.com/board/topic/97911-winactivate-doest-work-fully-with-chrome/
  settitlematchmode 2
  winactivate, Google Chrome
  Sleep, 200
  
  return get_active_window_id()
}




  
  
; required: chrome already activated
get_current_chrome_url()
{
  Clipboard = ; empty clipboard
  
  slow_send("^l")        ;gives focus to the URL
  slow_send("^c")        
  ClipWait, 0
  url := Clipboard
  
  ;print("received", url)
  
  return url
}


do_chrome_get_current_url()
{
  debug_beep()
  
  if(not chrome_activate())
    return
  
  ;return
  
  url := get_current_chrome_url()
  
}  


do_chrome_get_all_urls()
{
  beep()
  
  if(not chrome_activate())
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
    
    url := get_current_chrome_url()
 
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


array_to_ml_spaced(Array, seperator_lines=2)
{
  sep := duplicate_string("`n", seperator_lines)
  
  ;debug(sep)
  return array_to_ml(Array, sep)
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





return_to_previous_state_if_single(array)
{
  if(array.count() <= 1){
    return_to_previous_state()
  } else {
    beep()
  }
}  
  
  
 
validate_query( query, max := 20 )
{
  if(!query.count()){
    return False
  }
  
  ;max := 3
  
  if(query.count() > max ){
    die("Too many entries to process (", query.count(), ")") 
    return False
  }

  return True

}
 
 
 
do_search_youtube_first_hit( what := "show_entries" )
{
	debug_beep()
  debug := True
  debug := False
  
  
  query := selection_copy_normalize_to_array()
  if(!validate_query(query)){
    return
  }
  
  ;debug_print_array(debug, "query", query)
  remember_previous_state()
  
  results := Array()
  for index, line in query
  {
      url := first_youtube_result( line, what )
      results.Push(url)
  }
  
  debug_print_array(debug, "results", results)
  return_to_previous_state_if_single(results)
    
  do_open_several_urls(results)  
}

  
do_find_explorer( debug := False )
{
	debug_beep()
  ;debug := True
  
  query := selection_copy_normalize_to_array()
  if(!validate_query(query)){
    return
  }
  
  ;debug_print_array(debug, "query", query)
  remember_previous_state()
  
  do_pause := False  
  for index, line in query
  {
    if(do_pause){
      pause()
    }
    find_in_explorer( line )
  
    do_pause := True
  }
  return_to_previous_state_if_single(query)    
}




do_find_explorer_old(){
	debug_beep()
  query := selection_copy_normalize()
  if(query == "")
    return
    
    
    
  find_in_explorer(query)
}
  
  
  

do_soulseek()
{
	debug_beep()
  debug := True
  debug := False
    
  query := selection_copy_normalize_to_array(debug)

  if(!validate_query(query)){
    return
  }
      
  remember_previous_state()
  for index, line in query
  {
      soulseek_one_query(line)
  }    
  return_to_previous_state_if_single(query)
}


do_collect_all_youtube_results_to_clipboard()
{
  debug_beep()
  debug := True
  debug := False
  
  query := selection_copy_normalize_to_array()
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
  clipboard_set(st)
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
;;;  Sub-routines converted to functions (part of old activaid
;;;



wc_sub_MouseHotkey()
{

   If A_ThisHotkey contains MButton,LButton,RButton,XButton1,XButton2
   {
      MouseGetPos,,,wc_MouseID
      IfWinNotactive, ahk_id %wc_MouseID%
      {
         WinActivate, ahk_id %wc_MouseID%
         WinWaitActive, ahk_id %wc_MouseID%
      }
   }
}


tim_WM_DISPLAYCHANGE()
{
   global NumOfMonitors


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

   If(NumOfMonitors < 1)
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

   ; this is to check if anything changed.
   if(False){
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
   }

   LastWorkAreaWidth = %WorkAreaWidth%
   LastWorkAreaHeight = %WorkAreaHeight%
   LastMonitorAreaWidth = %MonitorAreaWidth%
   LastMonitorAreaHeight = %MonitorAreaHeight%

   ; ac'tivAid automatisch deaktiveren, wenn der Installer sichtbar ist.
   DetectHiddenWindows, On
   InstallerVisible := False
   If (WinActive("License - ac'tivAid v") OR WinActive("Lizenzbestimmungen - ac'tivAid v") OR WinActive("ac'tivAid v","Installationsfortschritt") OR WinActive("ac'tivAid v","Installation progress") OR WinExist("##### NEXTBUILD.ahk"))
   {
      DetectHiddenWindows, Off
      If A_IsSuspended = 0
      {
         ;;Gosub, sub_MenuSuspend
         InstallerVisible := True
      }
   }
   Else If ( InstallerVisible )
   {
      DetectHiddenWindows, Off
      InstallerVisible := False
      ;; Gosub, sub_MenuSuspend
   }
   
   ; wc_Monitor := func_GetMonitorNumber("A")
   wc_Monitor := 1
    
    
    
    mon := Monitor(WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)

    return mon
}



move_windows_virtual_desktop(where)
{
  ;; "Yet another AHK Script"
  ;; https://superuser.com/questions/950452/how-to-quickly-move-current-window-to-another-task-view-desktop-in-windows-10


  WinGetTitle, Title, A
  WinSet, ExStyle, ^0x80, %Title%
  
  if(where == "left"){
    Send {LWin down}{Ctrl down}{Left}{Ctrl up}{LWin up}
  } else {
    Send {LWin down}{Ctrl down}{Right}{Ctrl up}{LWin up}
  }
  
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  WinActivate, %Title%
  
  return
  
  ;; optional: return to where we were
  
  if(where == "left"){
    Send {LWin down}{Ctrl down}{Right}{Ctrl up}{LWin up}
  } else {
    Send {LWin down}{Ctrl down}{Left}{Ctrl up}{LWin up}
  }
  
}



;;;
;;; Clipchain
;;;    Clipboard utility for copying multiple strings into one long "chain"
;;;    https://github.com/DustinLuck/ClipChain/blob/master/ClipChain.ahk
;;;    http://lifehacker.com/5306452/clipchain-copies-multiple-text-strings-for-easy-pasting
;;;
;;; Standard clipboard shortcuts:
;;;    https://www.digitalcitizen.life/5-ways-cut-copy-and-paste-windows
;;;    https://answers.microsoft.com/en-us/windows/forum/windows_7-networking/remote-desktop-shiftinsert-for-paste/2add1c3a-deb9-4583-a6f4-f141db4bc325
;;;


clipchain_set_clipboard()
{
  global clipchain_sep, clipchain_value
  clipboard_set(clipchain_value)
}  


clipchain_copy()
{
  global clipchain_sep, clipchain_value
  beep()

  ;print("clipchain_value:", clipchain_value)
  
  clip := clipboard_copy()
  
  ;print("just received:", clip)
  
  new_line := "`r`n"
  empty_line := 
   
  if(clip == ""){
    ;print("Empty selection", clip)
    
    clipchain_set_clipboard()

    return
  }
  
  last_char1 := SubStr(clip, 0, 1)
  last_char2 := SubStr(clip, -1, 1)

  ;print("seen:", last_char1, last_char2)

  if( last_char1 == "`r" || last_char1 == "`n"){
    seperator := empty_line
    ;print("clip had newline")

  } else {
    seperator := new_line
  }
  
  
  clipchain_value = %clipchain_value%%clip%%seperator%

  ;print1(clipchain_value)
  
  clipchain_set_clipboard()
}

 
 
clipchain_test()
{
  ; 12
  ; 2
  ; 3
  ; 4
  ; 5
}



clipchain_reset()
{
  global clipchain_sep, clipchain_value
  beep()

  clipchain_value := ""
  clipchain_set_clipboard()
}

clipchain_cut()
{
  clipchain_copy()
  clipboard_cut()
  clipchain_set_clipboard()  
}


clipchain_paste()
{
  global clipchain_sep, clipchain_value
  beep()

  clipboard_paste(clipchain_value)
}



;;;
;;;  AutoExec Actions follow. DO NOT PUT FUNCTIONS AFTER THIS!
;;;


#SingleInstance force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; https://www.autohotkey.com/docs/commands/_Warn.htm

SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, window
global_bash_exe := get_bash_exe()
debug_XY_coord := "none"

diacritic_current := 1
diacritic_cycling := 1
diacritic_enabled := 0

window_move_enabled :=0
window_move_enabled :=1

clipchain_enabled := 1
clipchain_sep := "`r`n"
clipchain_value := ""
    
tim_WM_DISPLAYCHANGE()
wc_sub_MouseHotkey()
   
     
init_beep()              ; Signal that we finished autoexec section


;;; #	Win
;;; !	Alt
;;; ^	Control
;;; +	Shift
;;;

#if clipchain_enabled

#Insert::   clipchain_copy()
#Delete::   clipchain_reset()

#if




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
#Left::   do_windows_enlarge("left")
#Right::  do_windows_enlarge("right")
#Up::     do_windows_enlarge("up")
#Down::   do_windows_enlarge("down")

;#!Left::  do_windows_enlarge("alt_left")
;#!Right:: do_windows_enlarge("alt_right")
;#!Up::    do_windows_enlarge("alt_up")
;#!Down::  do_windows_enlarge("alt_down")
#if 




^#!esc:: exitapp
^#!F11:: XY_analyse_init()
^#!F12:: ahk_reload()

;; temporary for testing: Win+S
#s:: ahk_reload()

;; personal for pedro
^!BS:: send, _00

;; virtual desktops: move windows between them
^!Left::  move_windows_virtual_desktop("left")
^!Right::  move_windows_virtual_desktop("right")



^F8::   do_open_google()
^+F8::   do_open_discogs()

^F9::   do_find_explorer()

^F10::  do_soulseek()  

^F11::    do_chrome_get_current_url()
^+F11::   do_chrome_get_all_urls()

^F12::  do_search_youtube_first_hit("show_entries")       ;; CTRL+F12 opens several videos
^+F12::  do_search_youtube_first_hit("show_search_page")   ;; Win+F12 open several search page for videos
^#F12:: do_collect_all_youtube_results_to_clipboard()     ;; CTRL+WIN+F12 gets 5 copies for each video. Everything goes to clipboard
	  

;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;
;;;
;;; To change shortcuts: 
;;;   https://www.autohotkey.com/docs/Hotkeys.htm   (modifier keys)
;;;   https://www.autohotkey.com/docs/KeyList.htm   (full reference of everything)
;;;
;;; #	Win
;;; !	Alt
;;; ^	Control
;;; +	Shift
;;;
;
;
;
; <F8: GOOGLE/DISCOGS>  <F9: EXPLORER>    <F10: SOUSLEEK>   <F11: CHROME URLS>  <F12: YOUTUBE>
;
;
; Global shortcuts:
;    CTRL+F08:    Search in Google
;    CTRL+SH+F08: Search in Discogs
;   
;    CTRL+F09:    search text in File Explorer
;    CTRL+F10:    search text in soulseek
;   
;    CTRL+F11:    GET chrome URL
;    CTRL+SH+F11: GET ALL chrome URLs
;   
;    CTRL+F12:    OPEN youtube hit
;    CTRL+SH+F12: OPEN youtube results 
;    CTRL+WN+F12: GET top-5 youtube urls
;
;
; Virtual desktops:
;    CTRL+ALT+LEFT  = move the window to left desktop
;    CTRL+ALT+RIGHT = move the window to right desktop
;    CTRL+WIN+LEFT  = move to left desktop
;    CTRL+WIN+RIGHT = move to right desktop
;
;
; ClipBoard:
;    CTRL+INS : standard copy
;    CTRL+DEL : standard cut
;    SHIFT+INS : standard paste
;    Win+V: Win10 clipboard history  
;   
; ClipChain:
;    WIN+DEL : Reset chain
;    WIN+INS : Append to chain. 
;              also puts the chain to the clipboard, even if none is selected.
;   
;
; Diacritic characters support:  (if enabled)
;    CTRL+WIN+ALT+A: Toggle diacritic vowels support
;   
;    CTRL+A: cycle diacritic "a"
;    CTRL+E:  (same)
;    CTRL+I:  (same)
;    CTRL+O:  (same)
;    CTRL+U:  (same)
;
;
; Maintenance:  
;    CTRL+WIN+ALT+ESC = Emergency stop
;    CTRL+WIN+ALT+F11 = Debug mouse XY values (cycle)
;    CTRL+WIN+ALT+F12 = Reload/Restart this script
;               WIN+S = reload this script (shortcut)  
;
;
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
;
;
; NOTEPAD++ shortcuts:
;    list of shortcuts: http://www.keyxl.com/aaacd5a/43/Notepad-Plus-text-editor-software-keyboard-shortcuts.htm
;    config file: %AppData%\Notepad++\shortcuts.xml
;   
;    ctrl+L = cut line to clipboard
;    ctrl+V = paste line from clipboard
;    ctrl+D = duplicate paste line from clipboard
;
;
; Other global shortcuts:
;    Win+BackSpace: windows always on top
;    Shift+MouseWheel: folder history
;    CTRL+MouseWheel: Zoom
;    CTRL+R: show extensions
;   
;    ` - solo track adobe audition
;    CTRL+` - mute track adobe audition
;
;
;;; END
