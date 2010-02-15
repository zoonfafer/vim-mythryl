" Vim syntax file
" Language:     Mythryl
" Filenames:    *.api, *.pkg, *.my, *.mythryl
" Maintainer:   Jeffrey Lau <vim@NOSPAMjlau.tk>
" URL:          http://github.com/zoonfafer/vim-mythryl
" History:	2010 Feb 15 - attempt to start from scratch (JL)
"		2009 Oct 07 - attempt to create a syntax file (JL)


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Mythryl is case-sensitive
syn case match

" TODO: insert syntax stuff here


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_my_syntax_inits")
	if version < 508
		let did_my_syntax_inits = 1
		command -nargs=+ HL hi link <args>
	else
		command -nargs=+ HL hi def link <args>
	endif

	" TODO: insert highlighting stuff here
	HL myComment	Comment
	HL myError	Error

	delcommand HL
endif

let b:current_syntax = "mythryl"

" vim: ts=8
