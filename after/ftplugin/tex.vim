
:so ~/.vim/functions/LaTeX_functions.vim

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_complete_enabled=1
let g:vimtex_compiler_latexmk = {
			\ 'backend' : 'jobs',
			\ 'background' : 1,
			\ 'build_dir' : './build',
			\ 'callback' : 1,
			\ 'continuous' : 1,
			\ 'executable' : 'latexmk',
			\ 'options' : [
			\   '--verbose',
			\   '--file-line-error',
			\   '--synctex=1',
			\   '--interaction=nonstopmode',
			\   '--shell-escape',
                        \   '--bibtex',
			\ ],
			\}

inoremap <buffer> <C-D> <Esc> <b>: call SnapShot("./figures/", getline(".")) <CR><CR> <C-l>
nnoremap <buffer> <C-D> <b> : silent exec !gnome-screenshot -a -f getcwd . "/figures/" . getline(".")
inoremap <buffer> <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w
nnoremap <buffer> <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
    


