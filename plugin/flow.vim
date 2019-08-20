" flow.vim - Flow typechecker integration for vim

if exists("g:loaded_flow")
  finish
endif
let g:loaded_flow = 1

" Configuration switches:
" - enable:       Typechecking is done on :w.
" - autoclose:    Quickfix window closes automatically when there are no errors.
" - errjmp:       Jump to errors after typechecking; default off.
" - qfsize:       Let the plugin control the quickfix window size.
" - flowpath:     Path to the flow executable - default is flow in path
" - showquickfix  Show the quickfix window
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
if !exists("g:flow#timeout")
  let g:flow#timeout = 2
endif
if !exists("g:flow#showquickfix")
  let g:flow#showquickfix = 1
endif

" flow error format.
let s:flow_errorformat = '%EFile "%f"\, line %l\, characters %c-%.%#,%Z%m,'
" flow from editor.
let s:flow_from = '--from vim'

function! <SID>GetFlowExecutable()
  if exists("g:flow#flowpath")
    return g:flow#flowpath
  else
    " Search for a local version of flow
    let s:npm_local_flowpath = finddir("node_modules", ".;") . "/.bin/flow"
    if filereadable(s:npm_local_flowpath)
      return s:npm_local_flowpath
    else
      " fallback to global instance
      return "flow"
    endif
  endif
endfunction

function! flow#SaveGetFlowExecutable()
  let a:flow_executable = <SID>GetFlowExecutable()
  if !executable(a:flow_executable)
    echohl WarningMsg
    echomsg 'No Flow executable found.'
    echohl None
    finish
  else
    return a:flow_executable
  endif
endfunction


" Call wrapper for flow.
function! <SID>FlowClientCall(cmd, suffix, ...)
  " Invoke typechecker.
  " We also concatenate with the empty string because otherwise
  " cgetexpr complains about not having a String argument, even though
  " type(flow_result) == 1.
  let command = flow#SaveGetFlowExecutable().' '.a:cmd.' '.s:flow_from.' '.a:suffix

  let flow_result = a:0 > 0 ? system(command, a:1) : system(command)

  " Handle the server still initializing
  if v:shell_error == 1
    echohl WarningMsg
    echomsg 'Flow server is still initializing...'
    echohl None
    cclose
    return 0
  endif

  " Handle timeout
  if v:shell_error == 3
    echohl WarningMsg
    echomsg 'Flow timed out, please try again!'
    echohl None
    cclose
    return 0
  endif

  return flow_result
endfunction

" Main interface functions.
function! flow#typecheck()
  " Flow current outputs errors to stderr and gets fancy with single character
  " files
  let flow_result = <SID>FlowClientCall('--timeout '.g:flow#timeout.' --retry-if-init false "'.expand('%:p').'"', '2> /dev/null')
  let old_fmt = &errorformat
  let &errorformat = s:flow_errorformat

  if g:flow#errjmp
    cexpr flow_result
  else
    cgetexpr flow_result
  endif

  if g:flow#showquickfix
    if g:flow#autoclose
      botright cwindow
    else
      botright copen
    endif
  endif
  let &errorformat = old_fmt
endfunction

" Get the Flow type at the current cursor position.
function! flow#get_type()
  let pos = line('.').' '.col('.')
  let path = ' --path '.fnameescape(expand('%'))
  let cmd = flow#SaveGetFlowExecutable().' type-at-pos '.pos.path
  let stdin = join(getline(1,'$'), "\n")

  let output = 'FlowType: '.system(cmd, stdin)
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

" Jump to Flow definition for the current cursor position
function! flow#jump_to_def()
  let pos = line('.').' '.col('.')
  let path = ' --path '.fnameescape(expand('%'))
  let stdin = join(getline(1,'$'), "\n")
  let flow_result = <SID>FlowClientCall('get-def --quiet '.pos.path, '', stdin)
  " Output format is:
  "   File: "/path/to/file", line 1, characters 1-11

  " Flow returns a single line-feed if no result
  if strlen(flow_result) == 1
    echo 'No definition found'
    return 1
  endif

  let parts = split(flow_result, ",")
  if len(parts) < 2
      echo 'cannot find definition'
      return 1
  endif

  " File: "/path/to/file" => /path/to/file
  let file = substitute(substitute(parts[0], '"', '', 'g'), 'File ', '', '')

  " line 1 => 1
  let row = split(parts[1], " ")[1]

  " characters 1-11 => 1
  let col = 0
  if len(parts) == 3
    let col = split(split(parts[2], " ")[1], "-")[0]
  endif

  " File - means current file
  if filereadable(file) || file == '-'
    if file != '-'
      execute 'edit' file
    endif
    call cursor(row, col)
  end
endfunction

" Open importers of current file in quickfix window
function! flow#get_importers()
  let flow_result = <SID>FlowClientCall('get-importers "'.expand('%').'" --strip-root', '')
  let importers = split(flow_result, '\n')[1:1000]

  let l:flow_errorformat = '%f'
  let old_fmt = &errorformat
  let &errorformat = l:flow_errorformat

  if g:flow#errjmp
    cexpr importers
  else
    cgetexpr importers
  endif

  if g:flow#autoclose
    botright cwindow
  else
    botright copen
  endif
  let &errorformat = old_fmt
endfunction


" Commands and auto-typecheck.
command! FlowToggle       call flow#toggle()
command! FlowMake         call flow#typecheck()
command! FlowType         call flow#get_type()
command! FlowJumpToDef    call flow#jump_to_def()
command! FlowGetImporters call flow#get_importers()

au BufWritePost *.js,*.jsx if g:flow#enable | call flow#typecheck() | endif


" Keep quickfix window at an adjusted height.
function! <SID>AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

au FileType qf if g:flow#qfsize | call <SID>AdjustWindowHeight(3, 10) | endif
