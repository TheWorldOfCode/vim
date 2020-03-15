
function! SnapShot(dir, filename)
	let file=a:dir . a:filename . ".png"
	if !empty(glob(file))
		echom "The file exists already."
	else 
		silent execute '!gnome-screenshot -a -f ' file 
		put = '\begin{figure}[H]'
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


function! SetupSlides(slides)

        let l:number = system('pdfinfo ' . a:slides .  ' | grep Pages: | grep -Eo "[0-9]+"')

	let i=1

	while i <= l:number

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
