" Vim configuration file
" written by ayekat in a snowy day in january 2010


" ------------------------------------------------------------------------------
" GENERAL

" No compatibility with vi => more tasty features:
set nocompatible

" Activate pathogen => even *more* tasty features:
call pathogen#infect()


" ------------------------------------------------------------------------------
" DISPLAY

" Displays darker colours, more confortable for the eyes:
set background=light

" Display and format line numbers:
set number
set numberwidth=5
hi LineNr ctermbg=black ctermfg=darkgrey

" Highlight number of current line:
set cursorline
hi CursorLine cterm=none
hi CursorLineNr ctermbg=black ctermfg=blue

" Enable UTF-8 (I wanna see Umlauts!):
set encoding=utf8


" SPLIT WINDOWS >
	
	" Define border colour:
	hi VertSplit ctermfg=black ctermbg=red

	" Fill up with solid bar:
	set fillchars=vert:┃
	

" FOLDING >

	" Define colour:
	hi Folded ctermbg=black ctermfg=blue

	" Define fill characters (space=don't fill up):
	set fillchars+=fold:\ 

	" Specify how vim autofolds:
	set foldmethod=marker


" PROGRAMMING >

	" Without any syntax highlighting, programming is a pain:
	syntax on
	
	" I wanna stay inside the 80 columns, so display a black bar after 80 chars:
	if version >= 703
		set colorcolumn=81
		hi ColorColumn ctermbg=black
	endif

	" I wanna see tabs and trailing whitespaces:
	set list listchars=tab:→\ ,trail:·
	hi SpecialKey ctermfg=darkgrey

	" Highlight maching parantheses:
	set showmatch
	hi MatchParen ctermfg=magenta ctermbg=none


" ------------------------------------------------------------------------------
" STATUS BAR {{{
" Written by ayekat on a cold day in december 2012

" Always display the statusline:
set laststatus=2

" Don't display the mode in the ruler; we display it in the statusline:
set noshowmode

" Define default statusline background to get rid of funnily coloured corners:
hi StatusLine ctermfg=black ctermbg=green
hi StatusLineNC ctermfg=black ctermbg=red
hi User1 ctermbg=black ctermfg=darkgrey

function! GetFilepath()
	let filepath=expand("%:p")
	let filepath=(filepath == '')?"[No Name]":filepath

	" TODO crop filepath name to fit into the statusline

	return filepath
endfunction

" This function defines the inactive statusbar content:
function! StatuslineInactive()
	" Display the filename:
	set statusline=%1*\ \ \ \ \ \ \ \ \ ⮁\ \ %{GetFilepath()}\ \ ⮁

	" Display the number of lines in file:
	set statusline+=%=(%L)
endfunction

" This function defines the active statusbar content:
function! StatuslineActive(mode)
	" Default colour:
	hi User1 ctermbg=black ctermfg=darkgrey

	" Colour for modified flag:
	hi User9 ctermbg=black ctermfg=yellow

	" Colours for cursor and window position:
	hi User4 ctermbg=black ctermfg=darkgreen
	if a:mode == 'I'
		hi User2 ctermbg=darkyellow ctermfg=black
		hi User3 ctermbg=black ctermfg=darkyellow
		hi User5 ctermbg=darkyellow ctermfg=yellow
	elseif a:mode == 'R'
		hi User2 ctermbg=darkred ctermfg=black
		hi User3 ctermbg=black ctermfg=darkred
		hi User5 ctermbg=darkred ctermfg=red
	elseif a:mode == 'V'
		hi User2 ctermbg=darkcyan ctermfg=black
		hi User3 ctermbg=black ctermfg=darkcyan
		hi User5 ctermbg=darkcyan ctermfg=cyan
	else
		hi User2 ctermbg=darkgreen ctermfg=black
		hi User3 ctermbg=black ctermfg=darkgreen
		hi User5 ctermbg=darkgreen ctermfg=green
	endif

	" Colour for file name:
	if &readonly
		hi User6 ctermbg=black ctermfg=red
	else
		hi User6 ctermbg=black ctermfg=blue
	endif

	" Colours and text for current mode:
	setl statusline=%7*
	if a:mode == 'V'
		hi User7 ctermbg=darkcyan ctermfg=darkgrey
		hi User8 ctermbg=black ctermfg=darkcyan
		setl statusline+=\ VISUAL\ \ %8*⮀
	elseif a:mode == 'R'
		hi User7 ctermbg=darkred ctermfg=darkgrey
		hi User8 ctermbg=black ctermfg=darkred
		setl statusline+=\ REPLCE\ \ %8*⮀
	elseif a:mode == 'I'
		hi User7 ctermbg=darkyellow ctermfg=darkgrey
		hi User8 ctermbg=black ctermfg=darkyellow
		setl statusline+=\ INSERT\ \ %8*⮀
	else
		hi User7 ctermbg=black ctermfg=darkgreen
		hi User8 ctermbg=black ctermfg=darkgrey
		setl statusline+=\ NORMAL\ \ %8*⮁
	endif

	" File name:
	setl statusline+=\ \ %6*%{GetFilepath()}%9*

	" Modified flag:
	if &modified
		setl statusline+=\ *%1*⮁
	else
		setl statusline+=\ \ %1*⮁
	endif

	" Change to right side:
	setl statusline+=%=

	" Display file type:
	setl statusline+=%y

	" Display cursor position:
	setl statusline+=\ \ %3*⮂%2*\ %5*⭡%2*\ \ %l\,%02c%02V

	" Display window position:
	setl statusline+=\ %5*⮃%2*⮂%4*\ \ %P\ %1*(%L)%1*
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

" Replace mode (still not correct):
noremap <silent> r :call UpdateStatusline(1, 'R')<CR>r
noremap <silent> R :call UpdateStatusline(1, 'R')<CR>R

" Repeating actions can only be done in normal mode, so we are sure that we can
" display it like that:
nnoremap <silent> . .:call UpdateStatusline(1, 'N')<CR>


" }}}
" ------------------------------------------------------------------------------
" BEHAVIOUR

" Keep 3 lines 'padding' above/below the cursor:
set scrolloff=3
	
" Simplify window scrolling:
map <Up> <C-y><C-y><C-y>
map <Down> <C-e><C-e><C-e>

" Modelines are evil!
set nomodeline


" INSERT MODE >

	" Except in LaTeX and Scala, we use 4 spaces per tab:
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
	au FileType tex,scala setl expandtab
	au FileType tex,scala setl tabstop=2
	au FileType tex,scala setl shiftwidth=2

	" Auto-indent, and reuse the same combination of spaces/tabs:
	set autoindent
	set copyindent

	" Don't break lines in the middle of words:
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


" ------------------------------------------------------------------------------
" COMPILING

" F5 in a (La)TeX file recompiles the file:
au FileType tex map <F5> :w<cr>:!pdflatex %<cr>
"au FileType tex imap <F5> :w<cr>:!pdflatex %<cr> "not tested yet

