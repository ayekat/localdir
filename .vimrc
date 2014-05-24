" Vim configuration file
" Initially written by ayekat in a snowy day in january 2010

" ------------------------------------------------------------------------------
" GENERAL {{{

" No compatibility with vi for tasty features:
set nocompatible

" }}}
" ------------------------------------------------------------------------------
" BUNDLES {{{

" Initialise and bootstrap NeoBundle (here goes my thanks to flor):
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle/
	if !isdirectory(glob('~/.vim/bundle/neobundle'))
		!mkdir -p ~/.vim/bundle/neobundle && git clone 'https://github.com/Shougo/neobundle.vim.git' ~/.vim/bundle/neobundle
	endif
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle handle itself:
NeoBundleFetch 'Shougo/neobundle.vim'

" Bundles I use:
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vinarise.vim'
NeoBundle 'spolu/dwm.vim'
NeoBundle 'ayekat/dwm_fix.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-scripts/glsl.vim'
NeoBundle 'Matt-Stevens/vim-systemd-syntax'
NeoBundleCheck

" Disable scala and java syntax checkers, as they are slow as hell:
let g:syntastic_java_checkers = []
let g:syntastic_scala_checkers = []

" Disable LaTeX style warnings:
let g:syntastic_tex_chktex_args = '-m'

" Change Sytastic symbols:
let g:syntastic_warning_symbol = '!!'
let g:syntastic_error_symbol = 'XX'

" Don't make unite overwrite the statusline:
let g:unite_force_overwrite_statusline = 0

" Don't use default keybindings of DWM plugin:
let g:dwm_map_keys = 0

" Further settings are defined in the 'behaviour' part.

" }}}
" ------------------------------------------------------------------------------
" LOOK {{{

" Enable 256 colours mode (we handle the TTY case further below):
set t_Co=256

" Display and format line numbers:
set number
set numberwidth=5

" Enable UTF-8 (I wanna see Umlauts!):
set encoding=utf8

" SPLIT WINDOWS >
	
	if $TERM == 'linux'
		set fillchars=vert:.
	else
		set fillchars=vert:┃
	endif
	

" FOLDING >

	" Fill characters (space=don't fill up):
	set fillchars+=fold:\ 

	" Autofolds behaviour:
	set foldmethod=marker


" PROGRAMMING >

	" Without any syntax highlighting, programming is a pain:
	syntax on

	" Fix unrecognised file types:
	au BufRead,BufNewFile *.md set filetype=markdown
	au BufRead,BufNewFile *.tex set filetype=tex
	au BufRead,BufNewFile *.xbm set filetype=c
	au BufRead,BufNewFile *.frag,*.vert,*.geom set filetype=glsl
	au BufRead,BufNewFile dunstrc set filetype=cfg
	au BufRead,BufNewFile *.target set filetype=systemd

	" Assembly:
	let asmsyntax='nasm'

	" C:
	let c_no_curly_error=1 " Allow {} inside [] and () (non-ANSI)
	let c_space_errors=1   " Highlight trailing spaces and spaces before tabs
	let c_syntax_for_h=1   " Treat .h as C header files (instead of C++)

	" Make:
	let make_no_commands=1 " Don't highlight commands

	" PHP:
	let php_sql_query=1    " Highlight SQL syntax inside strings
	let php_htmlInStrings=1         " HTML syntax inside strings

	" Shell:
	let g:is_posix=1       " /bin/sh is POSIX shell, not deprecated Bourne shell

	" Display a bar after a reasonable number of columns:
	if version >= 703
		set colorcolumn=81
		au FileType mail,gitcommit set colorcolumn=73
		au FileType java set colorcolumn=121
		au FileType asm set colorcolumn=41,81
	endif

	" I wanna see tabs and trailing whitespaces:
	set list
	set listchars=tab:→\ ,trail:·

	" Highlight matching parentheses:
	set showmatch

" }}}
" ------------------------------------------------------------------------------
" BEHAVIOUR {{{

" Leader key:
let mapleader='ö'

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
au FileType c,java,php,sh,perl,sql,glsl,cpp au BufWritePre <buffer> :call StripTrailingWhitespaces()

" Save the undo tree between edit:
if v:version >= 703
	if ! isdirectory($HOME . "/.vim/undo")
		call mkdir($HOME . "/.vim/undo", "p")
		!chmod 700 -R ~/.vim/undo
	endif
	set undofile
	" Save it in ~/.vim/undo/ if possible, otherwise same dir as edited file
	set undodir=$HOME/.vim/undo,.
endif

