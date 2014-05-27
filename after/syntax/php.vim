" Vim syntax file
" Language:     Hack (PHP)
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


" We clear templatizable PHP keywords because keyword always takes precedence
" over match and region.
syn keyword phpType NotAKeyword
syn clear   phpType
syn keyword phpFunctions NotAKeyword
syn clear   phpFunctions
syn keyword phpClasses NotAKeyword
syn clear   phpClasses
syn keyword phpInterfaces NotAKeyword
syn clear   phpInterfaces

" Add them back, using syn-match for generics.
let s:builtins = expand("<sfile>:h") . "/php-builtins/*.vim"
for f in split(glob(s:builtins), '\n')
  exe 'source' f
endfor

" Add PHP and Hack primitive types.
syn keyword phpType bool[ean] int[eger] real double float string object null contained
syn keyword phpType void mixed tuple num stringish this contained
syn match phpType +^array$+ contained

" Hack type declarations.
syn keyword hackTypeDecl type newtype shape contained

syn cluster phpClConst add=hackTypeDecl

hi def link hackTypeDecl Structure

" Hack generic types.
syn region hackGenericType matchgroup=hackGenericType contained
  \ start=+\w\+<+hs=e
  \ end=+>+
  \ contains=phpType,phpClasses,phpInterfaces,hackGenericType

syn cluster phpClConst add=hackGenericType

hi def link hackGenericType Type

" HHVM language features.
syn keyword phpStatement yield await contained
syn keyword phpSCKeyword async contained

" <?hh opener.
syn region phpRegion matchgroup=Delimiter keepend
  \ start=+<?hh\( // partial\| // strict\| // decl\|\)+
  \ end=+?>+
  \ contains=@phpClTop
