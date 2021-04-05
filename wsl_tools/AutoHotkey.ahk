;
; AutoHotKey file for Windows powerusers and DJs
; Created by Pedro Estrela, 2021
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
; String functions:
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
;  IDE / syntax highlighting:
;     https://www.autohotkey.com/boards/viewtopic.php?t=50  (lazy theme)
;     https://github.com/maestrith/AHK-Studio/wiki/File
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


; update:
;  list of functions: https://autohotkey.com/board/topic/72918-my-ahk-stuff/
;  ahk grid (depends on the mouse position) https://gist.github.com/dcai/ec6f5a9a6d066fcf3c8f0e61f8d01e4f



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  Print and Debug functions
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
  print(values*)

  ;print2( "|", True, values* )
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



print_debug( debug, var* )
{
  debug_print( debug, var* )
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


print_kv(key, value){
  if(len(value) == 0 ){
    value := "<empty>"
  }

  msgbox, %key% = |%value%|
}



debug_print_kv(debug, key, value){
  global_do_debug := True
  ; global_do_debug := False

  if(global_do_debug){
    if(debug){
      print_kv(key, value)
    }
  }
}


debug_print_array(debug, name, array, show_elements := false)
{
  show_elements := true
  
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


int(x)
{
  return floor(x)
}


strip(String, OmitChars := " `t"){
  return Trim(String, OmitChars)
}

len(String){
  return StrLen(String)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Array support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  mouse control
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WSL and shell stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





; Find correct bash.exe file
get_bash_exe()
{
  ;; options to launching WSL commands in windows
  ;  https://stackoverflow.com/questions/41225711/wsl-run-linux-from-windows-without-spawning-a-cmd-window
  ; https://devblogs.microsoft.com/commandline/a-guide-to-invoking-wsl/
  ; bash_exe =  %A_WinDir%\sysnative\bash.exe
  ; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
  ; debug_print("bash found at: " %bash_exe% )
  ; Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
  ; Run, "%bash_exe%" -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause'
  ; ShellRun("C:\vim\vim80\gvim.exe", "+SLoad", "", "", 3)
  ; run, bash.exe -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause
  ; run, C:\windows\system32\bash.exe    ;  -c 'echo ola '

  bash_exe = %A_WinDir%\sysnative\bash.exe
  if (!FileExist(bash_exe)) {
      bash_exe = %A_WinDir%\system32\bash.exe
  } if (!FileExist(bash_exe)) {
      MsgBox, 0x10, , WSL(Windows Subsystem for Linux) must be installed.
      ExitApp, 1
  }
  return bash_exe
}



run_shell_get_output(program, command) 
{
  ; source: https://www.autohotkey.com/boards/viewtopic.php?t=17910

  shell := ComObjCreate("WScript.Shell")
	exec := shell.Exec(program " /c " command)
	
  if (A_LastError)
		return A_LastError
    
  ret := exec.StdOut.ReadAll()
  ;print(ret)
    
	return ret
}


run_cmd_get_output(command) 
{
  return run_shell_get_output("cmd", command) 

}


run_wsl_get_output(command) 
{
  ; %windir%\system32\wsl.exe
  return run_shell_get_output("bash", command) 

}


  



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; unit tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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

test_scale_loc()
{
  loc := Location_abs(   1010, 1010, 1020, 1020)
  mon1 := Monitor_abs(1, 1000, 1000, 1100, 1100)
  mon2 := Monitor_abs(2, 2000, 2000, 2200, 2200)
  new_loc_correct := Location_abs(2020, 2020, 2040, 2040)

  new_loc_test := mon_scale_loc(loc, mon1, mon2)

  loc_same_assert(new_loc_test, new_loc_correct)


}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FancyZones PowerToys Extension
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This package implements window movement shortcuts. This is similar to the standard windows Win+Arrow
;    (settings / multitasking / snap windows "ON" / other settings "OFF"
;
; Similarities:
;   general feel
;   it scales random windows to the monitor size and location
;
; Differences:
;   Win+left does NOT move between windows (too confusing)
;   maximize bit is always unset.
;   There is no intermediate step between L2 and R2
;   no swapping "behind" screens (going from 1 to 3)
;
;;;;;;;;;;;;;;;;;;;;;;;
;
; standard windows 10 behavior:
;   left: r2 -> rr -> l2 -> r2 (other screen) -> rr -> l2 -> etc
;   down+left: l2 -> bl2 -> br2 (othr screen) -> does not pass trough "rr"
;   (to return from bl2 to l2 you need to press "up")
;
; These WERE the windows standard shortcuts:
;    Win+arrow: movement on corners + expand columns + move columns
;    ctrl+win: virtual desktops  (disabled)
;    ctrl+alt: nothing
;    ctrl+win+alt: resize window (up to maximized)
;
;
;  AHK Customized shortcuts:
;    Win+Arrows:
;      pressing ONCE creates corners / moves corners around
;      pressing TWICE always generates half-sizes
;      note: this shortcut never swaps screens
;
;    Shift+Win+Arrows:
;      Swaps between screens. Does not "wrap behind" (screen1 -> screen3)
;      if keeping on the same screen, performs regular enlargement
;
;
;
;;;
;;;  Fancyzones REQUIRED configuration on windows 10
;;;
;
;  PowerToys fancyzones:
;    info:
;      manual: https://docs.microsoft.com/en-us/windows/powertoys/fancyzones
;      multiple overlapping zones discussion: https://github.com/microsoft/PowerToys/issues/6744
;
;    Zones:
;       vertical monitor, 8 squares
;       horizontal monitor, 6 squares + 3 columns   (sizes: 1048, 1055, 969)
;
;    Options:
;      hold shift: "OFF"
;      use non primary mouse button: ON
;      show zones in all monitors: OFF
;      allow zones to span across monitors: OFF
;      multiple zones overlap: split the overlapped area into multiple...
;
;      Override windows snap: ON
;      Win+Up move windows based on relative position ON
;      Keep windows in their zones when the resolution changes ON
;      during a zone layout change... ON
;      move newly created windows to last known zone: ON
;      move newly created windows to active monitor: ON
;      restore original size when unsnapping: OFF          <<<<<<<<<<
;
;      quicklayout: OFF
;      make dragged window transparent: ON
;      zone opacity: 78%
;
; Windows 10 Multitasking:
;    Options:
;      snap windows OFF
;      show suggestions on timeline OFF
;      on taskbar show only desktop I'm using
;      alt+tab show only desktop I'm using
;
;
;
;;;;;;;; 
;;;;;;;; fancyzones alternatives
;;;;;;;;
;
;  WindowGrid:
;    this is a great program. It both Resizes and moves windows locked to a grid
;
;    settings: 6x6 grid, disable aero shake, show dragged contents OFF
;      graphics: fill window OFF / radial gradient OFF
;
;    http://windowgrid.net/
;
;  Divvy:
;    https://mizage.com/help/windivvy/
;
;
;  gridmove:
;    https://www.ghacks.net/2007/01/14/grid-move-divides-your-desktop-into-grids/
;
;  winlayout:
;    https://www.ghacks.net/2009/03/11/windows-desktop-management-software-win-layout/
;
;  tictac:
;     https://www.ghacks.net/2010/08/23/align-windows-on-the-windows-desktop/
;
;    (list ataken from https://www.ghacks.net/2019/05/29/windowgrid-improve-window-moving-resizing-and-aligning-on-windows/)
;
;  gridy:
;    https://www.ghacks.net/2010/07/26/align-windows-on-the-desktop-easily-with-gridy/
;
;





;;;;;;;;;;
;;;;;;;;;; MONITOR definitions
;;;;;;;;;;


;; note1: parameter sequence is always: location, monitor, case
;; note2: my classes always receive width/heighth, but then store eveything in absolute numbers.
;;   absolute 0,0 is the top left corner of the primary monitor



Monitor_abs(number, c1_x, c1_y, c2_x, c2_y)
{
  w := c2_x - c1_x
  h := c2_y - c1_y

  return Monitor_wh(number, c1_x, c1_y, w, h)

}



Monitor_wh(number, x, y, w, h)
{
  ;; note: input is weight and

  mon := Object()

  mon.number := number

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

  st .= " Monitor(#" . mon.number . ", "
  st .= "" . mon.x0 . " _ " . mon.x4 . ", "
  st .= "" . mon.y0 . " _ " . mon.y4 . ") "

  return st
}


print_mon(mon)
{

  print( mon_2_st(mon))
}


mon_span_x(mon){
  return mon.x4 - mon.x0
}


mon_span_y(mon){
  return mon.y4 - mon.y0
}


mon_scale_x(mon1, mon2)
{
  ; idea: https://autohotkey.com/board/topic/32874-moving-the-active-window-from-one-monitor-to-the-other/

  a1 := mon_span_x(mon1)
  a2 := mon_span_x(mon2)
  scale := a2/a1

  return scale
}

mon_scale_y(mon1, mon2)
{
  a1 := mon_span_y(mon1)
  a2 := mon_span_y(mon2)
  scale := a2/a1
  return scale
}

point_scale(p, abs1, abs2, scale)
{
  p := p - abs1
  p := p * scale
  p := p + abs2
  p := int(p)

  return p
}


mon_scale_loc(loc, mon1, mon2, max:=0)
{
  ;
  ; example, for the X location only:
  ;   loc:      1010 .. 1020
  ;   monitor1: 1000 .. 1100   (10px)
  ;   monitor2: 2000 .. 2200   (20px)
  ;
  ;   new_loc:  2020 .. 2040
  ;
  ;
  ; scale calculation
  ;   1100 - 1000 = 100
  ;   2200 - 2000 = 200
  ;   200 / 100 = 2x
  ;
  ; final calcs:
  ;   1010 - 1000 = 10
  ;     10 x 2 = 20
  ;
  ;   2000 + 20

  debug := False

  scale_x := mon_scale_x(mon1, mon2)
  scale_y := mon_scale_y(mon1, mon2)

  ;print(scale_x, scale_y)

  x0 := point_scale(loc.x0, mon1.x0, mon2.x0, scale_x)
  x4 := point_scale(loc.x4, mon1.x0, mon2.x0, scale_x)

  y0 := point_scale(loc.y0, mon1.y0, mon2.y0, scale_y)
  y4 := point_scale(loc.y4, mon1.y0, mon2.y0, scale_y)

  ;print(x0, y0, x4, y4, max)
  new_loc := Location_abs(x0, y0, x4, y4, max)

  ;print_loc(loc)
  ;print_loc(new_loc)

  ;debug := True
  print_debug(debug, scale_x, scale_y)
  print_debug(debug, loc_2_st(loc), " -> ", loc_2_st(new_loc))

  return new_loc
}





;;;;;;;;;;
;;;;;;;;;; LOCATIONS definitions
;;;;;;;;;;


Location_abs(c1_x, c1_y, c2_x, c2_y, max := 0)
{
  loc := {}

  loc.x0 := c1_x
  loc.y0 := c1_y
  loc.x4 := c2_x
  loc.y4 := c2_y

  loc.max := max

  return loc
}




Location_wh(x, y, w, h, max :=0 )
{
  return Location_abs(x, y, x+w, y+h, max)
}


Location_cycle_maximized(loc)
{
  if(loc.max == -1){
    loc.max := 0

  } else if(loc.max == 0){
    loc.max := 1

  } else if(loc.max == 1){
    ;loc.max := -1
    loc.max := 0

  } else {
    error("unknown minmax")

  }

  return loc
}


Location_set_minimized(loc)
{
  loc.max := -1
  return loc
}



loc_same(loc1, loc2, assert:=False)
{
  st1 := loc_2_st(loc1)
  st2 := loc_2_st(loc2)

  ret := st1 == st2
  if(assert){
    if(ret == False){
      print("Error: loc different:", st1, st2)

    }
  }
  return ret
}


loc_same_assert(loc1, loc2, assert:=True)
{
  return loc_same(loc1, loc2, assert)

}



loc_2_st(loc)
{
  st := ""

  st .= "Location(" . loc.x0 . " _ " . loc.x4 . ", "
  st .= loc.y0 . " _ " . loc.y4 . ", "

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

  loc := Location_wh(x, y, w, h, wc_Max)
  return loc
}


loc_is_equal(l1, l2)
{
  return l1.x0 == l2.x0 and l1.y0 == l2.y0 and l1.x4 == l2.x4 and l1.y4 == l2.y4

}


loc_span_x(loc){
  return loc.x4 - loc.x0
}


loc_span_y(loc){
  return loc.y4 - loc.y0
}



;;;;;;;;;;
;;;;;;;;;; CASES definitions
;;;;;;;;;;


case_2_loc(mon, case)
{

  ;; monitor shorthands
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


  ;; target variables
  max := 0      ; -1: minimized; 0: neither; 1: real maximized
  c1_x := 0
  c1_y := 0
  c2_x := 100
  c2_y := 100

  if(case == "max"){
    ; real maximize
    max := 1

  } else if(case == "min"){
    ; real minimize
    max := -1

  } else if(case == "fmax"){
    ; fake maximize
    c1_x := x0
    c1_y := y0
    c2_x := x4
    c2_y := y4


  ;;;;;;;; case 2   (mid)
  } else if(case == "tl2"){
    c1_x := x0
    c2_x := x2
    c1_y := y0
    c2_y := y2


  } else if(case == "tr2"){
    c1_x := x2
    c2_x := x4
    c1_y := y0
    c2_y := y2

  } else if(case == "bl2"){
    c1_x := x0
    c2_x := x2
    c1_y := y2
    c2_y := y4

  } else if(case == "br2"){
    c1_x := x2
    c2_x := x4
    c1_y := y2
    c2_y := y4

  } else if(case == "l2"){
    c1_x := x0
    c2_x := x2
    c1_y := y0
    c2_y := y4

  } else if(case == "r2"){
    c1_x := x2
    c2_x := x4
    c1_y := y0
    c2_y := y4

  } else if(case == "t"){
    c1_x := x0
    c2_x := x4
    c1_y := y0
    c2_y := y2

  } else if(case == "b"){
    c1_x := x0
    c2_x := x4
    c1_y := y2
    c2_y := y4



  ;;;;;;;;;; case 1  (1/3)
  } else if(case == "tl1"){
    c1_x := x0
    c2_x := x1
    c1_y := y0
    c2_y := y2

  } else if(case == "tr1"){
    c1_x := x1
    c2_x := x4
    c1_y := y0
    c2_y := y2

  } else if(case == "bl1"){
    c1_x := x0
    c2_x := x1
    c1_y := y2
    c2_y := y4

  } else if(case == "br1"){
    c1_x := x1
    c2_x := x4
    c1_y := y2
    c2_y := y4

  } else if(case == "l1"){
    c1_x := x0
    c2_x := x1
    c1_y := y0
    c2_y := y4

  } else if(case == "r1"){
    c1_x := x1
    c2_x := x4
    c1_y := y0
    c2_y := y4



  ;;;;;;;;;; case 3  (2/3)
  } else if(case == "tl3"){
    c1_x := x0
    c2_x := x3
    c1_y := y0
    c2_y := y2

  } else if(case == "tr3"){
    c1_x := x3
    c2_x := x4
    c1_y := y0
    c2_y := y2

  } else if(case == "bl3"){
    c1_x := x0
    c2_x := x3
    c1_y := y2
    c2_y := y4

  } else if(case == "br3"){
    c1_x := x3
    c2_x := x4
    c1_y := y2
    c2_y := y4

  } else if(case == "l3"){
    c1_x := x0
    c2_x := x3
    c1_y := y0
    c2_y := y4

  } else if(case == "r3"){
    c1_x := x3
    c2_x := x4
    c1_y := y0
    c2_y := y4



  } else {
    ; error case = center (TBD)
    c1_x := 100
    c2_x := 100
    c1_y := 400
    c2_y := 400

  }


  loc := Location_abs(c1_x, c1_y, c2_x, c2_y, max )
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


;;;;;;;;;;
;;;;;;;;;; TRANSLATIONS definitions
;;;;;;;;;;




get_translation_table(action)
{
  return get_translation_table_3(action)

}


;;;;;;;;;;;
get_translation_table_3(action)
{
  t := Array()

  if(action == "left"){
    ;;; Maximizes
    t["fmax"] := "l2"
    t["max"]  := "l2"
    t["min"]  := "l2"
    t["rr"]   := "l2"

    ;; whole screen
    t["t"]  := "tl2"
    t["b"]  := "bl2"

    ;;; Half-screen
    t["l1"] := "l2"
    t["l2"] := "l2"
    t["l3"] := "l2"

    t["r1"] := "l2"
    t["r2"] := "l2"
    t["r3"] := "l2"

    ;;; Corners
    t["tl1"] := "l2"
    t["tl2"] := "l2"
    t["tl3"] := "l2"

    t["tr1"] := "tl2"
    t["tr2"] := "tl2"
    t["tr3"] := "tl2"

    t["bl1"] := "l2"
    t["bl2"] := "l2"
    t["bl3"] := "l2"


    t["br1"] := "bl2"
    t["br2"] := "bl2"
    t["br3"] := "bl2"

  }


  if(action == "right"){
    ;;; Maximizes
    t["fmax"] := "r2"
    t["max"]  := "r2"
    t["min"]  := "r2"
    t["rr"]   := "r2"

    ;; whole screen
    t["t"]  := "tr2"
    t["b"]  := "br2"


    ;;; Half-screen
    t["l1"] := "r2"
    t["l2"] := "r2"
    t["l3"] := "r2"

    t["r1"] := "r2"
    t["r2"] := "r2"
    t["r3"] := "r2"

    ;;; Corners
    t["tl1"] := "tr2"
    t["tl2"] := "tr2"
    t["tl3"] := "tr2"

    t["tr1"] := "r2"
    t["tr2"] := "r2"
    t["tr3"] := "r2"

    t["bl1"] := "br2"
    t["bl2"] := "br2"
    t["bl3"] := "br2"


    t["br1"] := "r2"
    t["br2"] := "r2"
    t["br3"] := "r2"

  }



  ;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;


  if(action == "up"){
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

    t["t"]  := "t"
    t["b"]  := "t"


    ;;; Corners
    t["tl1"] := "t"
    t["tl2"] := "t"
    t["tl3"] := "t"

    t["tr1"] := "t"
    t["tr2"] := "t"
    t["tr3"] := "t"


    t["bl1"] := "tl1"
    t["bl2"] := "tl2"
    t["bl3"] := "tl3"

    t["br1"] := "tr1"
    t["br2"] := "tr2"
    t["br3"] := "tr3"

  }


  if(action == "down"){
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
    t["tr1"] := "br1"
    t["tr2"] := "br2"
    t["tr3"] := "br3"

    t["tl1"] := "bl1"
    t["tl2"] := "bl2"
    t["tl3"] := "bl3"

    t["br1"] := "b"
    t["br2"] := "b"
    t["br3"] := "b"

    t["bl1"] := "b"
    t["bl2"] := "b"
    t["bl3"] := "b"

  }

  return t
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


get_monitor_definitions()
{
  ; notes about sysget monitor:
  ;   https://www.autohotkey.com/docs/commands/SysGet.htm#Monitor
  ;
  ;  Within a function, to create a set of variables that is global instead of local, declare Mon2 as a global variable prior
  ;  to using this command (the converse is true for assume-global functions).
  ;
  ;  However, it is often also necessary to declare each variable in the set, due to a common source of confusion.
  ;
  ;  https://www.autohotkey.com/docs/Functions.htm#ArrayConfusion
  ;
  ;  Any non-dynamic reference to a variable creates that variable the moment the script launches. For example, when used
  ;  outside a function, MsgBox %Array1% creates Array1 as a global the moment the script launches. Conversely, when used
  ;  inside a function MsgBox %Array1% creates Array1 as one of the function's locals the moment the script launches
  ;  (unless assume-global is in effect), even if Array and Array0 are declared global.
  ;

  global           ; Assume all variables global
  local debug

  debug :=  False

  ; Determine the number of monitors and work surface
  SysGet, NumOfMonitors, 80
  SysGet, WorkArea, MonitorWorkArea

  ;
  ; Dimensions of the primary monitor. This is for old windows
  ;
  SysGet, Monitor, Monitor
  MonitorHeight := MonitorBottom-MonitorTop
  MonitorWidth := MonitorRight-MonitorLeft

  SysGet, WorkAreaPrimary, MonitorWorkArea
  WorkAreaPrimaryWidth  := WorkAreaPrimaryRight - WorkAreaPrimaryLeft
  WorkAreaPrimaryHeight := WorkAreaPrimaryBottom - WorkAreaPrimaryTop

  If(NumOfMonitors < 1)
    NumOfMonitors = 1


  if(debug){
    debug_print_kv(debug, "NumOfMonitors", NumOfMonitors)
  }


  ; get details for all monitors
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

  ; Deactivate ac'tivAid automatically if the installer is visible.
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


  ;debug_print_kv(debug, "Current active monitor", wc_Monitor)


  ;;;;
  ; this is a hack
  wc_Monitor := 1
  global_mon1 := Monitor_wh(wc_Monitor, WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)
  global_mon2 := global_mon1
  global_mon3 := global_mon1


  if(NumOfMonitors >= 2){
    wc_Monitor := 2
    global_mon2 := Monitor_wh(wc_Monitor, WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)

  }

  if(NumOfMonitors >= 3){
    wc_Monitor := 3
    global_mon3 := Monitor_wh(wc_Monitor, WorkArea%wc_Monitor%Left, WorkArea%wc_Monitor%Top, WorkArea%wc_Monitor%Width, WorkArea%wc_Monitor%Height)

  }

  global_monitor := Array()

  global_monitor[1] := global_mon1
  global_monitor[2] := global_mon2
  global_monitor[3] := global_mon3

  wc_Monitor := func_GetMonitorNumber("A")

  return wc_Monitor
}



virtual_desktop_change_window(where)
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





window_set_minmax(new_loc)
{
  if(new_loc.max == 0){
    WinRestore, A

  } else if(new_loc.max == 1){
    WinMaximize, A

  } else if(new_loc.max == -1){
    WinMinimize, A


    ; try to keep focus - dosnt work
    ;sleep 100
    ;set_active_window_id(cur_id)
    ; winactivate, "A"

  }
}




;
; Example numbers:
;
;   resolution: 1920, 1080
;   location:   (maximized)    -8,-8, 1936, 1056
;   location:   moved to the right    1913
;   monitor:    0, 0, 1920, 1040
;


window_moveit(new_loc)
{

  debug := False
  ;debug := True

  if(debug){
    prev_loc := get_location()
    print_loc(prev_loc)
  }

  x := new_loc.x0
  y := new_loc.y0
  w := new_loc.x4 - new_loc.x0
  h := new_loc.y4 - new_loc.y0

  x := x - 7 ;- 4

  ; https://www.autohotkey.com/docs/commands/WinMaximize.htm
  ; https://www.autohotkey.com/docs/commands/WinMove.htm
  ; https://www.autohotkey.com/docs/commands/WinRestore.htm
  WinRestore, A
  WinMove, A,, %x%,  %y%, %w%, %h%


  debug_moved_window := False
  if(debug_moved_window){
    sleep, 50
    actual_loc := get_location()

    ;print("moved to", loc_2_st(loc),  "previous: ", loc_2_st(prev_loc), "actual:" , loc_2_st(actual_loc) )
  }
}




do_organize_windows_fancy(action)
{
  ; FancyZones shortcuts (+AHK translation):
  ;    Win+arrow: fancyzones  movement       (AHK: simple regeneration)
  ;    Win+alt: fancyzones grow              (AHK: translation to ctrl+win+alt instead)
  ;    Win+ctrl: AHK move between monitor    (AHK: processed)
  ;    Win+shift: AHK half size              (AHK: processed)



  ;; note: this feature uses AHK "Custom combos".
  ;;    Thus, it needs addiotnal processing for furthr modifiers
  ;;    https://www.autohotkey.com/docs/Hotkeys.htm#combo
  ;;    https://www.autohotkey.com/docs/commands/GetKeyState.htm#function
  ;;

  ;; https://autohotkey.com/board/topic/11647-a-double-click-hotkey/
  ;; https://www.autohotkey.com/boards/viewtopic.php?t=45932
  ;; https://www.autohotkey.com/docs/misc/Remap.htm#actually
  ;; https://www.autohotkey.com/boards/viewtopic.php?t=10067

  has_shift := GetKeyState("shift")
  has_ctrl := GetKeyState("ctrl")
  has_alt := GetKeyState("alt")

  has_anything := has_shift or has_ctrl or has_alt

  ;print("has_shift", has_shift, "has_ctrl", has_ctrl, "has_alt", has_alt) ; , "has_anything", has_anything)

  ; Simple case - regenerate the shortcut to fancyzone movement
  
  if(not has_anything){
    ; 
    if(action=="left"){
      send {LWin down}{Left}
    } else if(action=="right"){
      send {LWin down}{Right}
    } else if(action=="up"){
      send {LWin down}{Up}
    } else if(action=="down"){
      send {LWin down}{Down}
    }
    return
  }

  ; fancyzone grow window
  if(has_ctrl){
    if(action=="left"){
      send {Ctrl down}{LWin down}{Alt down}{Left}{Alt Up}{Ctrl Up}

    } else if(action=="right"){
      send {Ctrl down}{LWin down}{Alt down}{Right}{Alt Up}{Ctrl Up}

    } else if (action=="up"){
      send {Ctrl down}{LWin down}{Alt down}{Up}{Alt Up}{Ctrl Up}

    } else if(action=="down"){
      send {Ctrl down}{LWin down}{Alt down}{Down}{Alt Up}{Ctrl Up}

    }
    return
  }

  ; swap monitor
  if(has_shift){
    do_organize_swap_monitor(action)
    return
  }
  
  ; AHK half size
  if(has_alt){
    do_organize_move_window(action)
    return
  }

  return
}


do_organize_windows(action)
{
  has_shift := GetKeyState("shift")
  has_ctrl := GetKeyState("ctrl")

  if(has_shift){
    do_organize_swap_monitor(action)

  } else {
    do_organize_move_window(action)
  }
}



do_organize_swap_monitor(action)
{
  do_enlarge_window_work(action, True)
}

do_organize_move_window(action)
{
  do_enlarge_window_work(action, False)
}



do_enlarge_window_work(action, do_swap := False)
{
  global global_monitor, NumOfMonitors

  ;beep()

  debug := False
  ;debug := True

  wc_sub_MouseHotkey()

  ; unknown variables
  wc_ResizeFixedWindows := 0
  cr_Resizeable := 0

  WinGet, wc_Style, Style, A
  If ((!(wc_Style & 0x40000) AND wc_ResizeFixedWindows == 0) AND cr_Resizeable <> 1)
    Return



  ;;;;;;;;;; new code follows below
  src_mon_id := get_monitor_definitions()
  dst_mon_id := src_mon_id

  if(do_swap == True){
    if(action == "left"){
      dst_mon_id :=  src_mon_id - 1
      if(dst_mon_id < 1){
        dst_mon_id := 1
      }
    } else if(action == "right"){
      dst_mon_id := src_mon_id + 1
      if(dst_mon_id > NumOfMonitors){
        dst_mon_id := src_mon_id
      }

      ;dst_mon_id := mod((src_mon_id + 1), NumOfMonitors) + 1
    }
  }


  debug_print(debug, "do_swap", do_swap,  "src_mon_id:", src_mon_id, "dst_mon_id", dst_mon_id)

  src_mon := global_monitor[src_mon_id]
  dst_mon := global_monitor[dst_mon_id]


  loc := get_location()
  cur_case := loc_2_case(loc, src_mon)

  ;print("current case:", cur_case)


  debug_tmp := true
  debug_tmp := false

  if(debug or debug_tmp){
    print_loc(loc)
    print_mon(src_mon)
  }


  if(action == "cycle_max"){
    loc := Location_cycle_maximized(loc)

    window_set_minmax(loc)
    return
  }

  if(action == "do_min"){
    loc := Location_set_minimized(loc)

    window_set_minmax(loc)
    return
  }


  ;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;



  ;;;;; normal work goes here
  ; We always exit from a maximized state
  if(cur_case == "max"){
    WinRestore, A

    ; reload current case
    loc := get_location()
    cur_case := loc_2_case(loc, src_mon)
  }


  if(src_mon_id != dst_mon_id){
    new_case := cur_case

  } else {


    t := get_translation_table(action)

    new_case := t[cur_case]
    if(new_case == ""){
      print("AHK: unknown transform", cur_case, action, new_case)
      new_case = "error"
      return
    }
  }
  new_loc := case_2_loc(dst_mon, new_case)



  ;;
  ;; special scaling
  ;;
  ;; standard shift+win behaviour:
  ;;   it scales the location always to the relative positions
  ;;   ADDIOTINALLY, if larger than the screen it also scales the width.
  ;;     (if not, it leaves it unchanged)
  ;;
  if(new_case == "rr"){
    ;; Special case with scaling

    new_loc := mon_scale_loc(loc, src_mon, dst_mon)
  }

  ;debug := True
  print_debug(debug, "Transform:", cur_case, "=>", new_case, " || ", src_mon_id, "=>", dst_mon_id, " ||  ",  loc_2_st(loc), " -> ", loc_2_st(new_loc))

  window_moveit(new_loc)
}





func_GetMonitorNumber( Mode="" )
{
   ; mode:
   ;   "mouse"
   ;   "ActiveWindow"
   ;   "A"  = "active window"
   ;

   global           ; https://www.autohotkey.com/docs/Functions.htm#AssumeGlobal

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

      ; https://www.autohotkey.com/docs/commands/WinGetPos.htm
      WinGetPos, WinX, WinY, WinW, WinH, %Mode%
      WinCenX := WinX + WinW/2
      WinCenY := WinY + WinH/2

      ;print(WinCenX, WinCenY)

      Loop, %NumOfMonitors%
      {

         If (WinCenX >= Monitor%A_Index%Left
             AND WinCenX <= Monitor%A_Index%Right
             AND WinCenY >= Monitor%A_Index%Top
             AND WinCenY <= Monitor%A_Index%Bottom)

            Return %A_Index%
      }

   }
   Return 1
}




;;;;;;;
;;;;;;;  Diacritic characters support (ie, accented characters)
;;;;;;;


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
      ret := ["{asc 0224}"  ; Ã 
      , "{asc 0225}"  ; Ã¡
      , "{asc 0226}"  ; Ã¢
      , "{asc 0227}"]  ; Ã£
    } else {
      ret := ["{asc 0192}"  ; Ã€
      , "{asc 0193}"  ; Ã
      , "{asc 0194}"  ; Ã‚
      , "{asc 0195}"]  ; Ãƒ
    }
  }

  if(letter == "e"){
    if(shift == False){
      ret := ["{asc 0232}"	; Ã¨
	, "{asc 0233}"	; Ã©
	, "{asc 0234}"	; Ãª
	, "{asc 0101}"]	; e
     } else {
      ret := [ "{asc 0200}" 	; Ãˆ
	, "{asc 0201}"	; Ã‰
	, "{asc 0202}"	; ÃŠ
	, "{asc 0069}" ]	; E
     }
  }

  if(letter == "i"){
    if(shift == False){
      ret := ["{asc 0236}"	; Ã¬
	, "{asc 0237}"	; Ã­
	, "{asc 0238}"	; Ã®
	, "{asc 0105}"	] ; i
     } else {
      ret := [ 	 "{asc 0204}"	; ÃŒ
	, "{asc 0205}"	; Ã
	, "{asc 0206}"	; ÃŽ
	, "{asc 0073}"]	; I

     }
  }


  if(letter == "o"){
    if(shift == False){
      ret := ["{asc 0242}"	; Ã²
        , "{asc 0243}"	; Ã³
        , "{asc 0244}"	; Ã´
        , "{asc 0245}" ]	; Ãµ
     } else {
      ret := ["{asc 0210}"	; Ã’
        , "{asc 0211}"	; Ã“
        , "{asc 0212}"	; Ã”
        , "{asc 0213}"]	; Ã•
     }
  }


  if(letter == "u"){
    if(shift == False){
      ret := ["{asc 0249}"	; Ã¹
	, "{asc 0250}"	; Ãº
	, "{asc 0251}"	; Ã»
	, "{asc 0117}"	]

     } else {

      ret := ["{asc 0217}"	; Ã™
	, "{asc 0218}"	; Ãš
	, "{asc 0219}"	; Ã›
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





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; clipboard basic functions
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; XY absolute mouse move support
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

  if(!(WinExist(query))){
    MsgBox, Soulseek window not present
    return 0
  } else {

    WinActivate, %query%
    ;; msgbox, %query%
    sleep,  200

    return 1
  }
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
;;;  New stuff goes here
;;;


toggle_adobe_audition()
{
	remember_previous_state()

  exe_activate("Audition.exe")

  send, {Space}
  sleep, 100

  return_to_previous_state()
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Global search in Google and other URLs accelerators
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
  else if (what == "youtube"){
    url := "https://www.youtube.com/results?search_query=" query
    
  }
  
  return url
}


; Opens the browser and searches a specific engine 
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
  ; idea: https://www.reddit.com/r/AutoHotkey/comments/7y4k8m/automatically_search_selected_text_in_youtube_and/
  ; update 2021-04-05: https://consent.youtube.com/m?continue=https%3A%2F%2Fwww.youtube.com%2Fresults%3Fsearch_query%3Ddedeed&gl=NL&m=0&pc=yt&uxe=23983172&hl=en&src=1
  
  url := gen_youtube_url(query)
  ;MsgBox, %url%
  ;return

  
  ;cmd := "curl http://example.com") 
  cmd := "curl " . url 
  
  ret := run_cmd_get_output(cmd) 
  ;print(ret)
  return ret
  
  ;;;;;;;;
  

	r := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  ;r := ComObjCreate("MSXML2.XMLHTTP.6.0")
	r.Open("GET", url, true)
	r.Send()
	r.WaitForResponse()

  return r.ResponseText
}



; returns the first youtube result for a string
first_youtube_result( query , what )
{
  if(what == "show_first_entry"){
    ;print("first_youtube_result(", query , what )
  
    text := query_youtube_as_html(query)
    ;print(text)
    
    if RegExMatch( text, "/watch\?v=.{11}", match ){
      url := "https://www.youtube.com" match
      ;print("url", url)
      
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

do_open_youtube()
{
  do_open_search_engine("youtube")

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
  ; how to get all open tabs
  ; https://autohotkey.com/board/topic/84158-generic-way-to-get-urls-from-multi-tab-browser/

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



do_search_youtube_first_hit( what := "show_first_entry" )
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
      new_url := first_youtube_result( line, what )
      ;print("first_youtube_result() -> ", new_url)
      
      if(new_url != "")
        results.Push(new_url)
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






;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;  AutoExec Actions follow. DO NOT PUT FUNCTIONS AFTER THIS!
;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Shortcut definition:
;;   https://www.autohotkey.com/docs/Hotkeys.htm   (modifier keys)
;;   https://www.autohotkey.com/docs/KeyList.htm   (full reference of everything)
;;   https://www.autohotkey.com/docs/commands/_MenuMaskKey.htm
;;
;;   #	Win
;;   !	Alt
;;   ^	Control
;;   +	Shift
;;



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

clipchain_enabled := 0
clipchain_enabled := 1
clipchain_sep := "`r`n"
clipchain_value := ""

global_search_enabled :=0
global_search_enabled :=1

get_monitor_definitions()
wc_sub_MouseHotkey()
init_beep()              ; Signal that we finished autoexec section


;;;;;;;;;;;;;;;


#if clipchain_enabled

  #Insert::   clipchain_copy()
  #Delete::   clipchain_reset()

#if


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
  LWin & Left::   do_organize_windows_fancy("left")
  LWin & Right::  do_organize_windows_fancy("right")
  LWin & Up::     do_organize_windows_fancy("up")
  LWin & Down::   do_organize_windows_fancy("down")

  LWin & Numpad0::   do_organize_windows("cycle_max")
  LWin & NumpadDot:: do_organize_windows("do_min")

  ;; BLOCK the Windows key from opening the start menu:
  LWin:: return

  ;; virtual desktops: move windows between them
  ;^!Left::   virtual_desktop_change_window("left")
  ;^!Right::  virtual_desktop_change_window("right")

#if



#if global_search_enabled


  ^#!esc:: exitapp
  ^#!F11:: XY_analyse_init()
  ^#!F12:: ahk_reload()

  ;; temporary for testing: Win+S
  #s:: ahk_reload()

  ;; personal for pedro
  ;^!BS:: send, _00


  ^F8::    do_open_google()
  ^+F8::   do_open_discogs()

  ^F9::    do_find_explorer()

  ^F10::   do_soulseek()

  ^F11::   do_chrome_get_current_url()
  ^+F11::  do_chrome_get_all_urls()

  ;; workaround
  ^F12::   do_search_youtube_first_hit("show_first_entry")       ;; CTRL+F12 opens several videos
  ^+F12::  do_search_youtube_first_hit("show_search_page")   ;; Win+F12 open several search page for videos
  ^#F12::  do_collect_all_youtube_results_to_clipboard()     ;; CTRL+WIN+F12 gets 5 copies for each video. Everything goes to clipboard

#if



;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;
;
; https://www.autohotkey.com/docs/Hotkeys.htm
; https://www.autohotkey.com/docs/KeyList.htm
;
; #	Win
; !	Alt
; ^	Control
; +	Shift
;
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
;
; Fancy Zones extension:
;    FancyZones for the 1/3 columns
;    FancyZones for the 1/6 corners + movement + resizing
;    AHK for the 1/2 sizes
;    AHK for the screen swap
;    AHK is also used to kill the start menu, and to customize the fancyzones shortcuts
;
; FancyZones/AHK shortcuts:
;    Win+Arrows: fancyzones  movement
;    Win+Alt: fancyzones grow
;    Win+Ctrl: AHK move between monitor
;    Win+Shift: AHK half size
;
; FancyZones mouse drag shortcuts:
;    shift: disable zones snapping
;    ctrl: grow zones
;    mouse double click: maximize window
;
;    Win+Numpad0: Cycles Maximize/restore
;    Win+NumpadDot: Minimize and lose focus
;
;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
;
;
; NOTEPAD++ shortcuts:
;    list of shortcuts: http://www.keyxl.com/aaacd5a/43/Notepad-Plus-text-editor-software-keyboard-shortcuts.htm
;    config file: %AppData%\Notepad++\shortcuts.xml
;
;    ctrl+L = cut line to clipboard
;    ctrl+V = paste line from clipboard
;    ctrl+D = duplicate paste line from clipboard
;    ctrl+; = add whole line above
;
;    CTRL+ALT+S: toggle spelling check
;    CTRL+SHIFT+U: uppercase
;
;    settings / auto completion
;    settings / language / tab settings
;
;
; Other global shortcuts:
;    Win+BackSpace: windows always on top
;    Shift+MouseWheel: folder history
;    CTRL+MouseWheel: Zoom
;    CTRL+R: show extensions
;
;    ` - solo track adobe audition
;
;    CTRL+` - mute track adobe audition
;
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
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
; AHK Maintenance:
;    CTRL+WIN+ALT+ESC = Emergency stop
;    CTRL+WIN+ALT+F11 = Debug mouse XY values (cycle)
;    CTRL+WIN+ALT+F12 = Reload/Restart this script
;               WIN+S = reload this script (shortcut)
;
;
;;;;;;; END