" Make sure we don't generate undofiles for certain files:
if has("autocmd")
	autocmd BufWritePre /tmp/* setlocal noundofile
	autocmd BufWritePre /dev/shm/* setlocal noundofile
	autocmd BufWritePre /run/shm/* setlocal noundofile
endif


" INSERT MODE >

	" Except in LaTeX and Scala, we use 4 spaces per tab and tabs:
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
	au FileType tex,scala,java,ant,haskell set expandtab
	au FileType tex,scala set tabstop=2
	au FileType tex,scala set shiftwidth=2

	" Auto-indent, and reuse the same combination of spaces/tabs:
	set autoindent
	set copyindent
	filetype plugin indent on

	" Visually wrap lines (except in Java), and break words:
	set wrap
	au FileType java set nowrap
	set linebreak      " wrap at words (does not work with list)

	" Physically wrap lines for certain file types:
	au FileType tex,html,php,markdown set textwidth=80
	au FileType gitcommit set textwidth=72

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

" FANCY IDE-LIKE:

	" Show command history:
	nnoremap ; q:
	vnoremap ; q:

	" Show 10 last commands in the window
	set cmdwinheight=10

	" Unite window:
	map <leader>n :Unite file<CR>

" DWM:

	map <leader>j <C-w>w
	map <leader>k <C-w>W
	map <leader><Space> :call DWM_Focus()<CR>

" }}}
" ------------------------------------------------------------------------------
" COLOUR SCHEME {{{

" Make visual less penetrant:
hi Visual cterm=inverse ctermbg=0

" Non-printable characters (tabs, spaces, special keys):
hi SpecialKey cterm=bold ctermfg=238

" Matching parentheses:
hi MatchParen cterm=bold ctermfg=4 ctermbg=none

if $TERM != "linux"
	" Custom colour scheme for X vim {{{
	" Dropdown menu:
	hi Pmenu      ctermfg=244 ctermbg=234
	hi PmenuSel   ctermfg=45  ctermbg=23
	hi PmenuSbar              ctermbg=234
	hi PmenuThumb             ctermbg=31

	" Folding:
	hi Folded ctermfg=248 ctermbg=0 cterm=none

	" Separate normal text from non-file-text:
	"hi Normal                 ctermbg=234
	hi NonText    ctermfg=0   ctermbg=232 cterm=bold
	"
	" Window separator:
	hi VertSplit  ctermfg=0 ctermbg=0
	"
	" Line numbers and syntastic column:
	hi SignColumn ctermbg=none
	hi LineNr     ctermbg=0

	" 80 columns indicator:
	hi ColorColumn ctermbg=235

	" Search:
	hi Search             ctermfg=0  ctermbg=136

	" Diffs:
	hi DiffAdd            ctermfg=46  ctermbg=22
	hi DiffChange         ctermfg=45  ctermbg=24
	hi DiffDelete         ctermfg=52  ctermbg=232
	hi DiffText           ctermfg=226 ctermbg=94 cterm=none

	" Syntax:
	hi Comment            ctermfg=243
	hi Constant           ctermfg=34
		" any constant | string | 'c' '\n' | 234 0xff | TRUE false | 2.3e10
		"hi String         ctermfg=
		"hi Character      ctermfg=
		"hi Number         ctermfg=
		"hi Boolean        ctermfg=
		"hi Float          ctermfg=
	hi Identifier         ctermfg=169
		" any variable name | function name (also: methods for classes)
		"hi Function       ctermfg=
	hi Statement          ctermfg=172
		" any statement | if then else endif switch | for do while |
		" case default | sizeof + * | any other keyword | exception
		"hi Conditional
		"hi Repeat
		"hi Label
		"hi Operator
		"hi Keyword
		"hi Exception
	hi PreProc            ctermfg=169
		" any preprocessor | #include | #define | macro | #if #else #endif
		"hi Include
		"hi Define
		"hi Macro
		"hi PreCondit
	hi Type               ctermfg=38
		" int long char | static register volatile | struct union enum | typedef
		"hi StorageClass
		"hi Structure
		"hi Typedef
	hi Special            ctermfg=136
		"hi SpecialChar
		"hi Tag
		"hi Delimiter
		"hi SpecialComment
		"hi Debug
	" TODO
	hi Todo               ctermfg=148 ctermbg=22
	hi Error              ctermfg=88 ctermbg=9 cterm=bold
		"hi SyntasticErrorSign
	" }}}
else
	" Custom colour scheme for TTY vim {{{
	set background=light

	" Window separator:
	hi VertSplit ctermfg=4 ctermbg=4 cterm=none

	" Folding:
	hi Folded ctermfg=3 ctermbg=8 cterm=none

	" Line numbers:
	hi LineNr ctermfg=3 ctermbg=0

	" Search:
	hi Search             ctermfg=0  ctermbg=3

	" Syntax:
	hi Statement ctermfg=3
	hi Todo ctermbg=3
	" }}}
endif


" }}}
" ------------------------------------------------------------------------------
" STATUSLINE {{{
" Written by ayekat on a cold day in december 2012, updated in december 2013

" Always display the statusline:
set laststatus=2

" Don't display the mode in the ruler; we display it in the statusline:
set noshowmode

" Separators {{{
if $TERM == "linux"
	let lsep="|"
	let lfsep="|"
	let rsep="|"
	let rfsep="|"
	let lnum="LN"
	let branch="|'"
else
	let lsep=""
	let lfsep=""
	let rsep=""
	let rfsep=""
	let lnum=""
	let branch=""
endif " }}}

" Colours {{{
if $TERM == 'linux'
	hi StatusLine   ctermfg=0 ctermbg=7 cterm=none
	hi StatusLineNC ctermfg=7 ctermbg=4 cterm=none
else
	" normal statusline:
	hi normal_mode           ctermfg=22  ctermbg=148
	hi normal_mode_end       ctermfg=148 ctermbg=8
	hi normal_git_symbol     ctermfg=7   ctermbg=8
	hi normal_git_branch     ctermfg=7   ctermbg=8
	hi normal_file           ctermfg=247 ctermbg=8
	hi normal_file_emphasise ctermfg=7   ctermbg=8
	hi normal_file_modified  ctermfg=3   ctermbg=8
	hi normal_file_end       ctermfg=8   ctermbg=236
	hi normal_middle         ctermfg=244 ctermbg=236
	hi normal_warning        ctermfg=1   ctermbg=236
	hi normal_pos_start      ctermfg=8   ctermbg=236
	hi normal_pos            ctermfg=11  ctermbg=8
	hi normal_cursor_start   ctermfg=7   ctermbg=8
	hi normal_cursor         ctermfg=0   ctermbg=7
	hi normal_cursor_line    ctermfg=236 ctermbg=7
	hi normal_cursor_col     ctermfg=8   ctermbg=7

	hi visual_mode           ctermfg=52  ctermbg=208
	hi visual_mode_end       ctermfg=208 ctermbg=8

	hi insert_mode           ctermfg=8   ctermbg=7
	hi insert_mode_end       ctermfg=7   ctermbg=31
	hi insert_git_symbol     ctermfg=7   ctermbg=31
	hi insert_git_branch     ctermfg=7   ctermbg=31
	hi insert_file           ctermfg=249 ctermbg=31
	hi insert_file_emphasise ctermfg=7   ctermbg=31
	hi insert_file_modified  ctermfg=3   ctermbg=31
	hi insert_file_end       ctermfg=31  ctermbg=23
	hi insert_middle         ctermfg=45  ctermbg=23
	hi insert_warning        ctermfg=1   ctermbg=23
	hi insert_pos_start      ctermfg=31  ctermbg=23
	hi insert_pos            ctermfg=11  ctermbg=31
	hi insert_cursor_start   ctermfg=7   ctermbg=31

	" command statusline:
	hi cmd_mode              ctermfg=15  ctermbg=64
	hi cmd_mode_end          ctermfg=64  ctermbg=0
	hi cmd_info              ctermfg=7   ctermbg=0

	" cursor:
	hi CursorLine                        ctermbg=235 cterm=none
	hi CursorLineNr          ctermfg=45  ctermbg=23

	" default statusline:
	hi StatusLine            ctermfg=0   ctermbg=236 cterm=none
	hi StatusLineNC          ctermfg=241 ctermbg=236 cterm=none
endif
" }}}

" Active Statusline {{{
function! StatuslineActive()
	let l:statusline = ''
	let l:mode = mode()
	let l:unite = unite#get_status_string()
	let l:git_branch = fugitive#head()

	" Mode {{{
	if l:mode ==? 'v' || l:mode == ''
		let l:statusline .= '%#visual_mode#'
		if l:mode ==# 'v'
			let l:statusline .= ' VISUAL '
		elseif l:mode ==# 'V'
			let l:statusline .= ' V·LINE '
		else
			let l:statusline .= ' V·BLOCK '
		endif
		let l:statusline .= '%#visual_mode_end#'
	elseif l:mode == 'i'
		let l:statusline .= '%#insert_mode# INSERT %#insert_mode_end#'
	else
		let l:statusline .= '%#normal_mode# NORMAL %#normal_mode_end#'
	endif
	let l:statusline .= '%{rfsep}'
	" }}}

	" Git {{{
	if l:git_branch != ''
		if l:mode == 'i'
			let l:statusline .= '%#insert_git_symbol#'
		else
			let l:statusline .= '%#normal_git_symbol#'
		endif
		let l:statusline .= ' %{branch} '
		if l:mode == 'i'
			let l:statusline .= '%#insert_git_branch#'
		else
			let l:statusline .= '%#normal_git_branch#'
		endif
		let l:statusline .= l:git_branch
	endif " }}}

	" Filename {{{
	if l:mode == 'i'
		let l:statusline .= '%#insert_file#'
	else
		let l:statusline .= '%#normal_file#'
	endif
	if l:git_branch != ''
		let l:statusline .= ' %{rsep}'
	endif
	let l:statusline.=' %<%{expand("%:p:h")}/'
	if l:mode == 'i'
		let l:statusline.='%#insert_file_emphasise#'
	else
		let l:statusline.='%#normal_file_emphasise#'
	endif
	let l:statusline.='%{expand("%:t")} '
	" }}}

	" Modified {{{
	if &modified
		if l:mode == 'i'
			let l:statusline .= '%#insert_file_modified#'
		else
			let l:statusline .= '%#normal_file_modified#'
		endif
		let l:statusline .= '* '
	endif
	" }}}

	if l:mode == 'i'
		let l:statusline .= '%#insert_file_end#%{rfsep}%#insert_middle# '
	else
		let l:statusline .= '%#normal_file_end#%{rfsep}%#normal_middle# '
	endif

	" Readonly {{{
	if &readonly
		if l:mode == 'i'
			let l:statusline .= ' %#insert_warning#X%#insert_middle#'
		else
			let l:statusline .= ' %#normal_warning#X%#normal_middle#'
		endif
	endif
	" }}}

	" Unite.vim {{{
	if l:unite != ''
		let l:statusline .= ' '.l:unite
	endif
	" }}}

	let l:statusline .= '%='

	" File format, encoding, type, line count {{{
	if l:unite == ''
		if &fileformat != 'unix'
			let l:statusline .= &fileformat.' %{lsep} '
		endif
		if &fileencoding != 'utf-8' && &fileencoding != 'ascii'
			let l:statusline .= &fileencoding.' %{lsep} '
		endif
		let l:statusline .= &filetype.' %{lsep} '
		let l:statusline .= '%L %{lnum} '
	endif
	" }}}

	" Buffer position {{{
	if l:mode == 'i'
		let l:statusline .= '%#insert_pos_start#%{lfsep}%#insert_pos#'
	else
		let l:statusline .= '%#normal_pos_start#%{lfsep}%#normal_pos#'
	endif
	let l:statusline .= '  %P '
	" }}}

	" Cursor position {{{
	if l:mode == 'i'
		let l:statusline .= '%#insert_cursor_start#'
	else
		let l:statusline .= '%#normal_cursor_start#'
	endif
	let l:statusline .= '%{lfsep}'
	let l:statusline .= '%#normal_cursor_line# %3l'
	let l:statusline .= '%#normal_cursor_col#:%02c %#normal_middle#'
	" }}}

	return l:statusline
endfunction
" }}}

" Inactive Statusline {{{
function! StatuslineInactive()
	let l:statusline = ''
	let l:branch = fugitive#head()
	let l:unite = unite#get_status_string()

	" mode:
	let l:statusline .= '        %{rsep}'

	" filename:
	let l:statusline.=' %<%t %{rsep}'

	" change to the right side:
	let l:statusline.='%='

	" line count:
	let l:statusline .= '%L %{lnum} '

	" buffer position:
	let l:statusline.='%{lsep}  %P '

	" cursor position:
	let l:statusline .= '%{lsep} %3l:%02c '

	return l:statusline
endfunction " }}}

function! StatuslineCommand() " {{{
	return '%#cmd_mode# COMMAND %#cmd_mode_end#%{rfsep}'
endfunction " }}}

" define when which statusline is displayed:
au! BufEnter,WinEnter * setl statusline=%!StatuslineActive()
au! BufLeave,WinLeave * set  statusline=%!StatuslineInactive()
au! CmdwinEnter       * setl statusline=%!StatuslineCommand()

" }}}
" ------------------------------------------------------------------------------
" LINE NUMBERS {{{
" Make line number design change as a function of mode.

if $TERM != 'linux'
	function! SetLineNr(mode)
		if a:mode == 'v'
			hi LineNr ctermfg=172
		else
			hi LineNr ctermfg=242
		endif
	endfunction

	" insert mode:
	au! InsertEnter * set cursorline | call SetLineNr('i')
	au! InsertLeave * set nocursorline

	" visual mode (ugly, since there is no VisualEnter/VisualLeave):
	noremap <silent> v :call SetLineNr('v')<CR>v
	noremap <silent> V :call SetLineNr('v')<CR>V
	noremap <silent> <C-v> :call SetLineNr('v')<CR><C-v>
	set updatetime=0
	au! CursorHold * call SetLineNr('n')
endif

" }}}
" ------------------------------------------------------------------------------
" MISC {{{
" Rather temporary settings, but they remain for like half a year (often for
" EPFL courses).

au! BufEnter /home/ayekat/epfl/cg/{*.c,*.h,*.vert,*.geom,*.frag} set expandtab
au! BufEnter /home/ayekat/epfl/os/{*.c,*.h} set tabstop=8 shiftwidth=8
" }}}
