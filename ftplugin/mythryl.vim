" Vim ftplugin file
" Language:	Mythryl
" Maintainer:	Jeffrey Lau <vim@NOSPAMjlau.tk>
" Last Change:	2010 Mar 24 (<- most likely out-dated)
" Remark:	included by the Mythryl-script ftplugin
"
" Script Type:	ftplugin
" URL:		http://github.com/zoonfafer/vim-mythryl
"

" Only load this indent file when no other was loaded.
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" Let % jump between structure elements.
let b:mw = ''
let b:mw = b:mw . ',\<my\>:\<val\>:\<also\>:\(\<{\>\|;\)'
let b:mw = b:mw . ',\<if\>:\<elif\>:\<else\>:\<fi\>'
let b:mw = b:mw . ',\<\(fun\|except\|where\)\>:\<end\>'
let b:mw = b:mw . ',\<stipulate\>:\<herein\>'
let b:match_words = b:mw

let b:match_ignorecase=0

" vim:sw=8
