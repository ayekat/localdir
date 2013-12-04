" Vim configuration file
" Initially written by ayekat in a snowy day in january 2010

" ------------------------------------------------------------------------------
" GENERAL {{{

" No compatibility with vi for tasty features:
set nocompatible

" }}}
" ------------------------------------------------------------------------------
" LOOK {{{

" Enable 256 colours mode (we handle the TTY case further below):
set t_Co=256

" Display and format line numbers:
set number
set numberwidth=5

" Separate content and empty parts of file (only if non-TTY):
if $TERM != "linux"
	hi NonText cterm=bold ctermbg=232 ctermfg=0
endif

" Enable UTF-8 (I wanna see Umlauts!):
set encoding=utf8

" SPLIT WINDOWS >
	
	" Define border colour:
	hi VertSplit ctermfg=0 ctermbg=232

	" Fill up with solid bar:
	set fillchars=vert:┃
	

" FOLDING >

	" Define colour:
	if $TERM == "linux"
		hi Folded ctermfg=3 ctermbg=255 cterm=none
	else
		hi Folded ctermfg=208 ctermbg=0 cterm=none
	endif

	" Define fill characters (space=don't fill up):
	set fillchars+=fold:\ 

	" Specify how vim autofolds:
	set foldmethod=marker


" PROGRAMMING >

	" Without any syntax highlighting, programming is a pain:
	syntax on

	" Fix unrecognised file types:
	au BufRead,BufNewFile *.tex set filetype=tex
	au BufRead,BufNewFile *.h set filetype=c

	" Treat /bin/sh as POSIX shell, not deprecated Bourne shell:
	let g:is_posix=1
	
	" Display a bar after a reasonable number of columns:
	if version >= 703
		set colorcolumn=81
		if $TERM == "linux"
			hi ColorColumn ctermbg=255
		else
			hi ColorColumn ctermbg=0
		endif
		au FileType gitcommit set colorcolumn=73
		au FileType java set colorcolumn=121
		au FileType asm set colorcolumn=41,81
	endif

	" I wanna see tabs and trailing whitespaces:
	set list listchars=tab:→\ ,trail:·
	hi SpecialKey cterm=bold ctermfg=0

	" Highlight matching parentheses:
	set showmatch
	hi MatchParen cterm=bold ctermfg=4 ctermbg=none

	" Style the Syntastic bar on the left:
	hi SignColumn ctermbg=0

" }}}
" ------------------------------------------------------------------------------
" BEHAVIOUR {{{

" Keep 3 lines 'padding' above/below the cursor:
set scrolloff=3

" Simplify window scrolling:
map K 3<C-y>
map J 3<C-e>

" Modelines are evil!
set nomodeline

" Fix trailing whitespaces:
function! StripTrailingWhitespaces()
	let _s=@/
	let l=line('.')
	let c=col('.')
	%s/\s\+$//eg
	call cursor(l,c)
	let @/=_s
endfunction
au FileType c,java,php,sh au BufWritePre <buffer> :call StripTrailingWhitespaces()


" INSERT MODE >

	" Except in LaTeX and Scala, we use 4 spaces per tab and tabs:
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
	au FileType tex,scala,java,xml,ant set expandtab " XML = EPFL fuckery
	au FileType tex,scala set tabstop=2
	au FileType tex,scala set shiftwidth=2

	" Auto-indent, and reuse the same combination of spaces/tabs:
	set autoindent
	set copyindent

	" Wrap lines (except in Java), and break words:
	set wrap
	au FileType java set nowrap
	set linebreak      " doesn't seem to work correctly

	" Remove delay for leaving insert mode:
	set noesckeys

" NORMAL MODE >

	" Display commands when typing:
	set showcmd

	" Highlight search results and display them immediately as they are typed:
	set hlsearch
	set incsearch

	" Ignore case when searching, except when explicitely using majuscules:
	set ignorecase
	set smartcase

	" Moving the cursor on visual lines is much more intuitive with 'g':
	map k gk
	map j gj

	" Word-breaking characters:
	set iskeyword-=[.]

	" Manual pages:
	map M :exe ":!man '".expand('<cword>')."'"<cr>

" }}}
" ------------------------------------------------------------------------------
" COLOUR SCHEME {{{

" Make visual less penetrant:
hi Visual cterm=inverse ctermbg=0

