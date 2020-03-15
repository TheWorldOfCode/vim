
" Used plugging to LaTeX and setting
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
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
			\   '-verbose',
			\   '-file-line-error',
			\   '-synctex=1',
			\   '-interaction=nonstopmode',
			\   '-shell-escape',
			\ ],
			\}

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsListSnippets = '<M-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltisnipsJumpBaskwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ["mysnippets"]

Plug 'Valloric/YouCompleteMe'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_completion=1
map<leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'

call plug#end()



" Spelling 
set spell " Actice spelling

set spelllang= " Set language 
