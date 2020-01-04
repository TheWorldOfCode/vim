
function Pipe_exits(pipename)

	let test = system(' ls -l ' .  a:pipename .' | awk '{split($0,a," "); printf a[1] } ' | grep -c "p"')

	echo test

endfunction

function Pipe_write(pipename, msg)

       system('echo ' . a:msg . ' > ' . a:pipename . '')

endfunction


function Pipe_read(pipename)

	let msg = system('tail -n1 ' . a:pipename . '')

	echo msg

endfunction
