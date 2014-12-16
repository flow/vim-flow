# vim-flow

A vim plugin for [Flow][flow]

## Requirements

This plugin requires [Flow][flow] to be installed and 
available on your path.

## Installation

### [Pathogen][pathogen]

    cd ~/.vim/bundle
    git clone git://github.com/facebook/vim-flow.git

### [NeoBundle][neobundle]

Add this to your `~/.vimrc`

```VimL
  NeoBundleLazy 'facebook/vim-flow', {
            \ 'autoload': {
            \     'filetypes': 'javascript'
            \ }}
```

#### With [Flow][flow] build step, using [flow-bin][flowbin]

```VimL
  NeoBundleLazy 'facebook/vim-flow', {
            \ 'autoload': {
            \     'filetypes': 'javascript'
            \ },
            \ 'build': {
            \     'mac': 'npm install -g flow-bin',
            \     'unix': 'npm install -g flow-bin'
            \ }}
```

## Configuration


## `g:flow#autoclose`

If this is set to `1`, the |quickfix| window opened when the plugin finds an error
will close automatically.

Default is `0`.

## `g:flow#enable`

Typechecking is done automatically on `:w` if set to `1`.

To disable this, set to 0 in your ~/.vimrc, like so:
```VimL
let g:flow#enable = 0
```

Default is `1`.

## `g:flow#errjmp`

Jump to errors after typechecking if set to `1`.

Default is `0`.

## `g:flow#flowpath`

Leave this as default to use the flow executable defined on your path. To use
a custom flow executable, set this like so:

```VimL
let g:flow#flowpath = /your/flow-path/flow
```

## `g:flow#qfsize`

Leave this as default to let the plugin decide on the quickfix window size.

[flow]: https://github.com/facebook/flow
[flow-bin]: https://github.com/sindresorhus/flow-bin
[pathogen]: https://github.com/tpope/vim-pathogen
[neobundle]: https://github.com/Shougo/neobundle.vim
