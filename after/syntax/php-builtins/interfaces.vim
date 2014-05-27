" Vim syntax file
" Language:     Hack (PHP)
" Maintainer:   Max Wang <mwang@fb.com>
" URL:          https://github.com/hhvm/vim-hack
" Last Change:  April 3, 2014
"
" This file contains all the PHP builtin interfaces not considered generic by Hack.

syntax keyword phpInterfaces containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ RecursiveIterator OuterIterator SeekableIterator
  \ SplObserver SplSubject Reflector

syn match phpInterfaces containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ "\v<%(ArrayAccess|ArrayIterator|Iterator|IteratorAggregate|Traversable|Serializable|Countable)>"
