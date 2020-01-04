
function! SnapShot(dir, filename)
	let file=a:dir . a:filename . ".png"
	if !empty(glob(file))
		echom "The file exists already."
	else 
		silent execute '!gnome-screenshot -a -f ' file 
		put = '\begin{figure}[h]'
		put = '  \centering'
		put = '  \includegraphics[width=\textwidth]{' . file . '}'
		put = '\end{figure}'
	endif
endfunction


function! SetupSlides(slides, number)

	let i=1

	while i <= a:number

		put = '\begin{framed}'
		put = '\begin{figure}[H]'
		put = '\centering'
		put = '\includegraphics[width=\textwidth,page=' . i . '] {'. a:slides . '}'
		put = '\caption*{Page number ' . i. '}'
		put = '\end{figure}'
		put = '\end{framed}'
		put = ''
		put = ''
		put = '\newpage'

		put = ''
		put = ''
		let i += 1
	endwhile	  
endfunction
