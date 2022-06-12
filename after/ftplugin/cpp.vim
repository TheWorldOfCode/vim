" FILE: cpp.vim
" BRIEF: Custom settings for cpp files 
" DESCRIPTION: 
"       ++++
" CREATED: 21-01-2022
" VERSION: 0.1
" AUTHOR: TheWorldOfCode (Dan Nykjær Jakosen)
" EMAIL: dannj75@gmail.com
" SOFT DEPENDS: vim-lsp
"
" See the bottom for list for features

setlocal foldmethod=syntax

if !exists("s:loaded")
    " Local methods only loaded onces                                {{{ 2
    function! s:defineVariable(name, default)
        "                                                                {{{ 2
        if !exists(a:name)
            exec 'let ' . a:name . ' = ' . a:default
        endif 
        "                                                                }}}
    endfunction

    function! s:FindAssosiateFile(path, root)
        "                                                                {{{ 2
        let l:path = split(a:path, "/")
        let l:path[0] = a:root
        return join(l:path, "/")
        "                                                                }}}
    endfunction

    " Find the namespace and class or struct of a function
    " Returns a tuple, first element is a list names, second assosiate regions
    function! s:findNamespaceClassStruct(row)
        "                                                                {{{ 2

        let l:matches = []

        let l:match = search('\<struct\>\|\<namespace\>\|\<class\>', "bW")
        while l:match != 0
            call add(l:matches, l:match)
            let l:match = search('\<struct\>\|\<namespace\>\|\<class\>', "bW")
        endwhile

        let l:structure = []
        let l:regions = []

        for l:match in l:matches
            let l:line = split(getline(l:match), " ")

            call cursor(l:match, 0)
            normal! $
            let l:pair = searchpair("{", "", "}")

            if a:row < l:pair
                call add(l:structure, l:line[1])
                call add(l:regions, [l:match, l:pair])
            endif
        endfor

        return [reverse(l:structure), reverse(l:regions)]
        "                                                                }}}
    endfunction

    " gettype
    " Get if it is a function, variable, class, namespace, struct
    function s:gettype(line)
    "                                                       {{{ 2 
        let l:split = split(a:line, "\W\+")

        if l:split[0] in ["class", "namespace", "struct"]
            return l:split[0]
        endif

        if l:split[0] in ["public", "private", "protocted"]
            return 'invalid'
        endif
        
        let l:split = split(a:line, '=')

        if len(l:split) != 1
            return 'variable'
        endif

        let l:split = split(a:line, '(')

        if len(l:split) != 1
            return 'function'
        endif

        return 'variable'
    "                                                       }}} 
    endfunction

    " Constructue the function name
    function! s:createFuncName(struct, func_line)
        "                                                                {{{ 2
        let l:structure = join(a:struct, "::") . "::"
        let l:proto = split(a:func_line, " ")

        let l:index = 0

        while l:index < len(l:proto)
            if match(l:proto[l:index], "(") != -1
                let l:proto[l:index] = l:structure . l:proto[l:index]
                break
            endif
            let l:index = l:index + 1
        endwhile

        let l:function = join(l:proto, " ")

        return substitute(l:function, ";", "", "")
        "                                                                }}}
    endfunction

    " Get the function name
    function! s:getFuncName(func_line)
        "                                                                {{{ 2
        let l:proto = split(a:func_line, " ")

        let l:index = 0

        while l:index < len(l:proto)
            if match(l:proto[l:index], "(") != -1
                break
            endif
            let l:index = l:index + 1
        endwhile

        return split(l:proto[l:index], "(")[0]
        "                                                                }}}
    endfunction

    " Check if a function name already exists in a file
    function! s:checkIfFunctionExists(function)
        "                                                                {{{ 2
        normal gg

        let l:match = search(a:function, "W")

        while l:match > 0

            normal w
            let l:stack = synstack(l:match, getpos(".")[2])

            let l:flag = v:true
            for l:syn in l:stack
                if synIDattr(l:syn, "name") == "cBlock"
                    let l:flag = v:false
                    break
                endif
            endfor

            if l:flag
                return v:true
            endif
            let l:match = search(a:function, "W")

        endwhile


        return v:false
        "                                                                }}}
    endfunction

    " Move the prototype of a function from header to source file
    " Still missing order and handling overload
    " Overwrite exists functions doesn't work
    function! s:movePrototype(row)
        "                                                                   {{{ 2
        let [l:structure, l:regions] = s:findNamespaceClassStruct(a:row)
        let l:function = s:createFuncName(l:structure, getline(a:row))
        let l:funcName = s:getFuncName(getline(a:row))

        exec 'e ' . b:source

        if s:checkIfFunctionExists(l:funcName)
            if g:cpp_block == "oneline"
                call setline(line('.'), l:function . "{")
            else
                call setline(line('.'), l:function)
            endif
        else
            let l:end = line('$')

            if g:cpp_block == "oneline"
                call append(l:end, ["", l:function . " {", "", "}"])
                call cursor(l:end + 2, 0) 
            else
                call append(l:end, ["", l:function, "{", "", "}"])
                call cursor(l:end + 3, 0) 
            endif
        endif
        "                                                                   }}}
    endfunction

    " commentOut 
    "   Comment in and out lines. There is different if in visual-line or
    "   visual mode. 
    function! s:commentOut() range
        "                                               {{{ 2
        let l:start = getpos("'<")[1:2]
        let l:end = getpos("'>")[1:2]

        let l:syns = synstack(l:start[0], l:start[1])

        let l:flag = v:false
        let l:multi = v:false
        for l:syn in l:syns
            let l:name = synIDattr(l:syn, 'name')

            if l:name == "cComment"
                let l:flag = v:true
                let l:multi  = v:true
                break
            elseif l:name == "cCommentL"
                let l:flag = v:true
                break
            endif
        endfor

        if l:flag
            " Remove comment                                                {{{ 3
            if l:multi 
                " If multilined                                             {{{ 4
                let l:line = getline(l:start[0])
                if l:line[l:start[1]-1] == "/" && l:line[l:start[1]] == "*"
                    let l:line = split(l:line, '\zs')
                    call remove(l:line, l:start[1]- 1, l:start[1])
                    call setline(l:start[0], join(l:line, ""))
                else 
                    let l:line = split(l:line, '\zs')
                    call insert(l:line, "*/", l:start[1] - 1)
                    call setline(l:start[0], join(l:line, ""))
                endif
                unlet l:line
                let l:line = getline(l:end[0])
                if len(l:line) <= l:end[1] &&l:line[l:end[1]-3] == "*" && l:line[l:end[1]-2] == "/"
                    let l:line = split(l:line, '\zs')
                    call remove(l:line, l:end[1]- 3, l:end[1]-2)
                    call setline(l:end[0], join(l:line, ""))
                elseif l:line[l:end[1] - 5] == "*" && l:line[l:end[1] - 4] == "/"
                    let l:line = split(l:line, '\zs')
                    call remove(l:line, l:end[1] - 5, l:end[1] - 4)
                    call setline(l:end[0], join(l:line, ""))
                else 
                    let l:line = split(l:line, '\zs')
                    call insert(l:line, "/*", l:end[1] - 1)
                    call setline(l:end[0], join(l:line, ""))
                endif
                "                                                       }}} 
            else
                " If single lined                                           {{{ 4
                let l:line = l:start[0]
                while l:line != l:end[0] + 1
                    let l:text = getline(l:line)
                    let l:text = split(l:text, '\zs')
                    if l:text[0] == "/" && l:text[1] == "/"
                        call remove(l:text, 0, 1)
                    endif
                    call setline(l:line, join(l:text,""))
                    let l:line = l:line + 1
                endwhile
                "                                                       }}} 
            endif
            "                                                           }}}
        else
            " Insert comment                                            {{{ 3
            let l:mode = visualmode()

            if l:mode == "V"
                " Linewise-visual mode                                      {{{ 4
                let l:line = l:start[0]
                while l:line != l:end[0] + 1
                    let l:text = getline(l:line)
                    let l:text = split(l:text, '\zs')
                    call insert(l:text, "//", 0)
                    call setline(l:line, join(l:text,""))
                    let l:line = l:line + 1
                endwhile
                "                                                               }}}
            else
                " Visual mode                                               {{{ 4
                let l:flag = v:false
                let l:line = getline(l:start[0])
                let l:line = split(l:line, '\zs')
                call insert(l:line, "/*", l:start[1] - 1)
                call setline(l:start[0], join(l:line, ""))

                let l:line = getline(l:end[0])
                let l:line = split(l:line, '\zs')
                if l:end[1] + 1 >= len(l:line)
                    let l:line = l:line + ["*/"]
                else
                    let l:line = insert(l:line, "*/", l:end[1]+1)
                endif

                call setline(l:end[0], join(l:line, ""))
                "                                                               }}}
            endif
        "                                                               }}}
        endif
        "                                                                 }}}
    endfunction

    function! s:lspsetting() abort
        "                                                                   {{{ 2
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        setlocal foldmethod=expr
        setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
        setlocal foldtext=lsp#ui#vim#folding#foldtext()

        if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> gs <plug>(lsp-document-symbol-search)
        nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
        nmap <buffer> gr <plug>(lsp-references)
        nmap <buffer> gi <plug>(lsp-implementation)
        nmap <buffer> gt <plug>(lsp-type-definition)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
        nmap <buffer> [g <plug>(lsp-previous-diagnostic)
        nmap <buffer> ]g <plug>(lsp-next-diagnostic)
        nmap <buffer> K <plug>(lsp-hover)
        nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
        nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
        "                                                                   }}}
    endfunction
    " doxygen 
    " Insert doxygen template
    function! s:doxygen(line) abort
    "                                                                 {{{2
       set filetype=cpp.doxygen
       let l:line = getline(a:line) 
       let l:func_name = s:getFuncName(l:line)
       let l:doxygen = ['/** \fn ' . l:func_name]
       call add(l:doxygen, '* \brief TODO')
       call add(l:doxygen, "*")
       call add(l:doxygen, '* TODO (LONG DESCRIBTION)')
       call add(l:doxygen, '*')
       let l:params = split(split(l:line, "(")[1], ')')[0]


       for l:param in split(l:params, ',')
            call add(l:doxygen, '* @param ' . split(l:param, ' ')[-1] . " TODO")
       endfor

       call add(l:doxygen, "*/")
        
       echo l:doxygen
       let l:failed = append(a:line - 1, l:doxygen)
       echo l:failed
     "                                                                }}}
    endfunction
    "                                                                 }}}
