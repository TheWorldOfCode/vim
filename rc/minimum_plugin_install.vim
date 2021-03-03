call plug#begin('~/.vim/plugged')
Plug 'flazz/vim-colorschemes'

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsListSnippets = '<M-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltisnipsJumpBaskwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ["mysnippets"]

Plug 'vim-scripts/indentpython.vim'

Plug 'dense-analysis/ale'
"
" Allow to send lines to terminal 
Plug 'habamax/vim-sendtoterm' 

Plug 'vim-scripts/SyntaxRange'

" Allow creating tabels 
Plug 'godlygeek/tabular'

"Extension for syntax
Plug 'vim-syntastic/syntastic'

call plug#end()
