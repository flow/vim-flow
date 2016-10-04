# vim-flow

A vim plugin for [Flow][flow].

 - Adds completions to `omnifunc`
 - Checks JavaScript files for type errors on save

## Requirements

 - Requires [Flow][flow] to be installed and available on your path
 - Requires the project to be initialised with `flow init`
 - Requires JavaScript files to be marked with `/* @flow */` or `/* @flow weak */` at the top

## Installation

### [Pathogen][pathogen]

    cd ~/.vim/bundle
    git clone git://github.com/flowtype/vim-flow.git

### [NeoBundle][neobundle]

Add this to your `~/.vimrc`

```VimL
  NeoBundleLazy 'flowtype/vim-flow', {
            \ 'autoload': {
            \     'filetypes': 'javascript'
            \ }}
```

#### With [Flow][flow] build step, using [flow-bin][flowbin]

```VimL
  NeoBundleLazy 'flowtype/vim-flow', {
            \ 'autoload': {
            \     'filetypes': 'javascript'
            \ },
            \ 'build': {
            \     'mac': 'npm install -g flow-bin',
            \     'unix': 'npm install -g flow-bin'
            \ }}
```
## Usage

Unless [disabled manually][gflowenable], vim-flow will check JavaScript and JSX files on save.

## Commands

#### `FlowMake`

Triggers a type check for the current file.

#### `FlowToggle`

Turns automatic checks on save on or off.

#### `FlowType` 

Display the type of the variable under the cursor.

#### `FlowJumpToDef` 

Jump to the definition of the variable under the cursor.

## Configuration

#### `g:flow#autoclose`

If this is set to `1`, the |quickfix| window opened when the plugin finds an error
will close automatically.

Default is `0`.

#### `g:flow#enable`

Typechecking is done automatically on `:w` if set to `1`.

To disable this, set to `0` in your ~/.vimrc, like so:

```VimL
let g:flow#enable = 0
```

Default is `1`.

#### `g:flow#errjmp`

Jump to errors after typechecking if set to `1`.

Default is `0`.

#### `g:flow#flowpath`

Leave this as default to use the flow executable defined on your path. To use
a custom flow executable, set this like so:

```VimL
let g:flow#flowpath = /your/flow-path/flow
```

#### `g:flow#omnifunc`

By default `omnifunc` will be set to provide omni completion. To disable it
(prevent overwriting an existed omnifunc), set this value to 0:

```VimL
let g:flow#omnifunc = 0
```

#### `g:flow#timeout`

By default `timeout` will be set to 2 seconds. If you are working on a larger
codebase, you may want to increase this to avoid errors when Flow initializes.

```VimL
let g:flow#timeout = 4
```

#### `g:flow#qfsize`

Leave this as default to let the plugin decide on the quickfix window size.

[gflowenable]: https://github.com/flowtype/vim-flow#gflowenable
[flow]: https://github.com/facebook/flow
[flowbin]: https://github.com/sindresorhus/flow-bin
[pathogen]: https://github.com/tpope/vim-pathogen
[neobundle]: https://github.com/Shougo/neobundle.vim
