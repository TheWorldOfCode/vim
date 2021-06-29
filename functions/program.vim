"
" Streamling the launching for programs when coding
"
"
" Version 0.1
"
" Current features
"   - Launch  a program in a terminal and control the configuration for the
"     terminal
"   - Easy displaying the terminal as a popup window
"   - Capable of select terminal to show
"   - Capable of hiden both popup windows and terminal windows
"   - Launch the program according to popup, window or external
"   - Notifying when the program ends
"   - Capable of removing finished terminals.
"
" Future 
"   - Simple interface
"   - Alert on message on std err. 

command! -nargs=* Terminal :call program#launch(<f-args>)
command! TerminalShow :call program#SelectTerminal("select") 
command! TerminalList :call program#SelectTerminal("view")
command! -nargs=* TerminalHide :call program#hide(<f-args>)
command! TerminalClean :call program#CloseFinishedTerminals()

" Configuration
" The default configuration of the terminal
"let g:launch_configuration = #{}
" If there should be used popup menus 
"let s:modes = ["popup", \"window\", \"extern\"]
"let g:launch_mode = "popup"
" If it should be started in hidden mode
"let g:launch_hidden = v:false
" How to start a new external terminal
"let g:launch_extern = "setsid " . $TERMINAL
" Notify on program exist
"let g:launch_notify = v:true
" Set the size on the terminal popup window
"let g:launch_popupsize = [50, 20]
" Script variables

" The win id of the current open popup window
let s:popup = -1 

" Default launching 
function! program#launch(program=$SHELL, title=a:program, configuration=#{})
    let l:mode = "popup"
    let l:hidden = v:false
    let l:configuration = a:configuration

    if exists("b:launch_mode")
        let l:mode = b:launch_mode
    elseif exists("g:launch_mode")
        let l:mode = g:launch_mode
    endif

    if exists("b:launch_hidden")
        let l:hidden = b:launch_hidden
    elseif exists("g:launch_hidden")
        let l:hidden = g:launch_hidden
    endif 

    if exists("b:launch_configuration")
        let l:configuration = b:launch_configuration
    elseif exists("g:launch_configuration")
        let l:configuration = g:launch_configuration
    endif 

    if exists("b:launch_notify")
        if b:launch_notify == v:true
            let l:configuration['exit_cb'] = "program#Notify_on_exists"
        endif
    elseif exists("g:launch_notify")
        if g:launch_notify == v:true
            let l:configuration['exit_cb'] = "program#Notify_on_exists"
        endif
    endif 

    let l:configuration["hidden"] = v:true
    if l:mode == "popup"
        let l:term = s:launchBase(a:program, a:title, l:configuration)
        if l:hidden == v:false
            call program#ShowTerminal(l:term)
        endif
    elseif l:mode == "window"
        let l:term = s:launchBase(a:program, a:title, l:configuration)
        if l:hidden == v:false
            call program#ShowTerminal(l:term)
        endif
    elseif l:mode == "extern"
        let l:program = g:launch_extern . " -e " . a:program
        if a:program == $SHELL
            let l:program = g:launch_extern . " " . a:program
        endif
        let l:term = s:launchBase(l:program, a:title, l:configuration)
    endif
endfunction

" The base of the launch of a program
function! s:launchBase(program, title, settings)
    let l:term_buf = term_start(a:program, a:settings)    
    call setbufvar(l:term_buf, "title", a:title)
    return l:term_buf
endfunction


" Show a terminal in a popup window
function! program#ShowTerminal(termbuf)
    let l:mode = "popup"
    let l:popup_size = [100, 30]

    if exists("b:launch_mode")
        let l:mode = b:launch_mode
    elseif exists("g:launch_mode")
        let l:mode = g:launch_mode
    endif

    if exists("b:launch_popupsize")
        let l:popup_size = b:launch_popupsize
    elseif exists("g:launch_popupsize")
        let l:popup_size = g:launch_popupsize
    endif

    if l:mode == "popup"

        let l:buf = str2nr(a:termbuf)
        let l:title = getbufvar(l:buf, "title")
        let s:popup = popup_create(l:buf, #{
                    \ pos: 'center',
                    \ title: l:title,
                    \ padding: [0, 1, 0, 1],
                    \ border: [1, 1, 1, 1],
                    \ borderchars:  ['-', '|', '-', '|', '┌', '┐', '┘', '└'],
                    \ minwidth: l:popup_size[0],
                    \ minheight: l:popup_size[1],
                    \ mapping: 0, 
                    \ highlight: "Normal"
                    \}) 
    elseif l:mode == "window"
        let l:buf = str2nr(a:termbuf)
        execute 'sbuffer ' .  l:buf
    endif 
endfunction

function! program#hide(...)
    let l:mode = "popup"

    if exists("b:launch_mode")
        let l:mode = b:launch_mode
    elseif exists("g:launch_mode")
        let l:mode = g:launch_mode
    endif
    
    if l:mode == "popup"
        call s:ClosePopup()
    elseif l:mode == "window"
        for l:bufnr in a:000
            let l:winids = win_findbuf(l:bufnr)
            for l:id in l:winids
                call win_execute(l:id, "hide")
            endfor
        endfor
    endif
endfunction

" Close popup window
function! s:ClosePopup()
    if s:popup != -1
        call popup_close(s:popup)
        let s:popup = -1
    else
        call popup_notification("No terminal window is open", #{pos: 'center'})
    endif
endfunction

" Close all finished terminals
function! program#CloseFinishedTerminals()
    let l:term_list = term_list()

    for l:t in l:term_list
        if term_getstatus(l:t) == "finished"
            execute l:t."bd"            
        endif
    endfor
endfunction

" Select terminal to work with
function! program#SelectTerminal(mode)
    let l:term_list = term_list()
    if len(l:term_list) > 0
        let l:list = []

        for l:t in l:term_list
            call add(l:list, l:t . " | " . getbufvar(l:t, "title") . " | " . term_getstatus(l:t) )
        endfor
        if a:mode == "select"
            let l:winid = popup_menu(l:list, #{title: "Terminals", callback: 'program#Terminal_display'})
            call win_execute(l:winid, "Tabularize /|")
        elseif a:mode == "view"
            let l:winid = popup_menu(l:list, #{title: "Terminals"})
            call win_execute(l:winid, "Tabularize /|")
        endif
    endif 
endfunction


" Popup callbacks
function! program#Terminal_display(winid, result)
    let buf = winbufnr(a:winid)
    let line = getbufline(buf, a:result)[0]
    let term_buf = split(line, "|")[0]
    call program#ShowTerminal(term_buf)
    return 1
endfunction

" Terminal callbacks 
function! program#Notify_on_exists(jobid, msg)
    let l:info = job_info(a:jobid)
    let l:buf = ch_getbufnr(l:info["channel"], "out")
    let l:title = getbufvar(l:buf, "title")
    let l:notify_msg = l:title . " is done (exit code " . l:info["exitval"] . ")"

    let l:configuration = #{pos: "center"}

    if str2nr(l:info["exitval"]) != 0
        let l:configuration["highlight"] = 'ErrorMsg'
    endif
    call popup_notification(l:notify_msg, l:configuration)
endfunction
