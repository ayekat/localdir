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

" Enable 256 colours mode:
set t_Co=256

" Displays darker colours, more confortable for the eyes:
set background=light

" Display and format line numbers:
set number
set numberwidth=5
hi LineNr cterm=bold ctermbg=0 ctermfg=0

" Highlight number of current line:
set cursorline
hi CursorLine cterm=none
hi CursorLineNr cterm=bold ctermbg=232 ctermfg=blue

" Highlight end of file:
hi NonText cterm=bold ctermbg=232 ctermfg=blue

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
hi StatusLine cterm=none ctermfg=0 ctermbg=0
hi StatusLineNC cterm=none ctermfg=2 ctermbg=0

function! GetFilepath()
	let filepath=expand("%:p")
	let filepath=(filepath == '')?"[No Name]":filepath
	return filepath
endfunction

" Base:
hi User1 cterm=none ctermbg=0 ctermfg=244

" Error:
hi User9 cterm=none ctermbg=0 ctermfg=1

" This function defines the inactive statusbar content:
function! StatuslineInactive()
	" filename:
	set statusline=%1*\ \ \ ⮁\ \ %<%{GetFilepath()}\ \ ⮁

	" change to the right side:
	set statusline+=%=

	" cursor position (column):
	set statusline+=\ \ ⮃\ \ %02c(%02v)

	" buffer position (line):
	set statusline+=\ ⮃\ \ ⭡\ \ %02l/%L\ (%P)

	" file type:
	set statusline+=\ ⮃\ %Y\ %1*
endfunction

" This function defines the active statusbar content:
function! StatuslineActive(mode)
	" mode:
	setl statusline=%2*
	if a:mode == 'V'
		hi User2 ctermbg=6 ctermfg=8
		hi User3 ctermfg=6
		setl statusline+=\ VISUAL\ 
	elseif a:mode == 'I'
		hi User2 ctermbg=3 ctermfg=8
		hi User3 ctermfg=3
		setl statusline+=\ INSERT\ 
	else
		hi User2 ctermbg=148 ctermfg=28
		hi User3 ctermfg=148
		setl statusline+=\ n\ 
	endif
	hi User3 ctermbg=8
	setl statusline+=%3*⮀

	" transition: white > grey > black
	hi User4 ctermfg=8 ctermbg=7
	hi User5 ctermfg=7 ctermbg=8
	hi User6 ctermfg=8 ctermbg=0

	" filename (with modified flag):
	setl statusline+=%5*\ \ %<%{GetFilepath()}\ 
	if &modified
		setl statusline+=*
	else
		setl statusline+=\ 
	endif
	setl statusline+=%6*⮀

	" readonly?
	if &readonly
		setl statusline+=%9*\ (readonly)
	endif
	setl statusline+=%1*

	" change to the right side:
	setl statusline+=%=

	" cursor position (column):
	setl statusline+=\ \ ⮃\ \ %02c(%02v)%6*

	" buffer position (line):
	setl statusline+=\ ⮂%5*\ \ ⭡\ \ %02l/%L\ (%P)

	" file type:
	setl statusline+=\ ⮂%4*\ %Y\ %1*
endfunction

" Draws all the statuslines:
function! UpdateStatusline(focused, mode)
	call StatuslineInactive()
	if a:focused
		call StatuslineActive(a:mode)
	endif
endfunction

" Trigger statusline changes upon entering/leaving insert mode:
au! BufEnter,WinEnter,InsertLeave * call UpdateStatusline(1, 'N')
au! InsertEnter * call UpdateStatusline(1, 'I')
au! BufLeave,WinLeave * call UpdateStatusline(0, 'N')

" Trigger update of the modified flag on certain occasions:
au! BufWritePost * call UpdateStatusline(1, 'N')
noremap <silent> p p:call UpdateStatusline(1, 'N')<CR>
noremap <silent> u u:call UpdateStatusline(1, 'N')<CR>
noremap <silent> dd dd:call UpdateStatusline(1, 'N')<CR>
noremap <silent> dw dw:call UpdateStatusline(1, 'N')<CR>
noremap <silent> x x:call UpdateStatusline(1, 'N')<CR>
noremap <silent> <C-r> <C-r>:call UpdateStatusline(1, 'N')<CR>

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

" F5 in a (La)TeX file recompiles the file:
au FileType tex map <F5> :w<cr>:!pdflatex %<cr>
au FileType c map r :w<cr>:!make; ./$(basename % .c)<cr>

