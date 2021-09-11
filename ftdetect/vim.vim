" Settings for editing vim script

command! -buffer AutoSource call s:AutoSource()



let g:AutoSource = 0
augroup VIM_SCRIPT
    au!
augroup END



function! s:AutoSource()
    if g:AutoSource == 0
        autocmd VIM_SCRIPT BufWritePost *.vim :source %
        let g:AutoSource = 1
    else
        autocmd! VIM_SCRIPT BufWritePost *.vim :source %
        let g:AutoSource = 0
    endif
endfunction
