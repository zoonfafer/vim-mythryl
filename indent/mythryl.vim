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


let s:maxoff = 50	" maximum number of lines to look backwards for ()

"==============================================================
" URL:	http://mythryl.org/my-Indentation.html
"  1) Indent four blanks per nested scope, with the following exceptions:
"  2)  * Indent multi-line case statement bodies five blanks.
"  3)  * Indent multi-line if statement conditions and bodies five blanks.
"  4)  * Indent multi-line  tuple and record contents two blanks, to
"        distinguish them from code. 
"--------------------------------------------------------------



"==============================================================
" Convenience Functions
" 
"--------------------------------------------------------------

" spaceship operator
function! s:cmp( a, b )
	let [a, b] = [a:a, a:b]
	if a < b
		return -1
	elseif a == b
		return 0
	else
		return 1
	endif
endfunc


" spaceship operator over two arrays
function! s:cmp_ary( ar1, ar2 )
	let a = a:ar1
	let b = a:ar2

	let counter  = 0
	let length_a = len( a )

	while counter < length_a
		if s:cmp( a[counter], b[counter] ) == 0
			let counter += 1
		else
			return s:cmp( a[counter], b[counter] )
		endif
	endwhile
	return 0
endfunc


" I just don't want to type out all these stuff when I just want to test if
" the cursor is placed on top of a comment syntax item.
function! s:is_comment( lnum, col, ... )
	return synIDattr(synID(a:lnum,a:col,1),'name') =~ 'Comment$'
endfunc



"==============================================================
" Auxiliary Functions
" 
"--------------------------------------------------------------

