" Vim ftdetect file
" Language:	Mythryl
" Maintainer:	Jeffrey Lau <vim@NOSPAMjlau.tk>
" Last Change:	2010 Mar 25 (<- most likely out-dated)
" Remark:	
"
" Script Type:	ftdetect
" URL:		http://github.com/zoonfafer/vim-mythryl
"
"

" Mythryl
autocmd BufNewFile,BufRead *.\(api\|pkg\) set ft=mythryl
autocmd BufNewFile,BufRead *.\(make6\|standard\) set ft=make6

" This logic really belongs in scripts.vim... ?
autocmd BufNewFile,BufRead,StdinReadPost *
	\ if getline(1) =~ '^#!.*\<mythryl\>' |
	\   set ft=mythryl-script |
	\ endif
	" \ else |
	" \   let s:l2 = getline(2) |
	" \   let s:l3 = getline(3) |
	" \   let s:l4 = getline(4) |
	" \   let s:l5 = getline(5) |
	" \   let s:l10 = getline(10) |
	" \   let s:l15 = getline(15) |
	" \   let s:l20 = getline(20) |
	" \   unlet s:l2 s:l3 s:l4 s:l5 s:l10 s:l15 s:l20 |
