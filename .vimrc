filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
"Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
"Plugin 'kien/ctrlp.vim'
"Plugin 'pangloss/vim-javascript'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set encoding=utf-8
"let mapleader = \<Space>
let mapleader = ","
set nobackup "dont back the files
set hidden
set number
filetype plugin indent on
set autoindent
set ts=2
set expandtab
set shiftwidth=2
set nocompatible
"set cursorline
set vb
syntax on
set relativenumber
"set statusline
set background=dark
"set listchars=eol:¬,tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:·
"set list
set laststatus=2	"for airline plugin if not set,shows the airline only at split
set nowrap
set hlsearch
colo desert
set backspace=2
set backspace=indent,eol,start
"cnoremap help vert bo help
if has('gui_running')
  set guioptions-=T  " no toolbar
  "colorscheme elflord
  set lines=60 columns=108 linespace=0
  if has('gui_win32')
    "set guifont=DejaVu_Sans_Mono:h10:cANSI
    set guifont=Lucida_Sans_Typewriter:h11:cANSI
  else
    set guifont=DejaVu\ Sans\ Mono\ 11
  endif
endif

" This is a very minimal example that shows how to compile and run a 
" single Java test file from you Vim session 
" A quick explaination:
"    map: map statements tell Vim to associated certain key strokes with
"         actions. 
"    <leader>jc (leader is usually just a comma, but you can
"         define it as you like) now maps to command :!javac %<CR>
"    :!javac %<CR>     
"         '!' gets you into the system command line, 
"         'javac' is the standard Java compiler, 
"         '%' is the current filename (Test.java)
"         ':r' gets the filename without the extension (in the second line)
"         '<CR>' tells Vim to go ahead and enter the command (carriage return) 

"Java compiler and interpreter
map <leader>jc <leader>cd <bar> :!javac %<CR> 
map <leader>jj <leader>cd <bar> :!java %:r<CR>
map <leader>cc <leader>cd <bar> :!tcc % <CR> <bar> :! %r <CR>
map <leader>gp <leader>cd <bar> :!g++ -o %:r % <CR>
map <leader>cpp <leader>cd <bar> :!g++ -o %:r % <CR> <bar> :! %:r <CR>
"get rid of highlight after search
map <leader>h :noh<CR>

"Split navigations 
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"leader command for navigating tabs
nnoremap T :tabprev<CR>
nnoremap t :tabnext<CR>
"leader commands for saving and closing
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>
noremap <leader>q :q<cr>
" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

nnoremap <C-Insert> :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>

"runtime macros/matchit.vim
" XML formatter starts
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR> <bar> :set syntax=xml<CR>
vmap <silent> <leader>x :FormatXML<CR> <bar> :set synatx=xml<CR>
" XML formatter ends

"current directory adjustmet as per filepath 
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>X :set syntax=xml<CR>
" bracket autocomplete
"inoremap ( ()<Esc>:call BC_AddChar(")")<CR>i
inoremap { {<CR>}<Esc>:call BC_AddChar("}")<CR><Esc>kA<CR>
"inoremap [ []<Esc>:call BC_AddChar("]")<CR>i
"inoremap \" \"\"<Esc>:call BC_AddChar("\"")<CR>i
" jump out of parenthesis
inoremap <C-j> <Esc>:call search(BC_GetChar(), "W")<CR>a

function! BC_AddChar(schar)
 if exists("b:robstack")
 let b:robstack = b:robstack . a:schar
 else
 let b:robstack = a:schar
 endif
endfunction

function! BC_GetChar()
 let l:char = b:robstack[strlen(b:robstack)-1]
 let b:robstack = strpart(b:robstack, 0, strlen(b:robstack)-1)
 return l:char
endfunction
