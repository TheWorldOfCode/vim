" This setup the different plug ins 
call plug#begin('~/.vim/plugged')
Plug 'flazz/vim-colorschemes'

" 
Plug 'lervag/vimtex', {'for': 'tex'}
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:livepreview_previewer = 'zathura'
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

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsListSnippets = '<M-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltisnipsJumpBaskwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ["mysnippets"]

Plug 'vim-scripts/indentpython.vim'

Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

" Autocompletion
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

" Linting 
Plug 'dense-analysis/ale'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"Plug 'Valloric/YouCompleteMe'
" Specify which keys to use
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

" Close the window automatically
"let g:ycm_autoclose_preview_window_after_completion=1
" Go to the Definition of item under the cursor
"map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
"  let g:ycm_filetype_blacklist = {
"        \ 'tagbar': 1,
"        \ 'notes': 1,
"        \ 'markdown': 1,
"        \ 'netrw': 1,
"        \ 'unite': 1,
"        \ 'text': 1,
"        \ 'vimwiki': 1,
"        \ 'pandoc': 1,
"        \ 'infolog': 1,
"        \ 'leaderf': 1,
"        \ 'mail': 1,
"        \ 'tex': 1,
"        \}
"let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
" What python version the ycm are compiled with
"let g:ycm_server_python_interpreter = '/usr/bin/python3'

" Grammar 
Plug 'rhysd/vim-grammarous', {'for': 'tex'}

" Allow to send lines to terminal 
Plug 'habamax/vim-sendtoterm' 

" Markdown (used for slides in vim)
Plug 'tpope/vim-markdown'
let g:markdown_minlines = 100

Plug 'vim-scripts/SyntaxRange'

" Allow creating tabels 
Plug 'godlygeek/tabular'

"Extension for syntax
Plug 'vim-syntastic/syntastic'

" Common externsible interface for searching and displaying 
" lists of information.
Plug 'Shougo/denite.nvim'

" Auto Close
"Plug 'Townk/vim-autoclose'

Plug 'haya14busa/vim-gtrans'

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]

" R Studio
Plug 'jalvesaq/Nvim-R'

" Jupyter notebook requires notedown pip install notedown
"Plug 'szymonmaszke/vimpyter' 

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
Plug 'puremourning/vimspector'
let g:vimspector_base_dir=expand( '$HOME/.vim/vimspector-config' )

let check = system('python -c "import dokuwikixmlrpc"')
if shell_error == 0
    Plug 'TheWorldOfCode/dokuvimki'
    let g:DokuVimKi_USER = 'admin'
    let g:DokuVimKi_PASS_EVAL = 'pass browser/theworldofcode/wiki'
    let g:DokuVimKi_URL = 'https://wiki.theworldofcode.dk'
endif
unlet check

call plug#end()
