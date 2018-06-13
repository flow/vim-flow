if exists("b:current_syntax")
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif

" classify flow flag
syntax match flowAnnotationFlag "@flow" contained
  \ containedin=jsComment

" classify keywords, that indicate flow comment include
syntax match flowTypeCommentKeyword "::"
syntax match flowTypeCommentKeyword "flow-include"

" classify flow comment include and type annotation regions
" - \/\*                    - (= "/*") begin of a js block comment
" - \%(::\?\|flow-include\) - check for keywords to begin type comments
" - \@=                     - check but don't include in the matched
"                             group
" - \*\/                    - (= "*/") end of a js block comment
syntax region flowTypeComment matchgroup=jsComment
  \ transparent fold keepend
  \ start="\/\*\%(::\?\|flow-include\)\@=" end="\*\/"
  \ contains=jsFlowArgumentDef,jsFlowClassGroup,jsFlowType,
  \          jsFlowTypeStatement,flowTypeCommentKeyword
  \ containedin=js.*Block,jsClassDefinition,jsCommentFunction,jsFuncArgs

" highlight the appropriate syntax elements accordingly
highlight default link flowAnnotationFlag Special
highlight default link flowTypeCommentKeyword Comment

if exists("s:current_syntax")
  let b:current_syntax=s:current_syntax
endif