" Custom colour scheme for X vim:
if $TERM != "linux"
	" Dropdown menu:
	hi Pmenu      ctermfg=244 ctermbg=0
	hi PmenuSel   ctermfg=45  ctermbg=23
	hi PmenuSbar              ctermbg=0
	hi PmenuThumb             ctermbg=31

	" comment
	hi Comment            ctermfg=242

	" any constant | string | 'c' '\n' | 234 0xff | TRUE false | 2.3e10
	hi Constant           ctermfg=2
		"hi String         ctermfg=
		"hi Character      ctermfg=
		"hi Number         ctermfg=
		"hi Boolean        ctermfg=
		"hi Float          ctermfg=

	" any variable name | function name (also: methods for classes)
	hi Identifier         ctermfg=166
		"hi Function       ctermfg=

	" any statement | if then else endif switch | for do while | case default |
	" sizeof + * | any other keyword | exception
	hi Statement          ctermfg=142
		"hi Conditional
		"hi Repeat
		"hi Label
		"hi Operator
		"hi Keyword
		"hi Exception

	" any preprocessor | #include | #define | macro | #if #else #endif
	hi PreProc            ctermfg=30
		"hi Include
		"hi Define
		"hi Macro
		"hi PreCondit

	" int long char | static register volatile | struct union enum | typedef
	hi Type               ctermfg=12
		"hi StorageClass
		"hi Structure
		"hi Typedef
	
	" Special
	hi Special            ctermfg=136
		"hi SpecialChar
		"hi Tag
		"hi Delimiter
		hi SpecialComment ctermfg=58
		"hi Debug

	" Todo
	hi Todo               ctermfg=22 ctermbg=148

	" Error
	hi Error              cterm=bold ctermfg=88 ctermbg=9
		"hi SyntasticErrorSign

	" Search
	hi Search ctermbg=3 ctermfg=0
else
	hi Todo ctermbg=3
endif


" }}}
" ------------------------------------------------------------------------------
" STATUS BAR {{{
" Written by ayekat on a cold day in december 2012, updated in december 2013

" Always display the statusline:
set laststatus=2

" Don't display the mode in the ruler; we display it in the statusline:
set noshowmode

" Define default statusline background to get rid of funnily coloured corners:
hi StatusLine   ctermfg=0 ctermbg=0 cterm=none
hi StatusLineNC ctermfg=8 ctermbg=0 cterm=none

" define seperators:
if $TERM == "linux"
	let lsep="|"
	let lfsep=""
	let rsep="|"
	let rfsep=""
	let lnum="LN"
else
	let lsep=""
	let lfsep=""
	let rsep=""
	let rfsep=""
	let lnum=""
endif

" define colours:
if $TERM == 'linux'
	" normal mode (default):
	hi normal_name           ctermfg=0   ctermbg=2
	hi normal_file           ctermfg=15  ctermbg=240
	hi normal_middle         ctermfg=7   ctermbg=0
	hi normal_warning        ctermfg=1   ctermbg=0
	hi normal_pos            ctermfg=15  ctermbg=240
	hi normal_filetype       ctermfg=0   ctermbg=7

	" visual mode:
	hi visual_name           ctermfg=0   ctermbg=3

	" insert mode:
	hi insert_name           ctermfg=0   ctermbg=6
	hi insert_file           ctermfg=7   ctermbg=4
	hi insert_pos            ctermfg=7   ctermbg=4

	" cursor:
	hi CursorLineNr ctermfg=7 ctermbg=4
else
	" normal mode (default):
	hi normal_name           ctermfg=22  ctermbg=148
	hi normal_name_end       ctermfg=148 ctermbg=8
	hi normal_file           ctermfg=7   ctermbg=8
	hi normal_file_modified  ctermfg=3   ctermbg=8   cterm=bold
	hi normal_file_end       ctermfg=8   ctermbg=0
	hi normal_middle         ctermfg=244 ctermbg=0
	hi normal_warning        ctermfg=1   ctermbg=0   cterm=bold
	hi normal_pos_start      ctermfg=8   ctermbg=0
	hi normal_pos            ctermfg=250 ctermbg=8
	hi normal_filetype_start ctermfg=7   ctermbg=8
	hi normal_filetype       ctermfg=8   ctermbg=7

	" visual mode:
	hi visual_name           ctermfg=52  ctermbg=208
	hi visual_name_end       ctermfg=208 ctermbg=8

	" insert mode:
	hi insert_name           ctermfg=8   ctermbg=7
	hi insert_name_end       ctermfg=7   ctermbg=31
	hi insert_file           ctermfg=7   ctermbg=31
	hi insert_file_modified  ctermfg=3   ctermbg=31  cterm=bold
	hi insert_file_end       ctermfg=31  ctermbg=23
	hi insert_warning        ctermfg=1   ctermbg=23  cterm=bold
	hi insert_middle         ctermfg=45  ctermbg=23
	hi insert_pos_start      ctermfg=31  ctermbg=23
	hi insert_pos            ctermfg=250 ctermbg=31
	hi insert_filetype_start ctermfg=7   ctermbg=31

	" cursor:
	hi CursorLine ctermbg=234 cterm=none
	hi CursorLineNr ctermfg=45 ctermbg=23
endif

" Determines the filename:
function! GetFilepath()
	let filepath = expand("%:p")
	return (filepath == '') ? "[No Name]" : filepath
endfunction

" Determines the file format (unix, dos, mac):
function! GetFileformat(var)
	return (a:var == 'unix') ? '' : a:var
endfunction

