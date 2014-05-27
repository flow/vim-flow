" Vim completion script
" Language:     Hack (PHP)
" Maintainer:   Max Wang <mwang@fb.com>
" Maintainer:   Srećko Toroman <storoman@fb.com>
" URL:          https://github.com/hhvm/vim-hack
" Last Change:  April 3, 2014
"
" Copyright: (c) 2014, Facebook Inc.  All rights reserved.
"
" This source code is licensed under the BSD-style license found in the
" LICENSE file in the toplevel directory of this source tree.  An additional
" grant of patent rights can be found in the PATENTS file in the same
" directory.

" Magical hh_client autocomplete token.
let s:autotok = 'AUTO332'

" Omni findstart phase.
function! s:FindStart()
  let line = getline('.')
  let start = col('.') - 1

  while start >= 0 && line[start - 1] =~ '[a-zA-Z_0-9\x7f-\xff$]'
    let start -= 1
  endwhile
  return start
endfunction

function! hackcomplete#Complete(findstart, base)
  if a:findstart
    return s:FindStart()
  end

  let lnum = line('.')
  let cnum = col('.')
  let lines = getline(1, '$')

  " Insert the base and magic token into the current line.
  let curline = lines[lnum - 1]
  let lines[lnum - 1] = curline[:cnum - 1] . a:base . s:autotok . curline[cnum :]

  " Pass the buffer to hh_client.
  let buffer = join(lines, "\n")
  let result = system('hh_client --auto-complete', buffer)

  let matches = []

  " Parse the hh_client output.
  for line in split(result, "\n")
    if empty(line) | continue | endif

    let entry = {}
    let space = stridx(line, ' ')

    if line[0] == '$'
      " Variable.
      let name_end = (space == -1) ? strlen(line) : space

      let word = line[:name_end - 1]
      if word !~ '^\V'.a:base | continue | endif

      let entry = {'word': word, 'kind': 'v', 'menu': line[name_end :]}
    elseif space < 0
      " Class or function, since no type is given.
      let word = line
      if word !~ '^\V'.a:base | continue | endif

      " Guess that it's a class if it's TitleCase.
      let kind = (word[0] ==# toupper(word[0])) ? 'c' : 'f'

      let entry = {'word': word, 'kind': kind}
    else
      " Method, property, or constant.
      let word = line[:space - 1]
      if word !~ '^\V'.a:base | continue | endif

      let menu = line[space + 1 :]
      if menu =~ '^(function('
        " Function; remove (function(...)) wrapper.
        let entry = {'word': word, 'kind': 'f', 'menu': menu[9:-2]}
      else
        " Guess that caps means constant.
        let kind = (word[0] ==# toupper(word[0])) ? 'd' : 'v'
        let entry = {'word': word, 'kind': kind, 'menu': menu}
      endif
    endif

    call add(matches, entry)
  endfor

  return matches
endfunction
