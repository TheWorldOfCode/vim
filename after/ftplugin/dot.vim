
command! Compile exec '!dot -Tpdf ' . expand("%") . ' > ' . expand("%:r").'.pdf'
