" Vim configuration file
" written by ayekat in a snowy day in january 2010


" ------------------------------------------------------------------------------
" GENERAL

" No compatibility with vi => more tasty features:
set nocompatible

" Activate pathogen => even *more* tasty features:
call pathogen#infect()


" ------------------------------------------------------------------------------
" LOOK

" Enable 256 colours mode (we handle the TTY case further below):
set t_Co=256

" Displays darker colours, more confortable for the eyes:
set background=light

" Display and format line numbers:
set number
set numberwidth=5

" Highlight end of file (only in non-TTY):
if $TERM != "linux"
	hi NonText cterm=bold ctermbg=232 ctermfg=blue
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
	hi Folded cterm=bold ctermbg=0 ctermfg=4

	" Define fill characters (space=don't fill up):
	set fillchars+=fold:\ 

	" Specify how vim autofolds:
	set foldmethod=marker


" PROGRAMMING >

	" Without any syntax highlighting, programming is a pain:
	syntax on

	" (La)TeX files are sometimes not recognised correctly:
	au BufRead,BufNewFile *.tex set filetype=tex

	" Header files ending with .h are C:
	au BufRead,BufNewFile *.h set filetype=c

	" Treat /bin/sh as POSIX shell, not deprecated Bourne shell:
	let g:is_posix=1
	
	" Display a bar after a reasonable number of columns:
	if version >= 703
		set colorcolumn=81
		hi ColorColumn ctermbg=0
		"let &colorcolumn=join(range(81,999),",")
		"hi ColorColumn ctermbg=232
		au FileType gitcommit set colorcolumn=73
		au FileType asm set colorcolumn=41,81
	endif

	" Automatically wrap after a certain number of columns:
	"set textwidth=80
	"au FileType gitcommit set textwidth=72

	" I wanna see tabs and trailing whitespaces:
	set list listchars=tab:→\ ,trail:·
	hi SpecialKey cterm=bold ctermfg=0

	" Highlight maching parantheses:
	set showmatch
	hi MatchParen cterm=bold ctermfg=5 ctermbg=none

	" Style the Syntastic bar on the left:
	hi SignColumn ctermbg=0


" ------------------------------------------------------------------------------
" COLOURS {{{
" Colours and theme redefinitions.

" Fix ugly urxvt/vim yellow:
hi Statement ctermfg=3
hi Todo ctermbg=3
hi Search ctermbg=3 ctermfg=0

" Make visual less penetrant:
hi Visual cterm=inverse ctermbg=0

" Fancy dropdown menu:
hi Pmenu ctermbg=0 ctermfg=2
hi PmenuSel ctermbg=2 ctermfg=0
hi PmenuSbar ctermbg=0
hi PmenuThumb ctermbg=2


" }}}
" ------------------------------------------------------------------------------
" STATUS BAR {{{
" Written by ayekat on a cold day in december 2012

" Always display the statusline:
set laststatus=2

" Don't display the mode in the ruler; we display it in the statusline:
set noshowmode

" Define default statusline background to get rid of funnily coloured corners:
hi StatusLine   ctermfg=0 ctermbg=0 cterm=none
hi StatusLineNC ctermfg=8 ctermbg=0 cterm=none
hi User0        ctermfg=8 ctermbg=0 cterm=none
hi User9        ctermfg=1 ctermbg=0 cterm=none

" Define line number style for insert mode:
hi CursorLine cterm=none
if $TERM == "linux"
	hi CursorLineNr ctermfg=7 ctermbg=4
else
	hi CursorLineNr ctermfg=7 ctermbg=31
endif

" Define seperator icons:
if $TERM == "linux"
	let lsep="|"
	let lfsep=""
	let rsep="|"
	let rfsep=""
	let lnum="LN"
else
	let lsep="⮃"
	let lfsep="⮂"
	let rsep="⮁"
	let rfsep="⮀"
	let lnum="⭡"
