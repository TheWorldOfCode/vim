
:so ~/.vim/functions/LaTeX_functions.vim


inoremap <buffer> <C-D> <Esc> <b>: call SnapShot("./figures/", getline(".")) <CR><CR> <C-l>
nnoremap <buffer> <C-D> <b> : silent exec !maimpick getcwd . "/figures/" . getline(".")
inoremap <buffer> <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w
nnoremap <buffer> <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
    


