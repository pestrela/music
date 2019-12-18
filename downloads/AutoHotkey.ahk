;
; AutoHotKey file for DJs
; Created by DJ Estrela, 2019
;
;
; User Commmands:
;   CTRL+F08: Search in Google
;
;   CTRL+F09: search text in File Explorer
;   CTRL+F10: search text in soulseek
;   CTRL+F11: search text in Youtube (list)
;   CTRL+F12: search text in Youtube (first hit)
;   
;   CTRL+ALT+F11: send chrome url to clipboard  (ALL)
;   CTRL+ALT+F12: send chrome url to clipboard
;
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
; Ideas:
;   https://www.reddit.com/r/AutoHotkey/comments/7y4k8m/automatically_search_selected_text_in_youtube_and/
;   https://autohotkey.com/board/topic/51282-auto-copy-url/
;
; References:
;   https://www.autohotkey.com/docs/Hotkeys.htm
;   https://www.autohotkey.com/docs/FAQ.htm
;   https://www.autohotkey.com/docs/Tutorial.htm
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
; Ideas:
;   https://superuser.com/questions/1203029/wsl-trailing-whitespaces-being-added-to-bash-code-pasted-into-cmd-wsl-tty-per

;
; cant live little programs:  https://www.neogaf.com/threads/some-of-my-cant-live-without-progams-what-are-yours.1482889/
;  Clipboard History Lite - 10 clipbaord with caps lock
;  Everything for windows file search
;  Link Clump - Chrome Extension - Open Multiple Links with "Z" key
;
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
;;; Functions
;;;

strip(String, OmitChars := " `t"){
  return Trim(String, OmitChars)
}

len(String){
  return StrLen(String)
}


