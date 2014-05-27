" Vim filetype plugin

if exists("b:did_ftplugin_flow")
  finish
endif
let b:did_ftplugin_flow = 1

" Require the hh_client executable.
if !executable('hh_client')
  finish
endif

" Omnicompletion.
if !exists("g:flow#omnifunc")
  let g:flow#omnifunc = 1
endif

if exists('&omnifunc') && g:flow#omnifunc
  setl omnifunc=flowcomplete#Complete
endif