" Motivation:
" This function is used for providing positional information of the
" "start_regex" given the "end_regex".  The two regular expressions are
" treated as the start & end of a nest-able pair.
"
" Hence, this function acts like:-
"
"   :searchpair( start, '', end, 'nbW' )
"
" However, 'searchpair()' does not work correcty when indenting stuff from
" 'indentkeys'.  For example, when trying to search for the matching "{" upon
" hitting "}", and if it happens that there is another "{" above the correct
" "{", then 'searchpair()' will return that "{" instead.
"
" But since I don't know how to hack 'searchpair()' into submission, I decided
" to implement a function that Just Works (tm).
"

function! PreviousMatching(start_regex, end_regex, ...)

	" First of all, move our cursor up, ...
	call cursor( [line('.') - 1, col('.')] )
	" ... then shove it to the end of line.
	call cursor( [line('.'), col('$')] )
	" Observations:  If we do the two operations all in one go (move up a
	" line and move to the end of the line), i.e.
	"
	"    :call cursor( [line('.') - 1, col('$')] )
	"
	" then odd-numbered levels of the pair will display non-determinacy in
	" indent level, i.e. jumps between the correct level and the next
	" level.


	" This counter will store the state for our pair-counting state
	" machine.
	let s:unmatched_end_count = 0


	" Initialise some variables to get the 'while'-loop below running.
	let [s_lnum, s_col] = searchpos(a:start_regex, 'nbW')
	let [e_lnum, e_col] = searchpos(a:end_regex, 'nbW')


	while s_lnum > 0
	\||   e_lnum > 0
		let [s_lnum, s_col] = searchpos(a:start_regex, 'nbW')
		let [e_lnum, e_col] = searchpos(a:end_regex, 'nbW')

		let s:cmp_result = s:cmp_ary( [s_lnum, s_col], [e_lnum, e_col] )

		if     s:cmp_result  == -1

			" start_regex occurs earlier than end_regex
			"
			" Note:  I arbitrarily chose to decrement counter for this
			" case.  Thus, for the other case, I will have to
			" increment the counter instead.
			let s:unmatched_end_count -= 1

			" Move the cursor to the new point and continue the
			" search.
			call cursor( [e_lnum, e_col] )
			" return "hi"

		elseif s:cmp_result  ==  1

			" start_regex occurs later than end_regex
			"
			if     s:unmatched_end_count == 0
				return {
				\ 'start' :
				\	{ 'lnum' : s_lnum,
				\	   'col' : s_col },
				\ 'end' :
				\	{ 'lnum' : e_lnum,
				\	   'col' : e_col }
				\ }
			else
				let s:unmatched_end_count += 1

				" Move the cursor to the new point and
				" continue the search.
				call cursor( [s_lnum, s_col] )
				" return "bye"

			endif
		else " s:cmp_result  ==  0
			" start_regex is at same place as end_regex
			" IMPOSSIBLE!
			" XXX maybe this case can be ignored?
			return -255
		endif

	endwhile

	" 
	" Note:  returning a string is equivalent to returning 0.
	"
	return "no while?"

endfunc



"
" Note:  this function may not be needed after all.
"
" This is a convenience function that wraps around the function
" "PreviousMatching()", providing support for de-indentation for the "}" of a
" "{ }" pair,  hence its use of 'virtcol()' to get the actual screen columns.
function! PreviousMatchingStart( start_regex, end_regex, ... )
	let s:match_pair = PreviousMatching( a:start_regex, a:end_regex )['start']
	return { 'virtcol' : virtcol( [ s:match_pair['lnum'], s:match_pair['col'] ] ),
		\   'lnum' : s:match_pair['lnum'],
		\    'col' : s:match_pair['col'] }
endfunc


" Motivation:
" In Mythryl, it is conventional to indent a large binding block which is
" hinged at the equal sign, "=".
"
" But how do we know when to de-indent such a block?
"
" This function returns 'true' if it decides that a de-indent is needed, and
" 'false' otherwise.
"
"
" Example_1:
"    fun foo { bar }
"        =
"        ...;
"
"    # De-indent here!
"
" Example_1b:
"    fun foo ( bar )
"        =
"        if FALSE
"            baz1;
"        elif FALSE
"            baz2;
"        else
"            baz3;
"        fi;
"
"    # De-indent here!
"
" Example_2:
"    my foo
"        =
"        ...;
"
"    # De-indent here!
"
" Example_3:
"    my foo = if TRUE 3; else 2; fi;
"    # don't de-indent!
"
" Example_4:
"    my foo = {
"        ...
"    };
"
"    # This case is not covered by the following function.
"
" Example_5:
"    my foo = { if TRUE 3; else 2; fi;
"        # whatever.  don't care.
"
"
" How To Do It:
" Since every statement ends with a semi-colon (';'), make it so that 
" whenever a semi-colon is entered:
"
"   1. Check whether a *lone* equal sign ('=') exists above the
"   previous line.
"	- if yes, then -> point 2.
"	- if not, then do nothing.
"
"   2. Check whether the previous line has the same indent level as
"   the line that contains the lone equal sign.
"	- if yes, then -> point 3.
"	- if not, then do nothing.
"
"   3. Check whether there are any lines with a lesser indent level
"   between the line with the equal sign and the previous line.
"	- if yes, then do nothing.
"	- if not, then DE-INDENT!
"
"   4. Done. :-)
"
"
function! NeedEqualSignDeindent(lnum, ...)

	" Don't need to de-indent if already at 0 indent.
	if indent( a:lnum ) == 0
		return 0 
	endif

	let s:this_line  = getline( a:lnum )

	if  s:this_line  =~ ';[[:space:];]*$'

		let s:pnbindent = indent( a:lnum )
		"
		" Check whether a lone equal sign exists above this line, and
		" whether they are at the same indent level.
		"
		let s:last_equal_sign_lnum = search( '^\s*=>\?\_s*$', 'nbW' )
		let s:has_equal_indent_equal_sign = 0


		if   s:last_equal_sign_lnum           != 0
		\&&  indent( s:last_equal_sign_lnum ) == s:pnbindent
			"
			" 's:current_lnum' is the line counter for scanning
			" backwards.
			"
			let s:current_lnum = a:lnum

			while  s:current_lnum > s:last_equal_sign_lnum
				" now DO THE INDENT CHECK!
				if indent( s:current_lnum ) < s:pnbindent
					return 0
				endif

				" (Make solution space monotonically smaller ;-)
				let s:current_lnum = prevnonblank( s:current_lnum - 1 )
			endwhile

			" Return "Yes, we need to de-indent!" when all checks
			" have been passed.
			return 1
		endif
	endif

	return 0
endfunc




"==============================================================
" THE Indent Function
" 
"--------------------------------------------------------------
function! GetMythrylIndent(...)


	" Get current line's content.
	let this_line = getline     ( v:lnum     )

	" Find a non-blank line above the current line.
	let pnblnum   = prevnonblank( v:lnum - 1 )

	" Hit the start of the file?  Use zero indent.
	if  pnblnum   == 0
		return 0
	endif


	" Get previous non-blank line's content & indent
	let prev_line = getline     ( pnblnum     )

	let pnbind    = indent      ( pnblnum     )


	" Find a non-blank non-continuation-of-a-multiline-comment line above
	" the current line.
	" Note:  needed to fix de-indent just after a /* * */ comment, which
	" is specially indented.
	let pnclnum   = pnblnum

	" The following just checks the first column...
	" ... which is good enough, because this is just sufficient to match
	" against a multi-line comment which spans over >=2 lines, which in
	" turn is just the case that we're interested in (i.e. the case that
	" is the most problematic).
	while synIDattr(synID(pnclnum, 1, 1),'name') =~ "Comment$"
	\ &&  pnclnum  >  0
		let pnclnum = prevnonblank( pnclnum - 1 )
	endwhile

	" Get previous non-comment line
	let prev_ncline = getline( pnclnum )


	""" Initialise indentation values.
	" This will be the intial indent value.
	let s:ind     = indent      ( pnclnum     )

	" This will be the return value.
	let   ind     = s:ind


	"{{{=================================================================
	"  1) Indent four blanks per nested scope,
	"     with exceptions (2), (3) & (4).
	"}}}=================================================================
	
	" Add four blanks after "for", "stipulate", &cetera.
	" Skip if the line also contains the ending for the above 'openings'.
	" if   prev_ncline  =~  '^\s*\%(fun\|for\|except\|where\|stipulate\|herein\)\>'
	if   prev_ncline  =~  '^\s*\%(for\|where\|stipulate\|herein\)\>'
		if   prev_ncline  !~  'end\>[[:space:];]*$'
			let ind = s:ind + 4
		endif

	" multi-case "fun", "except", "fn"
	elseif   prev_ncline  =~  '^\s*\%(fun\|fn\|except\)\>'
		" XXX: need cleanup   ...........\@!
		if   prev_ncline  !~  '\%(=\%(>\)\@!.*\|end\>\)[[:space:];]*$'
			let ind = s:ind + 4
		endif

	" Indent if "my|val" definition hasn't ended yet.
	" 'Ended' means to have been terminated with a semi-colon, ';'.
	elseif   prev_ncline  =~  '^\s*\%(my\|val\)\>'
	\&&      prev_ncline  !~  '=.*;[[:space:];]*$'
	\&&      prev_ncline  !~  '[(\[{][^()\[\]{}]*$'
	" Don't indent if previous line is a complete statement.

		let ind = s:ind + 4


	"""
	""" old indent for { ... }.  New indent covered in case 4).
	"""
	"
	" if   prev_ncline  =~  '{\s*\%(\s[^}]*\)\?'
		" " if   prev_ncline  !~  '}[[:space:];]*$'
		" if   prev_ncline  !~  '}[^{]\+$'
			" let ind = s:ind + 4
		" endif
	" endif


	" Subtract four blanks.
	elseif   this_line  =~  '^\s*\%(herein\|end\|except\)\>'
	" \ || this_line  =~  '^\s*}'

		let ind = s:ind - 4


	"{{{=================================================================
	"  2)  * Indent multi-line case statement bodies five blanks.
	"}}}=================================================================

	elseif   prev_ncline  =~  '^\s*case\>'
		if   prev_ncline  !~  'esac\>[[:space:];]*$'
			let ind = s:ind + 5
		endif

	elseif   this_line  =~  '^\s*esac\>'
		let ind = s:ind - 5


	"{{{=================================================================
	"        indent if-conditions
	"  3)  * Indent multi-line if statement conditions
	"        and bodies five blanks.
	"}}}=================================================================

	""" if-conditions:  place 3 blanks after "if"
	""" Note:  now achieved by snipMate
	" if   this_line  =~  'if'
		" call setline( v:lnum, substitute( this_line, 'if\(\s\+\)\(.*\)$', 'if   \2', '' ))
	" endif


	""" if-body:
	elseif   prev_ncline  =~  '^\s*\%(if\|else\|elif\)\>'
		if   prev_ncline  !~  'fi\>[[:space:];]*$'
			let ind = s:ind + 5
		endif
		if   this_line  =~  '^\s*\%(elif\|else\|fi\)\>'
			let ind = s:ind
		endif

	elseif   this_line  =~  '^\s*\%(elif\|else\|fi\)\>'
		let ind = s:ind - 5



	"{{{=================================================================
	"  4)  * Indent multi-line tuple and record contents two blanks,
	"        to distinguish them from code.
	"        NOTE:  HARD to distinguish between record braces and code 
	"        block braces.
	"        Thus:  trust user to indent the first line correctly.
	"}}}=================================================================
	

	""" tuple:
	elseif   prev_ncline  =~  '(\s*\%(\s[^)]*\)\?'
		" if   prev_ncline  !~  ')[[:space:];]*$'
		if   prev_ncline  !~  ')[^(]*$'
			let ind = s:ind + 2
		endif

	elseif   this_line  =~  '^\s*)'
		let ind = s:ind - 2


	""" record / code block braces:
	" How:
	"   Need to find the distance between '{' and the first '\_S' after
	"   it.
	"
	" Example_1:
	"   {    foobar
	"   <---> 
	"     x
	"
	" Example_2:
	"  ^    my foo = {    foobar
	"  ^<----------------> 
	"           x
	"
	" Example_3:
	"  ^    my foo = {   {  foobar => 2,
	"  ^<------------------> 
	"            x
	"
	"     => return (s:ind + x)
	"     => Need to get 'x'.
	"
	" let s:brace_text_regexp = '{\s*\%(\s[^}]*\)\?'
	" if   prev_ncline  =~  '{\s*\%(\s[^}]*\)\?'
	elseif   prev_ncline  =~  '{\s\+\%([^}]*\)\?$'

		" if   prev_ncline  !~  ')[[:space:];]*$'
		" if   prev_ncline  !~  '}[^{]*$'

			"
			" First Attempt:
			"
			" The following approach works iff there exists a
			" function (conflated with the "strlen()" function
			" below) that can translate from tabs to on-screen
			" space.
			"
			" But there exists none such function.
			"
			" So it doesn't work.
			"
			" Thus, we use a different approach.
			" 
			" let s:subbed_line = substitute( prev_ncline, '{\s\+\S', '..', '' )
			" let s:subbed_len  = strlen( s:subbed_line )
			" let s:prev_len    = strlen(
			" \	substitute( prev_ncline,
			" \		    '{', ' ', '' ) )
			" let ind           = s:ind + ( s:prev_len - s:subbed_len ) + 1
			

			"
			" Second Attempt:
			"
			" This following approach should work.
			"
			" It uses the "virtcol([line, col])" function to get
			" the on-screen column.
			"
			"    :help virtcol()
			"
			" "line" is just the 'previous line'.
			" "col" is the byte-index of the 'point of interest',
			" which can be obtained from the "match({expr},{pat})"
			" function.
			"
			"    :help match()
			"
			"
			" How:
			"
			" let s:brace_text_regexp = '\%({\s*\)\@<=\%(\s[^}]*\)\?'
			"
			" let s:match_index = match( prev_ncline, s:brace_text_regexp )
			" let s:screen_column = virtcol( [ pnblnum, s:match_index ] )
			" let ind = s:screen_column + 1
			"
			"
			" Problems:
			"
			" This appears to be able to do the job.  However...
			" the regexp "\%({\s*\)\@<=\%(\s[^}]*\)\?" doesn't do
			" what I expected in the "match()" function...
			" I expected "match()" to discard the match for the
			" first "\%(...\)" parentheses, but it didn't.
			"
			"
			" Possible Solutions:
			"
			" So, I think we need to do a match for the second
			" time.
			" And we have to split up the regexp differently.
			"

			"
			" Third Attempt:
			"
			" The actual screen column number is obtained by
			" piping through "virtcol()" the sum of the indices of
			" the first and second match.
			"
			let brace_text_regexp = '{\s\+\%([^}]*\)\?$'

			" The string "prematch" will be used in the second
			" search.
			let prematch       = matchstr( prev_ncline, brace_text_regexp )
			let prematch_index = match   ( prev_ncline, brace_text_regexp )

			" Now do a search within the first match result.
			" Note:  The "1" skips the leading "{".
			let    match_index = match   ( prematch, '[^[:space:]}]\|$', 1 )

			let  screen_column = virtcol (
						\ [ pnblnum,
						\   prematch_index + match_index
						\ ]
						\)
			let ind = screen_column


	"
	" This branch is for regular indentation for braces.
	"
	" Example:
	"
	" my foo = {
	"     some code;
	"     ...
	"
	" elseif   prev_ncline  =~  '{\s*\%(\s[^}]*\)\?'
	elseif   prev_ncline  =~  '{$'
		let ind = s:ind + 4
		" " if   prev_ncline  !~  '}[[:space:];]*$'
		" if   prev_ncline  !~  '}[^{]\+$'
			" let ind = s:ind + 4
		" endif


	"
	" De-indent is a bit trickier.
	"
	" Example_1:
	" {             omg;
	" };
	"
	" Example_2:
	"       {
	"                  a;
	"                  b;
	"       };
	"
	" Example_3:
	"   my foo = {
	"       bar baz;
	"   };
	"
	elseif   this_line  =~  '^\s*}'

		" First Attempt:
		" let ind = s:ind - 4
		"
		" Problems: indent level not flexible.
		"

		" Second Attempt:
		" let ind = indent( searchpair( '{', '', '}', 'nbW' ) )
		"
		" Problems:
		"
		"  - Sometimes hitting "}" doesn't trigger a de-indent, but only
		"  after hitting "==" in normal mode.
		"
		"  - But when hitting "}" DOES trigger de-indent, it matches
		"  the "{" before the correct matching "{" instead.
		"

		" Third Attempt:
		" let ind = PreviousMatching( '{', '}' )['start']['col'] - 1
		"
		" Problems:
		" does not take actual screen columns into account.
		"

		" Fourth Attempt:
		" 
		" let ind = PreviousMatchingStart( '\.\?{', '}' )['virtcol'] - 1
		"
		" Note:  The 'start_regex' also matches against a ".{" brace.
		" Now a .{ } pair will be indented as the following:-
		"
		"   .{
		"       some code;
		"   };
		"
		" ... instead of the following:-
		"
		"   .{
		"	some code;
		"    };
		"
		" (note the position of the closing brace, "}".
		"
		"
		" Problems:
		"
		" The above code should be good enough, except for the this
		" case:-
		"
		"    my foo = {
		"        some code;
		"    };
		"
		" ... which will become:-
		"
		"    my foo = {
		"        some code;
		"             };
		"
		" Not good!!!
		"
		"
		" Possible Solutions:
		"
		" We probably just need to indent the "}" to the same level as
		" the line containing the matching "{".
		"

		" Fifth Attempt:
		" :-)
		let ind = indent( PreviousMatching( '\.\?{', '}' )['start']['lnum'] )



	"{{{=================================================================
	"      Custom Indent Rule:
	"      > indent list and vector
	"
	"}}}=================================================================


	""" list "[ ]" & vectors "#[ ]":
	elseif   prev_ncline  =~  '\[\s*\%(\s[^\]]*\)\?'
		" if   prev_ncline  !~  '\][[:space:];]*$'
		if   prev_ncline  !~  '\][^\[]*$'
			let ind = s:ind + 4
		endif

	elseif   this_line  =~  '^\s*\]'
		let ind = s:ind - 4


	"{{{=================================================================
	"      Custom De_indent Rule:
	"      > de-indent binding block ( my foo = ...; )
	"
	"}}}=================================================================


	elseif NeedEqualSignDeindent( pnblnum )
		let ind = s:ind - 4


	"{{{=================================================================
	"      Custom Comment Indent Rule:
	"
	"}}}=================================================================

	elseif prev_line =~ '/\*'
		" let ind = indent( pnblnum ) + 1
		let s:match_position = match( prev_line, '/\*' )
		if s:is_comment( pnblnum, s:match_position + 1 )
			let ind = virtcol (
				\ [ pnblnum,
				\   s:match_position
				\ ]
				\) + 1
		endif

	elseif prev_line =~ '^\s*\*\%(/\)\@!'
		let s:match_position = match( prev_line, '^\s*\*' )
		if s:is_comment( pnblnum, s:match_position + 1 )
			let ind = indent( pnblnum )
		endif


	" "{{{-----------------------------------------------------------------
	" Update:
	" >>> Maybe we don't need this after all. >>>
	"
	" " No Ident For The Following:
	" "
	" " If previous line is a /* * */ comment,
	" " don't do any autoindent, because Vim's "comments" option
	" " will take care of this case.
	" "
	" " If previous line is a # comment, ditto...
	" "
	" " If previous line has a bullet ("-"), let Vim do its indent.  The 
	" " reason is that when you are doing bullets, you are most likely 
	" " writing text not code, therefore you would not want to override 
	" " Vim's text-autowrapping magic, etc.
	" elseif   synIDattr(
	" \	synID(
	" \		v:lnum, 
	" \		col('.') - 1 == 0 ? 1 : col('.') - 1,
	" \		1
	" \	),
	" \	'name'
	" \    ) =~ "Comment$"
	" \||  prev_line =~ '^\s*-'
		" return -1
	endif
	"}}}-----------------------------------------------------------------

	return ind
endfunction


" vim:sw=8
