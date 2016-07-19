" Vim filetype plugin

" Require the flow executable.
if !executable('flow')
  finish
endif

" Omnicompletion.
if !exists("g:flow#omnifunc")
  let g:flow#omnifunc = 1
endif

if exists('&omnifunc') && g:flow#omnifunc
  setl omnifunc=flowcomplete#Complete
endif
