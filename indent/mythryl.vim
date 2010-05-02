" Vim indent file
" Language:	Mythryl
" Maintainer:	Jeffrey Lau <vim@NOSPAMjlau.tk>
" Last Change:	2010 May 02 (<- most likely out-dated)
" Remark:	included by the Mythryl-script indent file
"
" Script Type:	indent
" URL:		http://github.com/zoonfafer/vim-mythryl
"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetMythrylIndent()

" trigger indent when the following syntax elements are typed:-
setlocal indentkeys ==if,=elif,=else,=fi
setlocal indentkeys+==case,=esac
setlocal indentkeys+==for,=fun,=fn,=end
setlocal indentkeys+==herein
setlocal indentkeys+=={,=},=(,=),=[,=]

" trigger indent when you hit "o" or "O" in normal-mode:-
setlocal indentkeys +=o,O

" trigger indent when you hit <c-f>:-
setlocal indentkeys +=!^F

setlocal comments =sn1:/*,mb:*,ex:*/,b:#
setlocal comments+=fb:- " might be useful...

setlocal noexpandtab
setlocal formatoptions+=croqwn
setlocal formatoptions-=t
setlocal nosmartindent
setlocal textwidth=78
setlocal shiftwidth=4
setlocal softtabstop=4

if exists("*GetMythrylIndent")
	finish
endif

" Bad Ideas:
" inoremap <silent> { {   
" inoremap <silent> if if   


"==============================================================
" URL:	http://mythryl.org/my-Indentation.html
"  1) Indent four blanks per nested scope, with the following exceptions:
"  2)  * Indent multi-line case statement bodies five blanks.
"  3)  * Indent multi-line if statement conditions and bodies five blanks.
"  4)  * Indent multi-line tuple and record contents two blanks, to distinguish them from code. 
"--------------------------------------------------------------


function! GetMythrylIndent(...)

	" Get current line's content.
	let this_line = getline     ( v:lnum     )

	" Find a non-blank line above the current line.
	let pnlnum    = prevnonblank( v:lnum - 1 )

	" Hit the start of the file?  Use zero indent.
	if pnlnum == 0
		return 0
	endif

	" Get previous non-blank line's content.
	let prev_line = getline     ( pnlnum     )

	" Initialise indentation value.
	let ind       = indent      ( pnlnum     )


	"{{{=================================================================
	"  1) Indent four blanks per nested scope,
	"     with exceptions (2), (3) & (4).
	"}}}=================================================================
	
	" Add four blanks after "for", "stipulate", &cetera.
	" Skip if the line also contains the ending for the above 'openings'.
	if   prev_line  =~  '^\s*\%(fun\|for\|except\|where\|stipulate\|herein\)\>'
		if   prev_line  !~  'end\>[[:space:];]*$'
			let ind = ind + 4
		endif
	endif

	if   prev_line  =~  '{\s*\%(\s[^}]*\)\?'
		if   prev_line  !~  '}[[:space:];]*$'
			let ind = ind + 4
		endif
	endif

	" Subtract four blanks.
	if   this_line  =~  '^\s*\%(herein\|end\|except\)\>'
	\ || this_line  =~  '^\s*}'

		let ind = ind - 4
	endif


	"{{{=================================================================
	"  2)  * Indent multi-line case statement bodies five blanks.
	"}}}=================================================================

	if   prev_line  =~  '^\s*case\>'
		if   prev_line  !~  'esac\>[[:space:];]*$'
			let ind = ind + 5
		endif
	endif

	if   this_line  =~  '^\s*esac\>'
		let ind = ind - 5
	endif


	"{{{=================================================================
	"  TODO: indent if-conditions
	"  3)  * Indent multi-line if statement conditions
	"        and bodies five blanks.
	"}}}=================================================================

	""" if-conditions:  place 3 blanks after "if"
	""" Note:  now achieved by snipMate
	" if   this_line  =~  'if'
		" call setline( lnum, substitute( this_line, 'if\(\s\+\)\(.*\)$', 'if   \2', '' ))
	" endif


	""" if-body:
	if   prev_line  =~  '^\s*\%(if\|else\|elif\)\>'
		if   prev_line  !~  'fi\>[[:space:];]*$'
			let ind = ind + 5
		endif
	endif

	if   this_line  =~  '^\s*\%(elif\|else\|fi\)\>'
		let ind = ind - 5
	endif



	"{{{=================================================================
	"  TODO: record
	"  4)  * Indent multi-line tuple and record contents two blanks,
	"        to distinguish them from code.
	"        NOTE:  HARD to distinguish between record braces and code 
	"        block braces.
	"}}}=================================================================
	

	""" tuple:
	if   prev_line  =~  '(\s*\%(\s[^)]*\)\?'
		if   prev_line  !~  ')[[:space:];]*$'
			let ind = ind + 2
		endif
	endif

	if   this_line  =~  '^\s*)'
		let ind = ind - 2
	endif


	"{{{-----------------------------------------------------------------
	" Do No Ident For The Following:
	"
	" If previous line is a /* * */ comment,
	" don't do any autoindent, because Vim's "comments" option
	" will take care of this case.
	"
	" If previous line is a # comment, ditto...
	"
	" If previous line has a bullet ("-"), let Vim do its indent.  The 
	" reason is that when you are doing bullets, you are most likely 
	" writing text not code, therefore you would not want to override 
	" Vim's text-autowrapping magic, etc.
	if   prev_line =~ '^\s*/\?\*\+'
	\||  synIDattr(synID(pnlnum,col('.'),1),'name') =~ "Comment$"
	\||  prev_line =~ '^\s*-'
		return -1
	endif
	"}}}-----------------------------------------------------------------

	return ind
endfunction


" vim:sw=8
