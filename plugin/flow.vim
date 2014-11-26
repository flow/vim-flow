" flow.vim - Flow typechecker integration for vim

if exists("g:loaded_flow")
  finish
endif
let g:loaded_flow = 1

" Require the flow executable.
if !executable('flow')
  finish
endif


" Configuration switches:
" - enable:     Typechecking is done on :w.
" - autoclose:  Quickfix window closes automatically.
" - errjmp:     Jump to errors after typechecking; default off.
" - qfsize:     Let the plugin control the quickfix window size.
" - flowpath:   Path to the flow executable - default is flow in path
if !exists("g:flow#enable")
  let g:flow#enable = 1
endif
if !exists("g:flow#autoclose")
  let g:flow#autoclose = 0
endif
if !exists("g:flow#errjmp")
  let g:flow#errjmp = 0
endif
if !exists("g:flow#qfsize")
  let g:flow#qfsize = 1
endif
if !exists("g:flow#flowpath")
  let g:flow#flowpath = "flow"
endif


" flow error format.
let s:flow_errorformat = '%EFile "%f"\, line %l\, characters %c-%.%#,%Z%m,'


" Call wrapper for flow.
function! <SID>FlowClientCall(suffix)
  " Invoke typechecker. 
  " We also concatenate with the empty string because otherwise
  " cgetexpr complains about not having a String argument, even though
  " type(flow_result) == 1.
  let command = g:flow#flowpath.' --timeout 2 --from vim '.expand('%:p').' '.a:suffix

  let flow_result = system(command)

  " Handle timeout
  if v:shell_error == 3
    return 0
  endif

  let old_fmt = &errorformat
  let &errorformat = s:flow_errorformat

  if g:flow#errjmp
    cexpr flow_result
  else
    cgetexpr flow_result
  endif

  if g:flow#autoclose
    botright cwindow
  else
    botright copen
  endif
  let &errorformat = old_fmt
endfunction


" Main interface functions.
function! flow#typecheck()
  " Flow current outputs errors to stderr and gets fancy with single character
  " files
  call <SID>FlowClientCall('2> /dev/null')
endfunction

function! flow#find_refs(fn)
  call <SID>FlowClientCall('--find-refs '.a:fn.'| sed "s/[0-9]* total results//"')
endfunction

" Get the Flow type at the current cursor position.
function! flow#get_type()
  let pos = fnameescape(expand('%')).' '.line('.').' '.col('.')
  let cmd = g:flow#flowpath.' type-at-pos '.pos

  let output = 'FlowType: '.system(cmd)
  let output = substitute(output, '\n$', '', '')
  echo output
endfunction

" Toggle auto-typecheck.
function! flow#toggle()
  if g:flow#enable
    let g:flow#enable = 0
  else
    let g:flow#enable = 1
  endif
endfunction


" Commands and auto-typecheck.
command! FlowToggle call flow#toggle()
command! FlowMake   call flow#typecheck()
command! FlowType   call flow#get_type()
command! -nargs=1 FlowFindRefs call flow#find_refs(<q-args>)

au BufWritePost *.js if g:flow#enable | call flow#typecheck() | endif


" Keep quickfix window at an adjusted height.
function! <SID>AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

au FileType qf if g:flow#qfsize | call <SID>AdjustWindowHeight(3, 10) | endif