" Draws the active statusbar:
function! StatuslineActive()
	let l:statusline = ''
	let l:mode = mode()

	" mode indicator:
	if l:mode ==? 'v' || l:mode == ''
		let l:statusline .= '%#visual_name#'
		if     l:mode ==# 'v' | let l:statusline .= ' VISUAL '
		elseif l:mode ==# 'V' | let l:statusline .= ' V·LINE '
		else                  | let l:statusline .= ' V·BLOCK '
		endif
		let l:statusline .= '%#visual_name_end#'
	elseif l:mode == 'i'
		let l:statusline .= '%#insert_name# INSERT %#insert_name_end#'
	else
		let l:statusline .= '%#normal_name# NORMAL %#normal_name_end#'
	endif
	let l:statusline .= '%{rfsep}'

	"file name:
	if l:mode == 'i'
		let l:statusline .= '%#insert_file#'
	else
		let l:statusline .= '%#normal_file#'
	endif
	let l:statusline .= ' %<%{GetFilepath()} '

	" modified:
	if &modified
		if l:mode == 'i'
			let l:statusline .= '%#insert_file_modified#'
		else
			let l:statusline .= '%#normal_file_modified#'
		endif
		let l:statusline .= '* '
	endif

	if l:mode == 'i'
		let l:statusline .= '%#insert_file_end#%{rfsep}%#insert_middle# '
	else
		let l:statusline .= '%#normal_file_end#%{rfsep}%#normal_middle# '
	endif

	" readonly:
	if &readonly
		if l:mode == 'i'
			let l:statusline .= '%#insert_warning#RO%#insert_middle# '
		else
			let l:statusline .= '%#normal_warning#RO%#normal_middle# '
		endif
	endif

	" align right:
	let l:statusline .= '%='

	" file format:
	let l:statusline .= '%{GetFileformat(&fileformat)} '

	" cursor position:
	let l:statusline .= '%{lsep} %02c(%02v) '
	
	if l:mode == 'i'
		let l:statusline .= '%#insert_pos_start#%{lfsep}%#insert_pos#'
	else
		let l:statusline .= '%#normal_pos_start#%{lfsep}%#normal_pos#'
	endif
	let l:statusline .= '  %{lnum}  %02l/%L (%P) '

	" file type:
	if l:mode == 'i'
		let l:statusline .= '%#insert_filetype_start#'
	else
		let l:statusline .= '%#normal_filetype_start#'
	endif
	let l:statusline .= '%{lfsep}%#normal_filetype# %Y '

	return l:statusline
endfunction

" Draws the inactive statusbar:
function! StatuslineInactive()
	let l:statusline=''
	" filename:
	let l:statusline.='        %{rsep} %<%{GetFilepath()} %{rsep}'

	" change to the right side:
	let l:statusline.='%='

	" cursor position (column):
	let l:statusline.='%{lsep} %02c(%02v) '

	" buffer position (line):
	let l:statusline.='%{lsep}  %{lnum}  %02l/%L (%P) '

	" file type:
	let l:statusline.='%{lsep} %Y '

	return l:statusline
endfunction

" define when which statusline is displayed:
au! BufLeave,WinLeave * set statusline=%!StatuslineInactive()
au! BufEnter,WinEnter,VimEnter * setl statusline=%!StatuslineActive()

" }}}
" ------------------------------------------------------------------------------
" LINE NUMBERS {{{
" Make line number design change as a function of mode.

" Sets the line number colour:
function! SetLineNr(mode)
	if $TERM == 'linux'
		if a:mode == 'v'
			hi LineNr ctermfg=3
		else
			hi LineNr ctermfg=7
		endif
	else
		if a:mode == 'v'
			hi LineNr ctermfg=208
		else
			hi LineNr ctermfg=242
		endif
	endif
endfunction

" insert mode:
if $TERM != 'linux'
	au! InsertEnter * set cursorline | call SetLineNr('i')
	au! InsertLeave * set nocursorline
endif

" visual mode (quite ugly, since there is no VisualEnter or VisualLeave):
noremap <silent> v :call SetLineNr('v')<CR>v
noremap <silent> V :call SetLineNr('v')<CR>V
noremap <silent>  :call SetLineNr('v')<CR><C-v>
set updatetime=0
au! CursorHold * call SetLineNr('n')

" }}}
" ------------------------------------------------------------------------------
" BUNDLES {{{

" Bundles are handled by vundle, so initialise it hereby:
function! InitVundle()
	set runtimepath+=~/.vim/bundle/vundle/
	call vundle#rc()

	Bundle 'gmarik/vundle'
	Bundle 'spolu/dwm.vim'
	Bundle 'tpope/vim-fugitive'
	Bundle 'tpope/vim-surround'
	Bundle 'scrooloose/syntastic'
endfunction
" This is going to be called at the end of .vimrc, so everything is pretty. ^^

" Bootstrap vundle (here goes my thanks to flor):
if !isdirectory(glob('~/.vim/bundle/vundle'))
	" see .local/bin/vundlebootstrap
	!vundlebootstrap
	call InitVundle()
	BundleInstall
else
	call InitVundle()
endif

" Disable scala and java syntax checkers, as they are slow as hell:
let g:syntastic_java_checkers=[]
let g:syntastic_scala_checkers=[]

" }}}

