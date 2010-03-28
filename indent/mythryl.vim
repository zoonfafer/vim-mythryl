" Vim indent file
" Language:	Mythryl
" Maintainer:	Jeffrey Lau <vim@NOSPAMjlau.tk>
" Last Change:	2010 Feb 18 (<- most likely out-dated)
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
setlocal formatoptions+=tcroqwan
setlocal nolisp
setlocal smartindent
setlocal textwidth=78
setlocal shiftwidth=4
setlocal softtabstop=4

if exists("*GetMythrylIndent")
	finish
endif


"==============================================================
" URL:	http://mythryl.org/my-Indentation.html
"  1) Indent four blanks per nested scope, with the following exceptions:
"  2)  * Indent multi-line case statement bodies five blanks.
"  3)  * Indent multi-line if statement conditions and bodies five blanks.
"  4)  * Indent multi-line tuple and record contents two blanks, to distinguish them from code. 
"--------------------------------------------------------------


function! GetMythrylIndent(...)

	" Get current line's content.
	let this_line = getline( v:lnum )

	" Find a non-blank line above the current line.
	let pnlnum = prevnonblank( v:lnum - 1 )

	" Hit the start of the file?  Use zero indent.
	if pnlnum == 0
		return 0
	endif

	" Get previous non-blank line's content.
	let prev_line = getline( pnlnum )

	" Initialise indentation value.
	let ind = indent( pnlnum )


	"{{{=================================================================
	"  1) Indent four blanks per nested scope,
	"     with exceptions (2), (3) & (4).
	"}}}=================================================================
	
	" Add a 'shiftwidth' after "if", "else", "case", "for", &cetera.
	" Skip if the line also contains the ending for the above 'openings'.
	if   prev_line  =~  '^\s*\(if\|else\|elif\|case\|for\|except\|where\|stipulate\|herein\)\>'
	\ || prev_line  =~  '{\s*\%(\s[^}]*\)'

		if   prev_line  !~  '\(esac\|fi\|end\)\>\s*$'
		\ && prev_line  !~  '}\s*$'
			let ind = ind + &sw
		endif
	endif

	" Subtract a 'shiftwidth'.
	if   this_line  =~  '^\s*\(herein\|else\|elif\|esac\|fi\|end\|except\)\>'
	\ || this_line  =~  '^\s*}'

		let ind = ind - &sw
	endif



	"{{{=================================================================
	"  TODO
	"  2)  * Indent multi-line case statement bodies five blanks.
	"}}}=================================================================



	"{{{=================================================================
	"  TODO
	"  3)  * Indent multi-line if statement conditions
	"        and bodies five blanks.
	"}}}=================================================================



	"{{{=================================================================
	"  TODO
	"  4)  * Indent multi-line tuple and record contents two blanks,
	"        to distinguish them from code. 
	"}}}=================================================================




	"{{{-----------------------------------------------------------------
	" Note Following:  to be matched the last?
	" If previous line is a /* * */ comment,
	" don't do any autoindent, because Vim's "comments" option
	" will take care of this case.
	if prev_line =~ '/\?\*\+'
		let ind = indent('.')
	endif
	"}}}-----------------------------------------------------------------

	return ind
endfunction


" vim:sw=8
