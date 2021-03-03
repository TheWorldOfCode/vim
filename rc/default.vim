
" An example for a vimrc file.
"
" Maintainer:	Dan Nykjær Jakobsen
" Last change:	2020 Jan 06
"
set encoding=utf-8 
set number " Show row number
set relativenumber " Show current row number and the others lines number is acount to current line
set wildmenu "command-line completion operates in an enhaced mode. auto-complete.
set wildmode=list "Completion mode that is used for the character specified with 'wildcar'. When more than one match list all matches. 
set laststatus=2 "Show always a status line. 

if isdirectory("/tmp/vimbackup") == 0                       " Checking if the backup directory is created
    echo "Creating backup directory in /tmp/vimbackup"      
    " Info that the backup directory is created
    execute  '!mkdir /tmp/vimbackup'  
    " Utiliser shell functionalty to create the folder.
endif

set backupdir=/tmp/vimbackup/ " Setting the Backup directory 

set backspace=indent,eol,start " Allow backspacing over everything in insert mode.
set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

set ttimeout		" time out for key codes
set ttimeoutlen=50	" wait up to 50ms after Esc for special key

set display=truncate    " Show @@@ in the last line if it is truncated.

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5
" Allow mode line in the top and bottom of the documnet. 
set modeline

" Allow it to look into the dictionary when spelling is on 
set complete+=kspell

set exrc

" My own adding 
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

"Deoplete asynchronous completion framework for neovim/vim8
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'dense-analysis/ale'
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

call plug#end()

" Use ALE and also some plugin 'foobar' as completion sources for all code.
call deoplete#custom#option('sources', {
 \ '_': ['ale'],
 \})

colorscheme darkglass

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
set nocompatible

set incsearch
" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so
" that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
    " Revert with ":syntax off".
    syntax on

    " I like highlighting strings inside C comments.
    " Revert with ":unlet c_comment_strings".
    let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    " Revert with ":filetype off".
    filetype plugin indent on

    " Put these in an autocmd group, so that you can revert them with:
    " ":augroup vimStartup | au! | augroup END"
    augroup vimStartup
        au!

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid, when inside an event handler
        " (happens when dropping a file on gvim) and for a commit message (it's
        " likely a different one than last time).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                    \ |   exe "normal! g`\""
                    \ | endif

    augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If set (default), this may break plugins (but it's backward
    " compatible).
    set nolangremap
endif
" Defaults setting done
if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file (restore to previous version)
    if has('persistent_undo')
        set undofile	" keep an undo file (undo changes after closing)
    endif
endif

if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
    packadd! matchit
endif 

set tabstop=4
set softtabstop=4
set shiftwidth=4
"set textwidth=79
set expandtab
set autoindent
set fileformat=unix

highlight BadWhitespace ctermfg=0 ctermbg=226
au BufNewFile,BufRead *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


" Tab control
nmap <silent> <C-j> :tabprevious <CR>
nmap <silent> <C-k> :tabnext <CR>

" Source Status line
source ~/.vim/statusline.vim

" Fixing Keys
if &term  == "st-256color"
    " Left 
    imap <ESC>OD <ESC>hi
    " Right 
    imap <ESC>OC <ESC>lli
    " Up 
    imap <ESC>OA <ESC>ki
    " Down 
    imap <ESC>OB <ESC>ji
endif 


