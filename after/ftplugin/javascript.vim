" Vim filetype plugin

" Require the flow executable.
if !executable(g:flow#flowpath)
  finish
endif

" Omnicompletion.
if !exists("g:flow#omnifunc")
  let g:flow#omnifunc = 1
endif

if exists('&omnifunc') && g:flow#omnifunc
  setl omnifunc=flowcomplete#Complete
endif

" Setup `/*::` to not be continued as a javascript block comment
" - Prepend the currently setup `comments` options, so that '/*' is
"   still evaluated as before
let &comments = "f:/*::," . &comments
