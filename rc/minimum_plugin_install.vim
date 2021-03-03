call plug#begin('~/.vim/plugged')
Plug 'flazz/vim-colorschemes'

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
"
" Allow to send lines to terminal 
Plug 'habamax/vim-sendtoterm' 

Plug 'vim-scripts/SyntaxRange'

" Allow creating tabels 
Plug 'godlygeek/tabular'

"Extension for syntax
Plug 'vim-syntastic/syntastic'

" Common externsible interface for searching and displaying 
" lists of information.
Plug 'Shougo/denite.nvim'


call plug#end()
