" hack.vim - Hack typechecker integration for vim
" Language:     Hack (PHP)
" Maintainer:   Srećko Toroman <storoman@fb.com>
" Maintainer:   Max Wang <mwang@fb.com>
" URL:          https://github.com/hhvm/vim-hack
" Last Change:  April 3, 2014
"
" Copyright: (c) 2014, Facebook Inc.  All rights reserved.
"
" This source code is licensed under the BSD-style license found in the
" LICENSE file in the toplevel directory of this source tree.  An additional
" grant of patent rights can be found in the PATENTS file in the same
" directory.

if exists("g:loaded_hack")
  finish
endif
let g:loaded_hack = 1

" Require the hh_client executable.
if !executable('hh_client')
  finish
endif


" Configuration switches:
" - enable:     Typechecking is done on :w.
" - autoclose:  Quickfix window closes automatically.
" - errjmp:     Jump to errors after typechecking; default off.
" - qfsize:     Let the plugin control the quickfix window size.
if !exists("g:hack#enable")
  let g:hack#enable = 1
endif
if !exists("g:hack#autoclose")
  let g:hack#autoclose = 1
endif
if !exists("g:hack#errjmp")
  let g:hack#errjmp = 0
endif
if !exists("g:hack#qfsize")
  let g:hack#qfsize = 1
endif


" hh_client error format.
let s:hack_errorformat =
  \  '%EFile "%f"\, line %l\, characters %c-%.%#,%Z%m,'
  \ .'Error: %m,'


" Call wrapper for hh_client.
function! <SID>HackClientCall(suffix)
  " Invoke typechecker.  We strip the trailing newline to avoid an empty
  " error.  We also concatenate with the empty string because otherwise
  " cgetexpr complains about not having a String argument, even though
  " type(hh_result) == 1.
  let hh_result = system('hh_client --from-vim '.a:suffix)[:-2].''

  let old_fmt = &errorformat
  let &errorformat = s:hack_errorformat

  if g:hack#errjmp
    cexpr hh_result
  else
    cgetexpr hh_result
  endif

  if g:hack#autoclose
    botright cwindow
  else
    botright copen
  endif
  let &errorformat = old_fmt
endfunction


" Main interface functions.
function! hack#typecheck()
  call <SID>HackClientCall('| sed "s/No errors!//"')
endfunction

function! hack#find_refs(fn)
  call <SID>HackClientCall('--find-refs '.a:fn.'| sed "s/[0-9]* total results//"')
endfunction

" Get the Hack type at the current cursor position.
function! hack#get_type()
  let pos = fnameescape(expand('%')).':'.line('.').':'.col('.')
  let cmd = 'hh_client --type-at-pos '.pos

  let output = 'HackType: '.system(cmd)
  let output = substitute(output, '\n$', '', '')
  echo output
endfunction

" Toggle auto-typecheck.
function! hack#toggle()
  if g:hack#enable
    let g:hack#enable = 0
  else
    let g:hack#enable = 1
  endif
endfunction


" Commands and auto-typecheck.
command! HackToggle call hack#toggle()
command! HackMake   call hack#typecheck()
command! HackType   call hack#get_type()
command! -nargs=1 HackFindRefs call hack#find_refs(<q-args>)

au BufWritePost *.php if g:hack#enable | call hack#typecheck() | endif
au BufWritePost *.hhi if g:hack#enable | call hack#typecheck() | endif


" Keep quickfix window at an adjusted height.
function! <SID>AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

au FileType qf if g:hack#qfsize | call <SID>AdjustWindowHeight(3, 10) | endif
