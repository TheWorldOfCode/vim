

function Vim_setting_set_in_file()

	let cursor_position = getcurpos()  " Save the current cursor position
	call setpos('.', [0, 1, 1, 0])     " Move to the top for the file

	let settings_line_number = search("VIMSETTING")  " Find the line containing the settings

	if settings_line_number != 0 

		let settings = getline(''.settings_line_number.'') " Get the line
		let settingList = split(settings, 'VIMSETTING\zs') " Split the lige so the VIMSETTING isn't used

		if len(settingList) > 1

			let settingList = split(settingList[1], ',,,')     " Split with the delimitet

			for c in settingList 
				" Execute all the commands
				execute c           
			endfor

		endif
	endif

	call setpos('.', cursor_position) " Restore the cursor position
endfunction
