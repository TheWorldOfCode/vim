"
" This script provides support for docker container 
"

" Commands add by the script
command! -nargs=+ DockerAdd call s:docker_add(<f-args>) " Add a container {container_id} [, {image}, {workdir}, {options}]
command! -nargs=1 DockerRemove call s:docker_remove(<args>)
command! DockerList call s:docker_list()
command! DockerSelect call s:docker_select()

" script variables
let s:container_ids = [] " The list of add containers

"
" Add a container to list of available containers
"
" Parameter
" ----------
"  container_id The id of the container either the name or the uuid
"  image        The image of the container
"  workdir      The work directory in the container
"  options      The options for creating the constainer
"
function! s:docker_add(...)
    let l:container_id = a:1
    let l:image = get(a:, 2, "")
    let l:workdir = get(a:, 3, "")
    let l:options = get(a:, 4, "")
    call add(s:container_ids, [l:container_id, l:image, l:workdir, l:options])
endfunction


"
" Remove a container to list of available containers
"
" Parameter
" ----------
"  container_id The id of the container either the name or the uuid
"
function! s:docker_remove(container_id)
    let l:idx = 0
    let l:remove = []
    for l:items in s:container_ids
        for l:item in l:items
           if l:item == a:container_id 
               call add(l:remove, l:idx)
               break
           endif
        endfor
        let l:idx += 1
    endfor

    for l:i in l:remove
        call remove(s:container_ids, l:i)
    endfor
endfunction
 
"
" List added containers 
"
function! s:docker_list()
    if len(s:container_ids) > 0
        let l:list = ["idx | id/name | image | workdir | options"]
        let l:idx = 0

        for l:item in s:container_ids
            call add(l:list, l:idx . " | " . join(l:item, " | ")) 
            let l:idx += 1
        endfor

        let winid = popup_dialog(l:list, #{title: "Docker containers", filter: 'Docker_popup_press_key'})
        call win_execute(winid, "Tabularize /|")
    else
        call popup_notification("No containers is added", #{title: "Docker containers", pos: "center" })
    endif
endfunction

"
" Select an active container
"
function! s:docker_select()
    if len(s:container_ids) > 0
        let l:list = ["idx | id/name | image | workdir | options"]
        let l:idx = 0

        for l:item in s:container_ids
            call add(l:list, l:idx . " | " . join(l:item, " | ")) 
            let l:idx += 1
        endfor

        let winid = popup_menu(l:list, #{title: "Docker containers", callback: 'Docker_popup_select_callback'})
        call win_execute(winid, "Tabularize /|")
    else
        call popup_notification("No containers is added", #{title: "Docker containers", pos: "center" })
    endif
endfunction

"
" A simple filter function for popup windows which close at any key
"
function! Docker_popup_press_key(id, key)
    call popup_close(a:id)
    return 1
endfunction

function! Docker_popup_select_callback(id, result)

endfunction

function! Docker_popup_select_filter(id, key)

    return popup_filter_menu(a:id, a:key)
endfunction
