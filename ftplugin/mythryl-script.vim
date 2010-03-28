" Vim ftplugin file
" Language:	Mythryl
" Maintainer:	Jeffrey Lau <vim@NOSPAMjlau.tk>
" Last Change:	2010 Mar 24 (<- most likely out-dated)
" Remark:	includes the Mythryl-script ftplugin
"
" Script Type:	ftplugin
" URL:		http://github.com/zoonfafer/vim-mythryl
"

" Only load this indent file when no other was loaded.
if exists("b:did_ftplugin")
	finish
endif


"==============================================================
" Vim Ftplugin Includes
"--------------------------------------------------------------

if version < 600
	source <sfile>:p:h/mythryl.vim
else
	runtime! ftplugin/mythryl.vim
endif

let b:did_ftplugin = 1

" vim:sw=8
