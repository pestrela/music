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

; removes all special characters, makes lowercase
normalize_query( query ){
  StringLower, query, query
  query := RegExReplace(query, "[^a-z0-9]", " ")

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
remember_current_window(){
  global current_ID

  current_ID := get_active_window_id()
  
  return current_ID
}


; activate the previous window
return_current_window(){
  global current_ID

  beep()
  set_active_window_id(current_ID)
}
  

find_in_explorer( query ){
	remember_current_window()
  
  if WinExist("ahk_class ExploreWClass") or WinExist("ahk_class CabinetWClass")
     WinActivate
  else
     Send, #e
     Sleep, 400
       
  Send, ^1
  Sleep, 400 

  Send, ^f
  Sleep, 400
  
  SendInput, %query%
  
  return_current_window()
}


set_clipboard(text){
  clipboard = %text%
  ClipWait      ; Wait for the clipboard to contain text.
  return 
}

copy_to_clipboard(){
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

  clipboard := normalize_query(clipboard)
  
  return clipboard
}


get_chrome_url(){
  Send ^l       ;gives focus to the URL
  
  clipboard := copy_to_clipboard()
  
  return clipboard
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

 

mouse_move(win_x, win_y){
  ;velocity := 10
  velocity := 0
  
  MouseMove, %win_x%, %win_y%, %velocity%
}


mouse_click(win_x, win_y){
  mouse_move(win_x, win_y)
  click
}

do_soul_seek(){
  debug_beep()
  
  do_debug := 0
  if not do_debug {
    ; get from selection
    query := copy_to_clipboard()
    
  } else {
    ; send a static debug text
    
    query := "superchumbo missy"
    set_clipboard(query)
  }
  
  if(query == ""){
    return
  }
  
  CoordMode, Mouse, window
  remember_current_window()
  slsk_activate()
  
  ; "search" tab
  mouse_click(264, 83)
  
  ; "search" box
  mouse_click(94, 156)
  
  Send, ^a
  sleep 100  
  Send, ^v 
  
  ; "search" button
  mouse_click(710, 158)
  
  ; return_current_window()
  beep()
  
  ; test_msg := "paul van dyk   superchumbo" 
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
  query := copy_to_clipboard()
  if(query == "")
    return
  
  open_google( query )
  return
}  

do_find_explorer(){
	debug_beep()
  query := copy_to_clipboard()
  if(query == "")
    return
    
  find_in_explorer(query)
}
  
do_get_chrome_url(){
  debug_beep()
  
  url := get_chrome_url()
  if(url == "")
    return
  
  ; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
  ; debug("bash found at: " %bash_exe% )
  ; Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
  ; Run, "%bash_exe%" -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause' 
  ; ShellRun("C:\vim\vim80\gvim.exe", "+SLoad", "", "", 3)
  ; run, bash.exe -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause'
  ;run, C:\windows\system32\bash.exe    ;  -c 'echo ola '
}  
  
do_search_youtube_list(){
	debug_beep()
  
  query := copy_to_clipboard()
  if(query == "")
    return

  all_youtube_results(query)
}
  
do_search_youtube_first(){
	debug_beep()
  
  query := copy_to_clipboard()
  if(query == "")
    return
  
	url := first_youtube_result( query )
	Run % url
}
  
  

;;;
;;;  AutoExec Actions
;;;

#SingleInstance force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Recommended for catching common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, window
bash_exe := get_bash_exe()
debug_XY_coord := "none"

init_beep()              ; Final autoexec beep

;;;
;;; ShortCuts Definition
;;;
;;; To change shortcuts: https://www.autohotkey.com/docs/Hotkeys.htm
;;;

;
; User commmands:
;   CTRL+F08: Search in Google
;
;   CTRL+F09: search in Explorer
;   CTRL+F10: current url to clipboard
;   CTRL+F11: search in Youtube (list)
;   CTRL+F12: search in Youtube (first hit)
;   
;   CTRL+ALT+F11: search in youtube-dl
;   CTRL+ALT+F12: search in soulseek
;
;
; Maintenance:  
;   CTRL+WIN+ALT+ESC = emergency stop
;   CTRL+WIN+ALT+F11 = cycle XY values
;   CTRL+WIN+ALT+F12 = reload/restart this script
;


^#!esc:: exitapp
^#!F11:: debug_XY_init()
^#!F12:: reload


^!F12:: do_get_chrome_url()
  

; CTRL+F08: search in Google
^F8::  do_open_google()
	
; CTRL+F9: search in Explorer      
^F9::  do_find_explorer()
  
; CTRL+F10: current url to clipboard
^F10:: do_soul_seek()  
  
; CTRL+F11: search in Youtube (list)
^F11::  do_search_youtube_list()
  
; CTRL+F12: search in Youtube (first hit)
^F12::   do_search_youtube_first()
	  
