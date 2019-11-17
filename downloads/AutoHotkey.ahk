



; Ideas:
;   https://www.reddit.com/r/AutoHotkey/comments/7y4k8m/automatically_search_selected_text_in_youtube_and/
;   https://autohotkey.com/board/topic/51282-auto-copy-url/
;
; References:
;   https://www.autohotkey.com/docs/Hotkeys.htm
;   https://www.autohotkey.com/docs/FAQ.htm
;   https://www.autohotkey.com/docs/Tutorial.htm
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



#SingleInstance force


; Find correct bash.exe file
bash_exe = %A_WinDir%\sysnative\bash.exe
if (!FileExist(bash_exe)) {
    bash_exe = %A_WinDir%\system32\bash.exe
} if (!FileExist(bash_exe)) {
    MsgBox, 0x10, , WSL(Windows Subsystem for Linux) must be installed.
    ExitApp, 1
}


;;;
;;; Functions
;;;

; gets the first youtube result for a string
open_google( query ){
	StringReplace, query, query, %A_Space%, +, All
	url := "http://www.google.com/search?q=" query
  Run % url
}


; returns the first youtube result for a string
search_youtube( query ){
	StringReplace, query, query, %A_Space%, +, All
	url := "https://www.youtube.com/results?search_query=" query
	Run % url
}


; returns the first youtube result for a string
first_youtube_result( query ){
	StringReplace, query, query, %A_Space%, +, All
	url := "https://www.youtube.com/results?search_query=" query
	r := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	r.Open("GET", url, true)
	r.Send()
	r.WaitForResponse()

	if RegExMatch( r.ResponseText, "/watch\?v=.{11}", match )
		url := "https://www.youtube.com" match
	return url
}


audible_beep(){
  SoundBeep, 5000, 100

}

debug_audible_beep(){
  ;SoundBeep, 7000, 100

}

audible_beep()

debug( var ){
  do_debug := True
  ; do_debug := False
  
  if do_debug
    MsgBox, Debug: %var%  

}





; get the current window's handle
remember_current_window(){
  global current_ID

  WinGet, current_ID, ID, A
}


; activate the previous window
return_current_window(){
  global current_ID

  audible_beep()
	WinActivate ahk_id %current_ID%
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


copy_to_clipboard(){
  clipboard =   ; Start off empty to allow ClipWait to detect when the text has arrived.
  Send ^c
  ClipWait      ; Wait for the clipboard to contain text.
  
  ; MsgBox "CTRL-C copied this to the clipboard:`n`n" %clipboard% 

  return clipboard
}


get_chrome_url(){
  Send ^l       ;gives focus to the URL
  
  clipboard := copy_to_clipboard()
  
  return clipboard
}


;;;
;;; ShortCut Keys
;;;



;
; CTRL+F08: Search in Google
;
; CTRL+F09: search in Explorer
; CTRL+F10: current url to clipboard
; CTRL+F11: search in Youtube (list)
; CTRL+F12: search in Youtube (first hit)
;



; CTRL+F08: search in Google
^F8::
	debug_audible_beep()
  query := copy_to_clipboard()
  open_google( query )
  return



; CTRL+F9: search in Explorer      
^F9::
	debug_audible_beep()
  query := copy_to_clipboard()
  find_in_explorer(query)
  return

  
; CTRL+F10: current url to clipboard
^F10::
  debug_audible_beep()
  url := get_chrome_url()
  
  ; https://github.com/goreliu/wsl-terminal/blob/master/src/open-wsl.ahk
  ; debug("bash found at: " %bash_exe% )
  ; Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
  ; Run, "%bash_exe%" -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause' 
  ; ShellRun("C:\vim\vim80\gvim.exe", "+SLoad", "", "", 3)
  ; run, bash.exe -c 'source ${HOME}/.bashrc.pestrela ; cd ${HOME}/links/youtube-dl; youtube_dl.sh %url% ; pause'
  ;run, C:\windows\system32\bash.exe    ;  -c 'echo ola '
  return
  
  
; CTRL+F11: search in Youtube (list)
^F11::
	debug_audible_beep()
  
  query := copy_to_clipboard()
  search_youtube(query)
  
  return

  

; CTRL+F12: search in Youtube (first hit)
^F12::
	debug_audible_beep()
  
  query := copy_to_clipboard()
	url := first_youtube_result( query )
	Run % url
  
  return


