" Vim syntax file
" Language:     Hack (PHP)
" Maintainer:   Max Wang <mwang@fb.com>
" URL:          https://github.com/hhvm/vim-hack
" Last Change:  April 3, 2014
"
" This file contains all the PHP builtin classes not considered generic by Hack.

syntax keyword phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ stdClass __PHP_Incomplete_Class php_user_filter Directory ArrayObject
  \ Exception ErrorException LogicException BadFunctionCallException BadMethodCallException DomainException
  \ RecursiveIteratorIterator IteratorIterator FilterIterator RecursiveFilterIterator ParentIterator LimitIterator
  \ CachingIterator RecursiveCachingIterator NoRewindIterator AppendIterator InfiniteIterator EmptyIterator
  \ RecursiveArrayIterator DirectoryIterator RecursiveDirectoryIterator
  \ InvalidArgumentException LengthException OutOfRangeException RuntimeException OutOfBoundsException
  \ OverflowException RangeException UnderflowException UnexpectedValueException
  \ PDO PDOException PDOStatement PDORow
  \ Reflection ReflectionFunction ReflectionParameter ReflectionMethod ReflectionClass
  \ ReflectionObject ReflectionProperty ReflectionExtension ReflectionException
  \ SplFileInfo SplFileObject SplTempFileObject SplObjectStorage
  \ XMLWriter LibXMLError XMLReader SimpleXMLElement SimpleXMLIterator
  \ DOMException DOMStringList DOMNameList DOMDomError DOMErrorHandler
  \ DOMImplementation DOMImplementationList DOMImplementationSource
  \ DOMNode DOMNameSpaceNode DOMDocumentFragment DOMDocument DOMNodeList DOMNamedNodeMap
  \ DOMCharacterData DOMAttr DOMElement DOMText DOMComment DOMTypeinfo DOMUserDataHandler
  \ DOMLocator DOMConfiguration DOMCdataSection DOMDocumentType DOMNotation DOMEntity
  \ DOMEntityReference DOMProcessingInstruction DOMStringExtend DOMXPath

syn match phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ "\v<%(ArrayIterator)>"
