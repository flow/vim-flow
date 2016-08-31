" Vim completion script
"
" This source code is licensed under the BSD-style license found in the
" LICENSE file in the toplevel directory of this source tree.  An additional
" grant of patent rights can be found in the PATENTS file in the same
" directory.

" Magical flow autocomplete token.
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

function! flowcomplete#Complete(findstart, base)
  if a:findstart
    return s:FindStart()
  endif

  let lnum = line('.')
  let cnum = col('.')
  let lines = getline(1, '$')

  " Insert the base and magic token into the current line.
  let curline = lines[lnum - 1]
  let lines[lnum - 1] = curline[:cnum - 1] . a:base . s:autotok . curline[cnum :]

  " Pass the buffer to flow.
  let buffer = join(lines, "\n")
  let command = g:flow#flowpath.' autocomplete '.expand('%:p')
  let result = system(command, buffer)

  if result =~ '^Error: not enough type information to autocomplete' ||
    \ result =~ '^Could not find file or directory'
    return []
  endif

  let matches = []

  " Parse the flow output.
  for line in split(result, "\n")
    if empty(line) | continue | endif

    let entry = {}
    let space = stridx(line, ' ')
    let word = line[:space - 1]
    let type = line[space + 1 :]

    " Skip matches that don't start with the base"
    if (stridx(word, a:base) != 0) | continue | endif

    " This is pretty hacky. We're using regexes to recognize the different
    " kind of matches. Really in the future we should somehow consume the json
    " output
    if type =~ '^(.*) =>'
      let entry = { 'word': word, 'kind': a:base, 'menu': type }
    elseif type =~ '^[class:'
      let entry = { 'word': word, 'kind': 'c', 'menu': type }
    else
      let entry = { 'word': word, 'kind': 'v', 'menu': type }
    endif

    call add(matches, entry)
  endfor

  return matches
endfunction