endif

" This function determines the filename:
function! GetFilepath()
	let filepath=expand("%:p")
	let filepath=(filepath == '')?"[No Name]":filepath
	return filepath
endfunction

" This function defines the inactive statusbar content:
function! StatuslineInactive()
	" filename:
	set statusline=%0*\ \ \ \ \ \ \ \ %{rsep}\ \ %<%{GetFilepath()}\ \ %{rsep}

	" change to the right side:
	set statusline+=%=

	" cursor position (column):
	set statusline+=\ \ %{lsep}\ \ %02c(%02v)

	" buffer position (line):
	set statusline+=\ %{lsep}\ \ %{lnum}\ \ %02l/%L\ (%P)

	" file type:
	set statusline+=\ %{lsep}\ %Y\ %0*
endfunction

" This function defines the active statusbar content:
function! StatuslineActive(mode)
	" status line:
	hi LineNr ctermfg=244 ctermbg=0

	" middle part:
	hi User1 ctermfg=244 ctermbg=0

	" seperator mode>grey:
	hi User3             ctermbg=8

	" white > grey > black:
	hi User4 ctermfg=8 ctermbg=7
	hi User5 ctermfg=7 ctermbg=8
	hi User6 ctermfg=8 ctermbg=0

	" mode:
	if a:mode == 'V'
		hi LineNr ctermfg=208 ctermbg=0
		hi User2  ctermfg=52  ctermbg=208
		hi User3  ctermfg=208
	elseif a:mode == 'I'
		hi User2 ctermfg=8  ctermbg=7
		hi User3 ctermfg=7  ctermbg=31
		hi User5 ctermfg=7  ctermbg=31
		hi User6 ctermfg=31 ctermbg=23
		hi User1 ctermfg=45 ctermbg=23
		hi User9            ctermbg=23
	else
		hi User2 ctermfg=22  ctermbg=148
		hi User3 ctermfg=148
		hi User1 ctermfg=244 ctermbg=0
		hi User9             ctermbg=0

		" Disable current line highlight:
	endif
endfunction

" This function defines the active statusbar content (in a TTY):
function! StatuslineActiveTTY(mode)
	" line numbers:
	hi LineNr ctermfg=7 ctermbg=255 cterm=none

	" center part:
	hi User1 ctermfg=0 ctermbg=0 cterm=bold

	" white > grey > black:
	hi User4 ctermfg=0 ctermbg=7
	hi User5 ctermfg=7 ctermbg=255
	hi User6 ctermfg=0 ctermbg=0 cterm=bold

	" mode:
	if a:mode == 'V'
		hi LineNr ctermfg=3 ctermbg=255
		hi User2  ctermfg=0 ctermbg=3   cterm=none
	elseif a:mode == 'I'
		hi User2 ctermfg=4  ctermbg=7
		hi User4 ctermfg=4
		hi User5            ctermbg=4
	else
		hi User2 ctermfg=0  ctermbg=2
		hi User1 ctermfg=0  cterm=bold
	endif
endfunction

" This function draws the statusbar content:
function! DrawStatusline(mode)
	" mode:
	setl statusline=%2*
	if a:mode == 'V'
		setl statusline+=\ VISUAL\ 
	elseif a:mode == 'I'
		setl statusline+=\ INSERT\ 
		set cursorline
	else
		setl statusline+=\ NORMAL\ 
		set nocursorline
	endif
	setl statusline+=%3*%{rfsep}

	" filename (with modified flag):
	setl statusline+=%5*\ \ %<%{GetFilepath()}\ 
	if &modified
		setl statusline+=*
	else
		setl statusline+=\ 
	endif
	setl statusline+=%6*%{rfsep}

	" readonly?
	if &readonly
		setl statusline+=%9*\ (readonly)%1*%{rsep}
	endif
	setl statusline+=

	" change to the right side:
	setl statusline+=%=%1*

	" cursor position (column):
	setl statusline+=\ \ %{lsep}\ \ %02c(%02v)%6*

	" buffer position (line):
	setl statusline+=\ %{lfsep}%5*\ \ %{lnum}\ \ %02l/%L\ (%P)

	" file type:
	setl statusline+=\ %{lfsep}%4*\ %Y\ %1*
