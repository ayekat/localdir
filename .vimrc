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
hi CursorLineNr cterm=bold ctermbg=black ctermfg=blue

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
	
	" I wanna stay inside the 80 columns, so display a black bar after 80 chars:
	if version >= 703
		set colorcolumn=81
		hi ColorColumn ctermbg=0
	endif

	" I wanna see tabs and trailing whitespaces:
	set list listchars=tab:→\ ,trail:·
	hi SpecialKey cterm=bold ctermfg=0

	" Highlight maching parantheses:
	set showmatch
	hi MatchParen cterm=bold ctermfg=5 ctermbg=none


" ------------------------------------------------------------------------------
" COLOURS {{{
" Colours and theme redefinitions.

" Fix ugly urxvt/vim yellow:
hi Statement ctermfg=3
hi Todo ctermbg=3

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

	" TODO crop filepath name to fit into the statusline

	return filepath
endfunction

" Base:
hi User1 cterm=none ctermbg=0 ctermfg=244

" Error:
hi User6 cterm=bold ctermbg=0 ctermfg=1

" This function defines the inactive statusbar content:
function! StatuslineInactive()
	" Display the filename:
	set statusline=%1*\ \ \ \ \ \ \ \ ⮁\ \ %{GetFilepath()}\ \ ⮁
endfunction

" This function defines the active statusbar content:
function! StatuslineActive(mode)
	" Mode:
	setl statusline=%2*
	if a:mode == 'V'
		hi User2 ctermbg=6 ctermfg=23
		hi User3 ctermfg=6
		setl statusline+=\ VISUAL\ 
	elseif a:mode == 'R'
		hi User2 ctermbg=1 ctermfg=0
		hi User3 ctermfg=1
		setl statusline+=\ REPLCE\ 
	elseif a:mode == 'I'
		hi User2 ctermbg=3 ctermfg=58
		hi User3 ctermfg=3
		setl statusline+=\ INSERT\ 
	else
		hi User2 ctermbg=70 ctermfg=22
		hi User3 ctermfg=70
		setl statusline+=\ NORMAL\ 
	endif
	setl statusline+=%3*⮀

	" File Name:
	hi User3 ctermbg=238
	hi User8 ctermbg=238
	hi User4 ctermfg=250 ctermbg=238
	hi User5 ctermfg=238 ctermbg=0
	setl statusline+=%4*\ \ %{GetFilepath()}\ 
	if &modified
		setl statusline+=*
	else
		setl statusline+=\ 
	endif
	setl statusline+=%5*⮀

	" Read Only:
	if &readonly
		setl statusline+=%6*\ (readonly)
	endif
	setl statusline+=%1*

	" Change to the right side:
	setl statusline+=%=

	" File Type:
	setl statusline+=%5*⮃%1*\ \ %Y

	" Buffer Position:
	setl statusline+=\ \ %5*⮂%4*\ \ %P/%L

	" Cursor Position:
	hi User7 ctermbg=248 ctermfg=0
	hi User8 ctermfg=248
	setl statusline+=\ \ %8*⮂%7*\ \ ⭡\ \ %l:%02c%02V\ %1*
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
	au FileType tex,scala set expandtab
	au FileType tex,scala set tabstop=2
	au FileType tex,scala set shiftwidth=2

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

	" Word-breaking characters:
	set iskeyword-=_
	set iskeyword-=[.]


" ------------------------------------------------------------------------------
" COMPILING

" F5 in a (La)TeX file recompiles the file:
au FileType tex map <F5> :w<cr>:!pdflatex %<cr>
"au FileType tex imap <F5> :w<cr>:!pdflatex %<cr> "not tested yet

