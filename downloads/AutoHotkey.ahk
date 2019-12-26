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


get_google_url(query){
  query := url_prepare_query(query)
  
	url := "http://www.google.com/search?q=" query
  return url
}

; gets the first youtube result for a string
open_google( query ){
	url := get_google_url(query)
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
  start = 1

  ;https://www.autohotkey.com/docs/commands/RegExMatch.htm
  Needle := "O)" . Needle

  ;debug_print_kv(debug, "finding Haystack", Haystack )
  debug_print_kv(debug, "finding needle", needle )

  loop
  {
    if(!RegexMatch(haystack, needle, M, start)){
        ;debug("stopped RegexMatch")
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
;     debug(i, m)


; query youtube and return an array with all the anwers
get_all_youtube_results_as_array( query, limit := 5 )
{
  debug := false

  ret := Array()
  text := query_youtube_as_html(query)

  ; debug(text)
  
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
   MsgBox, Soulseek not running
   return
  } 
  
  WinExist("ahk_exe SoulseekQt.exe")
  WinActivate
  Sleep, 200
  
  return get_active_window_id()
}

print( var )
{
  debug_print_kv(true, "Quick debug: ", var)
}

debug( var )
{
  debug_print_kv(true, "Quick debug: ", var)
}

debug_print( debug, var )
{
  global_do_debug := True
  ; global_do_debug := False
  
  if(global_do_debug){
    if(debug){
      MsgBox, %var%  
    }  
  }
}
 
 
 
debug_print_kv(debug, key, value){
  if(len(value) == 0 ){
    value = "<empty>"
  }
 
  global_do_debug := True
  ; global_do_debug := False
  
  if(global_do_debug){
    if(debug){
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

  
  
  
do_get_all_chrome_tab_url()
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
^#!F11:: XY_analyse_init()
^#!F12:: reload

^F8::   do_open_google()

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