endfunction

" Draws all the statuslines:
function! UpdateStatusline(focused, mode)
	call StatuslineInactive()
	if a:focused
		if $TERM == "linux"
			call StatuslineActiveTTY(a:mode)
		else
			call StatuslineActive(a:mode)
		endif
		call DrawStatusline(a:mode)
	endif
endfunction

" Trigger statusline changes upon entering/leaving insert mode:
au! BufEnter,WinEnter,InsertLeave * call UpdateStatusline(1, 'N')
au! InsertEnter * call UpdateStatusline(1, 'I')
au! BufLeave,WinLeave * call UpdateStatusline(0, 'N')

" Trigger update of the modified flag on certain occasions:
au! BufWritePost * call UpdateStatusline(1, 'N')
if !&modified
	noremap <silent> p p:call UpdateStatusline(1, 'N')<CR>
	noremap <silent> u u:call UpdateStatusline(1, 'N')<CR>
	noremap <silent> dd dd:call UpdateStatusline(1, 'N')<CR>
	noremap <silent> dw dw:call UpdateStatusline(1, 'N')<CR>
	noremap <silent> x x:call UpdateStatusline(1, 'N')<CR>
	noremap <silent> <C-r> <C-r>:call UpdateStatusline(1, 'N')<CR>
endif

" As there are no predefined events for visual and replace mode, I need to
" manually define them:
inoremap <silent> <ESC> <ESC>:call UpdateStatusline(1, 'N')<CR>
vnoremap <silent> <ESC> <ESC>:call UpdateStatusline(1, 'N')<CR>

" Visual mode:
noremap <silent> v :call UpdateStatusline(1, 'V')<CR>v
noremap <silent> V :call UpdateStatusline(1, 'V')<CR>V
noremap <silent> <C-v> :call UpdateStatusline(1, 'V')<CR><C-v>
vnoremap <silent> > >:call UpdateStatusline(1, 'N')<CR>
vnoremap <silent> < <:call UpdateStatusline(1, 'N')<CR>
vnoremap <silent> x x:call UpdateStatusline(1, 'N')<CR>
vnoremap <silent> d d:call UpdateStatusline(1, 'N')<CR>
vnoremap <silent> y y:call UpdateStatusline(1, 'N')<CR>

" Replace mode (disabled, as I don't use it, and the statusline doesn't work):
map r i
map R i

" Repeating actions can only be done in normal mode, so we are sure that we can
" display it like that:
nnoremap <silent> . .:call UpdateStatusline(1, 'N')<CR>


" }}}
" ------------------------------------------------------------------------------
" BEHAVIOUR

" Keep 3 lines 'padding' above/below the cursor:
set scrolloff=3
	
" Simplify window scrolling:
map <Up> 3<C-y>
map <Down> 3<C-e>

" Modelines are evil!
set nomodeline


" INSERT MODE >

	" Except in LaTeX and Scala, we use 4 spaces per tab:
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
	au FileType tex,scala set expandtab
	au FileType tex,scala set tabstop=2
	au FileType tex,scala set shiftwidth=2

	" Auto-indent, and reuse the same combination of spaces/tabs:
	set autoindent
	set copyindent

	" Wrap lines, but break words:
	set wrap
	set linebreak


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


" ------------------------------------------------------------------------------
" COMPILING

" Search for Makefile and compile:
map r :w<cr>:!ayemake<cr>
map R <nop>

" File type specific commands:
au FileType tex map R :w<cr>:!pdflatex %<cr>
au FileType c map R :w<cr>:!make; ./$(basename % .c)<cr>