; removes all special characters, makes lowercase, keeps "\n" for breaking lines later
normalize_query( query ){
  StringLower, query, query
  StringReplace, query, query, `r`n, `n, All   ; support both windows and unix text
  
  query := RegExReplace(query, "[^a-z0-9\n]", " ")
  query := strip(query)
  
  return query
}

; cleans 
prepare_query( query ){
  ; query := "Layo & Bushwa2cka*	Lo4ve 4"
  
  query := normalize_query(query)
  query := StrReplace(query, " ", "+")
  
  return query
}


get_google_url(query){
  query := prepare_query(query)
  
	url := "http://www.google.com/search?q=" query
  return url
}

; gets the first youtube result for a string
open_google( query ){
	url := get_google_url(query)
  Run % url
}


get_youtube_url(query){
  query := prepare_query( query )
	url := "https://www.youtube.com/results?search_query=" query

  return url
}

; returns the first youtube result for a string
all_youtube_results( query ){
	url := get_youtube_url(query)

	Run % url
}





; returns the first youtube result for a string
first_youtube_result( query ){
  url := 	get_youtube_url(query)

  ;MsgBox, %url%
  ;return
  
  
	r := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	r.Open("GET", url, true)
	r.Send()
	r.WaitForResponse()

	if RegExMatch( r.ResponseText, "/watch\?v=.{11}", match )
		url := "https://www.youtube.com" match
	return url
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


debug( var ){
  do_debug := True
  ; do_debug := False
  
  if do_debug
    MsgBox, Debug: %var%  

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

  beep()
  set_active_window_id(previous_state_window_ID)

  CoordMode, Mouse, screen
  mouse_move(previous_state_mouse_x, previous_state_mouse_y)

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
  
  Send, ^e
  Sleep, 50
  
  send, ^a
  sleep, 50
  
  SendInput, %query%
  sleep, 50
  
  SendInput, {enter}
  
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


debug_XY_init(){
  global debug_XY_coord
  
  beep()
  
  if(debug_XY_coord == "window"){
    debug_XY_coord := "none"
    SetTimer, debug_XY_timer, OFF
    ToolTip, 
    return
  } else if(debug_XY_coord == "screen"){
    debug_XY_coord := "window"
  } else {
    debug_XY_coord := "screen"
  }
   
  SetTimer, debug_XY_timer, 100
}


debug_XY_timer(){
  global debug_XY_coord
  
  CoordMode, ToolTip, %debug_XY_coord%
  CoordMode, Pixel, %debug_XY_coord%
  CoordMode, Mouse, %debug_XY_coord%
  CoordMode, Caret, %debug_XY_coord%
  CoordMode, Menu, %debug_XY_coord%

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
   MsgBox, Soulseek not running
   return
  } 
  
  WinExist("ahk_exe SoulseekQt.exe")
  WinActivate
  Sleep, 200
  
  return get_active_window_id()
}

 
debug_show_msgbox(key, value){
  if(len(value) == 0 ){
    value = "<empty>"
  }
  
  msgbox, %key% = |%value%|
}


mouse_move(win_x, win_y){
  ;velocity := 10
  velocity := 0
  
  MouseMove, %win_x%, %win_y%, %velocity%
  sleep 50
}


mouse_click(win_x, win_y){
  mouse_move(win_x, win_y)
  click
  sleep 200
}

do_soulseek_one_query(query){
  set_clipboard(query)
  
  CoordMode, Mouse, window
  slsk_activate()
  
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


do_soulseek(){
  debug_beep()
  
  
  do_debug := 0
  if not do_debug {
    ; get from selection
    query := copy_selection_to_clipboard()
    
  } else {
    ; send a static debug text
    
    query := "superchumbo missy"
    set_clipboard(query)
  }
  
  if(query == ""){
    return
  }
  
    
  remember_previous_state()

  query := normalize_query( query )
  
  count := 0
  Loop, Parse, query, `n, `r
  {
		index := A_Index
    line := A_LoopField
    
    line := strip(line)
    
    ; debug_show_msgbox("line", line)
    
    if(len(line)){
      ;debug_show_msgbox("will search:", line)
      
      do_soulseek_one_query(line)
      count := count + 1
    }
  }
  
  ;msgbox, "Final count is: " %count%
  
  if(count <= 1)
    return_to_previous_state()
    
  beep()
}


; Find correct bash.exe file
get_bash_exe(){
  bash_exe = %A_WinDir%\sysnative\bash.exe
  if (!FileExist(bash_exe)) {
      bash_exe = %A_WinDir%\system32\bash.exe
  } if (!FileExist(bash_exe)) {
      MsgBox, 0x10, , WSL(Windows Subsystem for Linux) must be installed.
      ExitApp, 1
  }
  return bash_exe
}


do_open_google(){
	debug_beep()
  query := copy_selection_to_clipboard()
  if(query == "")
    return
  
  open_google( query )
  return
}  

do_find_explorer(){
	debug_beep()
  query := copy_selection_to_clipboard()
  if(query == "")
    return
    
  find_in_explorer(query)
}
  
do_get_chrome_url()
{
  debug_beep()
  
  url := get_chrome_url()
  if(url == "")
    return
  
  ; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
  ; debug("bash found at: " %bash_exe% )
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
  
  
array_to_ml(arr)
{
  ret := ""
  For k, v In arr
  {
    ret .= v "`n"
  
  } 
  
  return ret
}  
  
  
do_get_all_chrome_url()
{
  beep()
  
  if(not is_chrome_active())
    return
  
  ClipSave := Clipboard
  Clipboard = ; empty clipboard
  url_list := []
  
  first_url := ""
  pass := 1
  url := ""
  
  
  
  Loop
  {
    url := get_chrome_url()
 
    if (url == first_url){
        break
     }
     if A_Index = 1
        first_url := url
        
    url_list.push(url)
    Send, ^{tab}
    
  }
  ; Clipboard := ClipSave
  ; MsgBox % array_to_ml(url_list)
  Clipboard := array_to_ml(url_list)
}




  
  
do_open_several_urls(list)
{  
  ; Untested

  ClipSaved := ClipboardAll
  Clipboard =
  Send ^c
  Clipwait, 2
  Loop, parse, Clipboard, `n, `r
  {
    StringSplit, LinksIssue, A_LoopField, :
    If (LinksIssue1 <> "http" && LinksIssue1 <> "ftp" && LinksIssue1 <> "https")
      Links := "http://" . A_LoopField
    else
      Links := A_LoopField
    Run, %Links%
  }
  Clipboard := ClipSaved
}

  
  
do_search_youtube_list(){
	debug_beep()
  
  query := copy_selection_to_clipboard()
  if(query == "")
    return

  all_youtube_results(query)
}
  
  
do_search_youtube_first(){
	debug_beep()
  
  query := copy_selection_to_clipboard()
  if(query == "")
    return
  
	url := first_youtube_result( query )
	Run % url
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
  

init_beep()              ; Signal that we finished autoexec section

;;;
;;; To change shortcuts: https://www.autohotkey.com/docs/Hotkeys.htm
;;;
;;; #	Win
;;; !	Alt
;;; ^	Control
;;; +	Shift
;;;


^#!esc:: exitapp
^#!F11:: debug_XY_init()
^#!F12:: reload

^F8::   do_open_google()

^F9::   do_find_explorer()
^F10::  do_soulseek()  
^F11::  do_search_youtube_list()
^F12::  do_search_youtube_first()
	  
^!F11:: do_get_all_chrome_url()
^!F12:: do_get_chrome_url()


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