endif

let s:loaded = v:true

call s:defineVariable("g:cpp_block", "\"oneline\"")

if expand("%:e") == "cpp"
    let b:header = s:FindAssosiateFile(expand("%:r"), "include") . ".h"

    exec 'command! -buffer CppHeader :e ' . b:header
    exec 'command! -buffer CppHeaderSplit :sp ' . b:header
    exec 'command! -buffer CppHeaderVSplit :vs ' . b:header
else
    let b:source = s:FindAssosiateFile(expand("%:r"), "src") . ".cpp"
    let b:source = "test.cpp"
    exec 'command! -buffer CppSource :e ' . b:source
    exec 'command! -buffer CppSourceSplit :sp ' . b:source
    exec 'command! -buffer CppSourceVSplit :vs ' . b:source
    command! -buffer CppProto call <SID>movePrototype(line('.'))

    nnoremap <leader>cp :CppProto<CR>
endif

if !exists('b:cpp_disable_deoxygen') || !exists('g:cpp_disable_deoxygen')

    command! -buffer CppDoxygen call <SID>doxygen(line('.'))
endif

" Commands
command! -buffer -range CppComment call <SID>commentOut()


" Mappings
xnoremap <leader>c :CppComment<CR>

" Autocommands                                                       {{{ 1
augroup lsp_install_cpp
    au! 
    autocmd User lsp_buffer_enabled call s:lspsetting() 
augroup END
"                                                                   }}}

" Current Features:
"   - Commands for switching between source and header files. 
"   - Detect if LSP server is registers 
"   - Commenting in and out lines and inline regions 
"
" Workering:
"   - Moving functions prototyping from header to source file. 
"   - Deoxygen documentation
"
" Planed Features:
"   -  
" vim:ts=4:sw=4:ai:foldmethod=marker:foldlevel=0
