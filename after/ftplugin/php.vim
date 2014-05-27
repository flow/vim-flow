" Vim filetype plugin
" Language:     Hack
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

if exists("b:did_ftplugin_hack")
  finish
endif
let b:did_ftplugin_hack = 1

" Require the hh_client executable.
if !executable('hh_client')
  finish
endif

" Omnicompletion.
if !exists("g:hack#omnifunc")
  let g:hack#omnifunc = 1
endif

if exists('&omnifunc') && g:hack#omnifunc
  setl omnifunc=hackcomplete#Complete
endif
