" A complete IDE for coding   (Standalone)
"
" Maintainer:	Dan Nykjær Jakobsen
" Last change:	2020 Jan 07
"

set encoding=utf-8 
set number " Show row number
set relativenumber " Show current row number and the others lines number is acount to current line
set wildmenu "command-line completion operates in an enhaced mode. auto-complete.
set wildmode=list "Completion mode that is used for the character specified with 'wildcar'. When more than one match list all matches. 
set laststatus=2 "Show always a status line. 

set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2


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
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

"set display=truncate    " Show @@@ in the last line if it is truncated.

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5



if has('cindent') && has('smartindent')
	set cindent    " Automatically indenting C style program files. (Java C++)
else 
	set autoindent " Copy indent from current line when starting a new line
endif


" Get the defaults that most users want.

" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Jun 13
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
	set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
set nocompatible
silent! endwhile

" Do incremental searching when it's possible to timeout.
if has('reltime')
	set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
	set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
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



" Plug In

call plug#begin('~/.vim/plugged')
Plug 'flazz/vim-colorschemes'

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsListSnippets = '<M-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltisnipsJumpBaskwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ["mysnippets"]

Plug 'vim-scripts/indentpython.vim'

Plug 'Valloric/YouCompleteMe'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_completion=1
map<leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'

Plug 'habamax/vim-sendtoterm' " Allow to send lines to terminal 

Plug 'godlygeek/tabular' " Aline things

Plug 'gilsondev/searchtasks.vim' " Search for TODO when developing 

Plug 'scrooloose/nerdtree' " NERDtree is a file system explorer
autocmd VimEnter,TabEnter * :NERDTree 



"Extension for syntax
Plug 'vim-syntastic/syntastic'

" Allow moving lines without deleting them 
Plug 'matze/vim-move'

Plug 'majutsushi/tagbar'
autocmd VimEnter,TabEnter * :Tagbar
call plug#end()

colorscheme happy_hacking

" Source vim scripts
source ~/.vim/functions/vim_setting.vim 


au BufEnter <buffer> call Vim_setting_set_in_file()
" Tab control
nmap <silent> <C-j> :tabprevious <CR>
nmap <silent> <C-k> :tabnext <CR>

" Source Status line
source ~/.vim/statusline.vim

" ROS settings
set shiftwidth=2  " Two space indents
set tabstop=2     " Tab key indents two spaces at a time
set expandtab     " Use spaces when the <Tab> key is pressed
set cindent       " Turn on automatic C-code indentation

