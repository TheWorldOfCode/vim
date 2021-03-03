
source ~/.vim/functions/git.vim

function! Local_sourced()
    if exists("g:sourced_local_vimrc")
        return 'L' 
    endif
    return ''
    
endfunction
" Creating my own status line
set statusline =  

set statusline+=%{Git_statusline_current_branch()}  
set statusline+=%#LineNr#
set statusline+=%f  "File path
set statusline+=%m "Modified flag	
set statusline+=%r "Read only flag. 
set statusline+=%h "help buffer flag.
set statusline+=%w "Preview window flag
set statusline+=%y "Type of file
set statusline+=%= "Moving the cursor the the other side
set statusline+=\ %{Local_sourced()} 
set statusline+=\ Buf:%n "buffer number
set statusline+=\ %{Git_statusline_file_tracked()}
set statusline+=\ %l:%c " Line number:Column number
set statusline+=\ %p%% "Pecentage through file
