scriptencoding utf-8
"  准备工作 [[[1
"  引用Example设置 [[[2
if !exists("g:VimrcIsLoad")
	runtime vimrc_example.vim
endif
"]]]
"  判定当前操作系统类型  [[[2
if has("win32") || has("win95") || has("win64") || has("win16")
	let g:isWindows=1
	" For gVimPortable
	let $VIMFILES = $VIM."/../../Data/settings/vimfiles"
else
	let g:isWindows=0
	let $VIMFILES = $HOME."/.vim"
endif
" ]]]
"  判定当前是否图形界面 [[[2
if has("gui_running")
	let g:isGUI=1
else
	let g:isGUI=0
endif
" ]]]
"  判定当前终端是否256色 [[[2
if (g:isWindows==0 && g:isGUI==0 &&
	\ (&term =~ "256color" || &term =~ "xterm" || &term =~ "fbterm"))
	let g:isColor=1
else
	let g:isColor=0
endif
" ]]]
"  判定当前终端是否tmux [[[2
if exists('$TMUX')
	let g:isTmux=1
else
	let g:isTmux=0
endif
" ]]]
"  判定当前是否支持Lua [[[2
if has('lua')
	let g:hasLua=1
else
	let g:hasLua=0
endif
" ]]]
"  判定当前是否支持Python2或3 [[[2
if has('python') || has('python3')
	let g:hasPython=1
else
	let g:hasPython=0
endif
" ]]]
"  判定当前是否有CTags [[[2
if executable('ctags')
	let g:hasCTags=1
else
	let g:hasCTags=0
endif
" ]]]
"  判定当前是否有Cscope [[[2
if has('cscope') && executable('cscope')
	let g:hasCscope=1
else
	let g:hasCscope=0
endif
" ]]]
"  设置AuGroup [[[2
augroup MyAutoCmd
	autocmd!
augroup END
"  ]]]
"  ]]]
"  NeoBundle 插件管理器 [[[1
"  初始化插件组设置 [[[2
let s:plugin_groups = []
call add(s:plugin_groups, 'core')
call add(s:plugin_groups, 'autocomplete')
call add(s:plugin_groups, 'editing')
call add(s:plugin_groups, 'indent')
call add(s:plugin_groups, 'javascript')
if !g:isWindows
	call add(s:plugin_groups, 'linux')
	if g:isTmux
		call add(s:plugin_groups, 'tmux')
	endif
else
	call add(s:plugin_groups, 'windows')
endif
if g:hasLua
	call add(s:plugin_groups, 'lua')
endif
call add(s:plugin_groups, 'misc')
call add(s:plugin_groups, 'navigation')
call add(s:plugin_groups, 'php')
call add(s:plugin_groups, 'scm')
call add(s:plugin_groups, 'unite')
call add(s:plugin_groups, 'web')
"  ]]]
"  设置NeoBundle [[[2
filetype off
set runtimepath+=$VIMFILES/bundle/neobundle.vim/
call neobundle#rc(expand("$VIMFILES/bundle/"))
" set shellquote="\""
" set shellxquote="\""
" set noshellslash

" let vundle manage vundle
" required!
NeoBundleFetch 'Shougo/neobundle.vim'
" ]]]
" my bundles here:
"  核心 [[[2
if count(s:plugin_groups, 'core')
	NeoBundle 'matchit.zip'
	" NeoBundle 'Lokaltog/vim-powerline'
	NeoBundleDepends 'Shougo/vimproc.vim', {
				\ 'build' : {
				\     'windows' : 'make -f make_mingw32.mak',
				\     'cygwin'  : 'make -f make_cygwin.mak',
				\     'mac'     : 'make -f make_mac.mak',
				\     'unix'    : 'make -f make_unix.mak',
				\    },
				\ }
	NeoBundle 'bling/vim-airline'
	NeoBundle 'tpope/vim-repeat'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'tpope/vim-dispatch'
endif
" ]]]
"  自动完成 [[[2
if count(s:plugin_groups, 'autocomplete')
	NeoBundleLazy 'Shougo/neocomplcache.vim',
				\ {'autoload':{'insert':1}}
	" Plugins that needs lua
	if g:hasLua
		NeoBundleLazy 'Shougo/neocomplete.vim',
					\ {'autoload':{'insert':1},
					\ 'vim_version':'7.3.885'}
		NeoBundleDisable 'Shougo/neocomplcache.vim'
	endif
	NeoBundle 'Shougo/neosnippet.vim'
	NeoBundle 'honza/vim-snippets'
endif
" ]]]
"  文本编辑 [[[2
if count(s:plugin_groups, 'editing')
	" NeoBundle 'AutoClose'
	NeoBundle 'Lokaltog/vim-easymotion'
	NeoBundle 'chrisbra/NrrwRgn'
	NeoBundle 'dimasg/vim-mark'
	NeoBundleLazy 'godlygeek/tabular',
				\ {'autoload':{'commands':'Tabularize'}}
	NeoBundle 'jiangmiao/auto-pairs'
	NeoBundle 'kien/rainbow_parentheses.vim'
	NeoBundle 'rhysd/clever-f.vim'
	NeoBundle 'terryma/vim-multiple-cursors'
	NeoBundle 'tomtom/tcomment_vim'
endif
" ]]]
"  代码缩进 [[[2
if count(s:plugin_groups, 'indent')
	NeoBundle 'nathanaelkane/vim-indent-guides'
endif
" ]]]
"  JavaScript [[[2
if count(s:plugin_groups, 'javascript')
	" NeoBundleLazy 'JavaScript-Indent',
	" 			\ { 'autoload' : {'filetypes':['javascript']} }
	" NeoBundleLazy 'jQuery',
	" 			\ { 'autoload' : {'filetypes':['javascript']} }
	" NeoBundleLazy 'jelera/vim-javascript-syntax',
	" 			\ {'autoload':{'filetypes':['javascript']}}
	NeoBundleLazy 'pangloss/vim-javascript',
				\ {'autoload':{'filetypes':['javascript']}}
	NeoBundleLazy 'othree/javascript-libraries-syntax.vim',
				\ {'autoload':{'filetypes':['javascript', 'coffee', 'ls', 'typescript']}}
	if executable('node') || executable('nodejs')
		NeoBundleLazy 'maksimr/vim-jsbeautify',
					\ { 'autoload' : {'commands':['CSSBeautify', 'JsBeautify',
		'HtmlBeautify']],
					\ 'filetypes':['javascript']} }
	endif
endif
" ]]]
"  Linux [[[2
if count(s:plugin_groups, 'linux')
	NeoBundle 'sudo.vim'
	if g:hasPython
		NeoBundle 'fcitx.vim'
	endif
endif
" ]]]
"  Lua [[[2
if count(s:plugin_groups, 'lua')
	NeoBundleLazy 'luarefvim',
				\ {'autoload':{'filetypes':['lua']}}
endif
" ]]]
"  文本定位/纵览 [[[2
if count(s:plugin_groups, 'navigation')
	" NeoBundle 'grep.vim'
	if g:hasCTags
		" CTags语法高亮
		NeoBundle 'bb:abudden/taghighlight'
		NeoBundleLazy 'majutsushi/tagbar',
					\ {'autoload':{'commands':'TagbarToggle'}}
		NeoBundleLazy 'wesleyche/SrcExpl',
					\ {'autoload':{'commands':'SrcExplToggle'}}
		if g:hasCscope
			NeoBundleLazy 'CCTree',
					\ {'autoload':{'commands':['CCTreeLoadDB', 'CCTreeLoadXRefDBFromDisk']}}
		endif
	endif
	NeoBundleLazy 'a.vim',
				\ {'autoload':{'filetypes':['c', 'cpp']}}
	NeoBundle 'jistr/vim-nerdtree-tabs',
				\ {'depends':['scrooloose/nerdtree'], 'autoload':{'commands':'NERDTreeTabsToggle'}}
	" NeoBundle 'kien/ctrlp.vim'
	NeoBundleLazy 'mbbill/undotree',
				\ {'autoload':{'commands':'UndotreeToggle'}}
	NeoBundle 'mileszs/ack.vim'
	NeoBundle 'scrooloose/nerdtree'
endif
" ]]]
"  PHP [[[2
if count(s:plugin_groups, 'php')
	"press K on a function for full php manual
	NeoBundle 'spf13/PIV'
endif
" ]]]
"  代码管理 [[[2
if count(s:plugin_groups, 'scm')
	NeoBundle 'airblade/vim-gitgutter'
	NeoBundleLazy 'gregsexton/gitv',
				\ {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}}
	NeoBundle 'tpope/vim-fugitive'
endif
" ]]]
"  TMux [[[2
if count(s:plugin_groups, 'tmux')
	NeoBundle 'christoomey/vim-tmux-navigtor'
endif
"  Unite 插件组 [[[2
if count(s:plugin_groups, 'unite')
	NeoBundle 'Shougo/unite.vim'
	NeoBundleLazy 'Shougo/unite-help',
				\ {'autoload':{'unite_sources':'help'}}
	NeoBundleLazy 'Shougo/unite-outline',
				\ {'autoload':{'unite_sources':'outline'}}
	NeoBundleLazy 'tsukkee/unite-tag',
				\ {'autoload':{'unite_sources':['tag','tag/file']}}
endif
" ]]]
"  Web开发 [[[2
if count(s:plugin_groups, 'web')
	NeoBundleLazy 'amirh/HTML-AutoCloseTag',
				\ {'autoload':{'filetypes':['html', 'xml']}}
	NeoBundleLazy 'ap/vim-css-color',
				\ {'autoload':{'filetypes':[ 'css', 'scss', 'sass', 'less']}}
	NeoBundleLazy 'gregsexton/MatchTag',
				\ {'autoload':{'filetypes':[ 'html', 'xml']}}
	NeoBundleLazy 'mattn/emmet-vim',
				\ {'autoload':{'filetypes':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}}
	NeoBundleLazy 'othree/html5.vim',
				\ {'autoload':{'filetypes':['html']}}
	NeoBundleLazy 'othree/html5-syntax.vim',
				\ {'autoload':{'filetypes':['html']}}
	NeoBundleLazy 'othree/xml.vim',
				\ {'autoload':{'filetypes':['html', 'xml']}}
endif
"  Windows [[[2
if count(s:plugin_groups, 'windows') && g:hasCscope
	NeoBundle 'cscope-wrapper'
endif
" ]]]
"  杂项 [[[2
if count(s:plugin_groups, 'misc')
	" NeoBundle 'Conque-Shell'
	NeoBundleLazy 'git@github.com:Firef0x/PKGBUILD.vim',
				\ { 'autoload' : {'filetypes':['PKGBUILD']} }
	NeoBundleLazy 'Shougo/vimshell.vim',
				\ {'autoload':{'commands':[ 'VimShell', 'VimShellInteractive' ]}}
	NeoBundle 'asins/vimcdoc'
	" NeoBundle 'scrooloose/nerdcommenter'
	NeoBundle 'scrooloose/syntastic'
	NeoBundleLazy 'superbrothers/vim-vimperator',
				\ { 'autoload' : {'filetypes':['vimperator']} }
	NeoBundle 'tomasr/molokai'
	NeoBundleLazy 'tpope/vim-markdown',
				\ { 'autoload' : {'filetypes':['markdown']} }
	" NeoBundle 'xieyu/vim-assist'

	" vim-scripts repos
	"NeoBundle 'mru.vim'
	" NeoBundle 'Align'
	" 保存时自动创建空文件夹
	NeoBundle 'auto_mkdir'
	" 在单独的窗口管理缓冲区
	NeoBundle 'bufexplorer.zip'
	NeoBundle 'FencView.vim'
	" PO (Portable Object, gettext)
	NeoBundleLazy 'po.vim--gray',
				\ { 'autoload' : {'filetypes':['po']} }
	" STL语法高亮
	NeoBundleLazy 'STL-improved',
				\ { 'autoload' : {'filetypes':['c', 'cpp']} }
	" Ctrl-V选择区域，然后按:B执行命令，或按:S查找匹配字符串
	NeoBundle 'vis'
	" Make a column of increasing or decreasing numbers
	NeoBundle 'VisIncr'
endif
" ]]]
"  使用NeoBundle关闭，结束时开始 [[[2
filetype plugin indent on     " required!
" ]]]
"  NeoBundle帮助 [[[2
" non github repos
" NeoBundle 'git://git.wincent.com/command-t.git'
" ...

" brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleSearch(!) foo - search(or refresh cache first) for foo
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" Installation check.
NeoBundleCheck
"
" see :h neobundle for more details or wiki for faq
" note: comments after bundle command are not allowed..
" ]]]
" ]]]
"  以下为自己的自定义设置  [[[1
"  设置语言编码 [[[2
if !exists('g:VimrcIsLoad')
	set langmenu=zh_CN.UTF-8
	let $LANG='zh_CN.UTF-8'
	set helplang=cn
	if g:isWindows && has("multi_byte")
		set termencoding=cp850
	else
		set termencoding=utf-8
	endif
	set fileencodings=utf-8,chinese,taiwan,ucs-2,ucs-2le,ucs-bom,latin1,gbk,gb18030,big5,utf-16le,cp1252,iso-8859-15
	set encoding=utf-8
	set fileencoding=utf-8
endif
" 解决菜单乱码 [[[2
if g:isWindows && g:isGUI
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	" 解决console输出乱码
	language messages zh_CN.UTF-8
endif
" ]]]
"  设置图形界面选项  [[[2
"set guioptions=   "无菜单、工具栏
"  去掉欢迎界面
set shortmess=atI
if g:isGUI && !exists('g:VimrcIsLoad')
	set guioptions+=t  "分离式菜单
	set guioptions-=T  "不显示工具栏
	if g:isWindows
		autocmd MyAutoCmd GUIEnter * simalt ~x    "Max GUI window on start
	endif
	autocmd MyAutoCmd GUIEnter * set t_vb=
	set guitablabel=%N\ \ %t\ %M   "标签页上显示序号
endif
" Don't redraw while executing macros (good performance config)
set lazyredraw
" Change the terminal's title
set title
" Avoid command-line redraw on every entered character by turning off Arabic
" shaping (which is implemented poorly).
if has('arabic')
  set noarabicshape
endif
" ]]]
" 图形与终端  [[[2
let colorscheme = 'molokai'
if g:isGUI
	" 有些终端不能改变大小
	set columns=88
	set lines=32
	set number
	set cursorline
	" 原为double，为了更好地显示airline
	set ambiwidth=single
	exe 'colorscheme' colorscheme
elseif has("unix")
	set ambiwidth=single
	let g:rehash256 = 1 "开启molokai终端256色配色
	" 防止退出时终端乱码
	" 这里两者都需要。只前者标题会重复，只后者会乱码
	set t_fs=(B
	set t_IE=(B
	if g:isColor
		set cursorline  "Current Line Adornment
		exe 'colorscheme' colorscheme
		set t_Co=256
	else
		" 在Linux文本终端下非插入模式显示块状光标
		if &term == "linux" || &term == "fbterm"
			set t_ve+=[?6c
			augroup MyAutoCmd
				autocmd InsertEnter * set t_ve-=[?6c
				autocmd InsertLeave * set t_ve+=[?6c
				" autocmd VimLeave * set t_ve-=[?6c
			augroup END
		endif
		if &term == "fbterm"
			set cursorline
			set number
			exe 'colorscheme' colorscheme
		elseif $TERMCAP =~ 'Co#256'
			set t_Co=256
			set cursorline
			exe 'colorscheme' colorscheme
		else
			" 暂时只有这个配色比较适合了
			colorscheme default
			" 在终端下自动加载vimim输入法
			"runtime plugin/vimim.vim
		endif
	endif
	" 在不同模式下使用不同颜色的光标
	" 不要在 ssh 下使用
	if g:isColor && !exists('$SSH_TTY')
		let color_normal = 'HotPink'
		let color_insert = 'RoyalBlue1'
		let color_exit = 'green'
		if &term =~ 'xterm\|rxvt'
			exe 'silent !echo -ne "\e]12;"' . shellescape(color_normal, 1) . '"\007"'
			let &t_SI="\e]12;" . color_insert . "\007"
			let &t_EI="\e]12;" . color_normal . "\007"
			exe 'autocmd VimLeave * :silent !echo -ne "\e]12;"' . shellescape(color_exit, 1) . '"\007"'
		elseif &term =~ "screen"
			if g:isTmux
				if &ttymouse == 'xterm'
					set ttymouse=xterm2
				endif
				exe 'silent !echo -ne "\033Ptmux;\033\e]12;"' . shellescape(color_normal, 1) . '"\007\033\\"'
				let &t_SI="\033Ptmux;\033\e]12;" . color_insert . "\007\033\\"
				let &t_EI="\033Ptmux;\033\e]12;" . color_normal . "\007\033\\"
				exe 'autocmd VimLeave * :silent !echo -ne "\033Ptmux;\033\e]12;"' . shellescape(color_exit, 1) . '"\007\033\\"'
			elseif !exists('$SUDO_UID') " or it may still be in tmux
				exe 'silent !echo -ne "\033P\e]12;"' . shellescape(color_normal, 1) . '"\007\033\\"'
				let &t_SI="\033P\e]12;" . color_insert . "\007\033\\"
				let &t_EI="\033P\e]12;" . color_normal . "\007\033\\"
				exe 'autocmd VimLeave * :silent !echo -ne "\033P\e]12;"' . shellescape(color_exit, 1) . '"\007\033\\"'
			endif
		endif
		unlet color_normal
		unlet color_insert
		unlet color_exit
	endif
endif
"endif
unlet colorscheme
"]]]
" 关闭错误声音  [[[2
set noerrorbells
set visualbell t_vb=
" ]]]
"   设置文字编辑选项  [[[2
set autoread "auto reload
set background=dark	"dark background 开启molokai终端配色必须指令
set confirm "read only or haven't saved
set noexpandtab  "键入Tab时不转换成空格
set nowrap "不自动换行
set shiftwidth=4  " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4  " 设置按BackSpace的时候可以一次删除掉4个空格
set tabstop=4 "tab = 4 spaces
" 自动切换当前目录为当前文件所在的目录(与fugitive冲突)
" set autochdir
set ignorecase " 搜索时忽略大小写，但在有一个或以上大写字母时仍大小写敏感
set smartcase
set nobackup " 覆盖文件时不备份
set nowritebackup "文件保存后取消备份
set noswapfile  "取消交换区
set mousehide  " 键入时隐藏鼠标
set magic " 设置模式的魔术
set display+=lastline "显示最多行，不用@@
set viminfo=%,'1000,<50,s20,h,n$VIMFILES/viminfo
" 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
set hidden
" 将撤销树保存到文件
if has('persistent_undo')
	set undodir=$VIMFILES/.cache/undo
	if !isdirectory(&undodir)
    	call mkdir(&undodir, '', 0700)
	endif
	set undofile
endif
set scrolloff=3  " 设置光标之下的最少行数
" ]]]
" Display unprintable chars [[[2
if !g:isWindows
	set list
	set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
	set showbreak=↪ 
endif

" listchar=trail is not as flexible, use the below to highlight trailing
" whitespace. Don't do it for unite windows or readonly files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup MyAutoCmd
	autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
	autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
	autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
	autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END
" ]]]
"  开启Wild菜单 [[[2
set wildmenu
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
" Ignore compiled files
set wildignore=*.o,*.obj,*~,*.pyc
set wildignore+=*.gem
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif,*.xpm
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.xz
" 光标移到行尾时，自动换下一行开头 Backspace and cursor keys wrap too
set whichwrap=b,s,h,l,<,>,[,]
" ]]]
"  设置代码相关选项  [[[2
set autoindent "设置自动缩进选项
set cindent
" 智能自动缩进
set smartindent
" 设定命令行的行数为 1
set cmdheight=1
"显示括号配对情况
set showmatch
set tags+=$VIMFILES/tags/cpp/stl.tags  " 增加C++ STL Tags
set tags+=$VIMFILES/tags/perl/cpan.tags  " 增加Perl CPAN Tags
source $VIMRUNTIME/ftplugin/man.vim
set formatoptions=tcqroj  " 使得注释换行时自动加上前导的空格和星号
" ]]]
" 自动关联系统剪贴板(即+、*寄存器) [[[2
if g:isTmux
	set clipboard=
elseif has ('unnamedplus')
	set clipboard=unnamedplus
else
	set clipboard=unnamed
endif
" ]]]
"  设置语法折叠 [[[2
set foldenable
" manual  手工定义折叠
" indent  更多的缩进表示更高级别的折叠
" expr    用表达式来定义折叠
" syntax  用语法高亮来定义折叠
" diff    对没有更改的文本进行折叠
" marker  对文中的标志折叠
set foldmethod=marker
" 设置折叠层数为
set foldlevel=0
" 设置折叠区域的宽度
set foldcolumn=0
" 新建的文件，刚打开的文件不折叠
" ]]]
" 定义文件格式  [[[2
augroup Filetype_Specific
	autocmd!
	" VimFiles {{{
	autocmd Filetype vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
	autocmd Filetype vim setlocal fdm=indent keywordprg=:help
	" }}}
	" Arch Linux {{{
	autocmd BufNewFile,BufRead PKGBUILD setlocal syntax=PKGBUILD ft=PKGBUILD
	autocmd BufNewFile,BufRead *.install setlocal syntax=sh ft=sh
	" }}}
	" dict {{{
	autocmd filetype javascript set dictionary=$VIMFILES/dict/javascript.txt
	autocmd filetype css set dictionary=$VIMFILES/dict/css.txt
	autocmd filetype php set dictionary=$VIMFILES/dict/php.txt
	" }}}
	" CSS {{{
	autocmd FileType css setlocal smartindent foldmethod=indent
	autocmd FileType css setlocal noexpandtab "tabstop=2 shiftwidth=2
	autocmd BufNewFile,BufRead *.scss setlocal ft=scss
	" 删除一条CSS中无用空格
	autocmd filetype css vnoremap <leader>co J:s/\s*\([{:;,]\)\s*/\1/g<CR>:let @/=''<cr>
	autocmd filetype css nnoremap <leader>co :s/\s*\([{:;,]\)\s*/\1/g<CR>:let @/=''<cr>
	" }}}
	" Javascript {{{
	autocmd BufRead,BufNewFile jquery.*.js setlocal ft=javascript syntax=jquery
	" JSON syntax
	autocmd BufRead,BufNewFile *.json setlocal ft=json
	" }}}
	" Markdown
	autocmd FileType markdown setlocal nolist
	" PHP Twig 模板引擎语法
	" autocmd BufRead,BufNewFile *.twig set syntax=twig

	autocmd FileType markdown setlocal nolist
	" Python 文件的一般设置，比如不要 tab 等
	autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab foldmethod=indent
	" C/C++ {{{
	"  Don't autofold anything (but I can still fold manually)
	autocmd FileType c setlocal smartindent foldmethod=syntax foldlevel=100
	autocmd FileType cpp setlocal smartindent foldmethod=syntax foldlevel=100
	" }}}
augroup END
" ]]]
" 当打开一个新缓冲区时，自动切换目录为当前编辑文件所在目录 [[[2
autocmd MyAutoCmd BufRead,BufNewFile,BufEnter *
			\ if bufname("") !~ "^\[A-Za-z0-9\]*://" && expand("%:p") !~ "^sudo:"
			\| silent! lcd %:p:h
			\| endif
" ]]]
" GREP/ACK/AG Settings [[[2
if executable('ack')
	set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
	set grepformat=%f:%l:%c:%m
endif
if executable('ag')
	set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
	set grepformat=%f:%l:%c:%m
endif
" ]]]
" 能够漂亮地显示.NFO文件  [[[2
function! s:SetFileEncodings(encodings)
	let b:myfileencodingsbak=&fileencodings
	let &fileencodings=a:encodings
endfunction
function! s:RestoreFileEncodings()
	let &fileencodings=b:myfileencodingsbak
	unlet b:myfileencodingsbak
endfunction
autocmd MyAutoCmd BufReadPre *.nfo call s:SetFileEncodings('cp437')
autocmd MyAutoCmd BufReadPost *.nfo call s:RestoreFileEncodings()
" ]]]
" source时让一些设置不再执行 [[[2
let g:VimrcIsLoad=1
" ]]]
" ]]]
"  快捷键设置  [[[1
"  设置<Leader>为逗号  [[[2
let mapleader=","
let g:mapleader = ","
"  Alt组合键不映射到菜单上  [[[2
set winaltkeys=no
" ]]]
"  用空格键来开关折叠  [[[2
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
" ]]]
" Folding [[[2
"折叠相关的快捷键
"zR 打开所有的折叠
"za Open/Close (toggle) a folded group of lines.
"zA Open a Closed fold or close and open fold recursively.
"zi 全部 展开/关闭 折叠
"zo 打开 (open) 在光标下的折叠
"zc 关闭 (close) 在光标下的折叠
"zC 循环关闭 (Close) 在光标下的所有折叠
"zM 关闭所有可折叠区域
" ]]]
"  脚本运行快捷键  [[[2
" map <F9> :w <CR>:!python %<CR>
map <C-F5> :!./%<<CR>
"  Ctrl-S 保存文件  [[[2
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar UpDate if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>UpDate<CR>
inoremap <silent> <C-S> <C-O>:UpDate<CR><CR>
vnoremap <silent> <C-S> <C-C>:UpDate<CR>
"  以sudo 保存(由sudo.vim插件代替) [[[2
" if (g:isWindows==0)
" nmap <Leader>w :w !sudo tee % > /dev/null<CR>
" endif
" ]]]
"  一键编译单个源文件  [[[2
map <F5> :w <CR>:call Do_OneFileMake()<CR>
function! Do_OneFileMake()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg
					\| echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file."
					\| echohl None
		return
	endif
	let sourcefileename=expand("%:t")
	if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c"))
		echohl WarningMsg
					\| echo "Fail to make! Please select the right file!"
					\| echohl None
		return
	endif
	let deletedspacefilename=substitute(sourcefileename,' ','','g')
	if strlen(deletedspacefilename)!=strlen(sourcefileename)
		echohl WarningMsg
					\| echo "Fail to make! Please delete the spaces in the filename!"
					\| echohl None
		return
	endif
	if &filetype=="c"
		if g:isWindows==1
			set makeprg=gcc\ -o\ %<.exe\ %
		else
			set makeprg=gcc\ -o\ %<\ %
		endif
	elseif &filetype=="cpp"
		if g:isWindows==1
			set makeprg=g++\ -o\ %<.exe\ %
		else
			set makeprg=g++\ -o\ %<\ %
		endif
		"elseif &filetype=="cs"
		"set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
	endif
	if(g:isWindows==1)
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'.exe','g')
		let toexename=outfilename
	else
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'','g')
		let toexename=outfilename
	endif
	if filereadable(outfilename)
		if(g:isWindows==1)
			let outdeletedsuccess=delete(getcwd()."\\".outfilename)
		else
			let outdeletedsuccess=delete("./".outfilename)
		endif
		if(outdeletedsuccess!=0)
			set makeprg=make
			echohl WarningMsg
						\| echo "Fail to make! I cannot delete the ".outfilename
						\| echohl None
			return
		endif
	endif
	execute "Make"
	set makeprg=make
	execute "normal :"
	if filereadable(outfilename)
		if(g:isWindows==1)
			execute "!".toexename
		else
			execute "!./".toexename
		endif
	endif
	execute "cwindow"
endfunction
"进行make的设置
map <F6> :call Do_make()<CR>
map <C-F6> :silent make clean<CR>
function! Do_make()
	set makeprg=make
	execute "Make"
	execute "cwindow"
endfunction
" ]]]
"   <Leader>{P,p},鼠标中键粘贴 [[[2
nnoremap <silent> <Leader>P "+P
nnoremap <silent> <Leader>p "+p
nnoremap <silent> <MiddleMouse> "+P
inoremap <silent> <MiddleMouse> <C-R>+
" ]]]
"     上下移动一行文字[[[2
"nmap <C-j> mz:m+<cr>`z
"nmap <C-k> mz:m-2<cr>`z
"vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
" ]]]
"  水平或垂直分割窗口 [[[2
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s
" ]]]
"  窗口分割时重映射为<C-hjkl>,切换的时候会变得非常方便.   [[[2
nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>
" ]]]
"  插入模式下光标移动  [[[2
imap <A-h> <Left>
imap <A-j> <Down>
imap <A-k> <Up>
imap <A-l> <Right>
" ]]]
"  插入模式下按jk代替Esc [[[2
inoremap jk <Esc>
" ]]]
"  Alt+方向键切换buffer [[[2
nnoremap <silent> <M-left> :if bufnr("%") == 2\|exe "buffer ".bufnr("$")\|el\|bprev\|en<CR>
nnoremap <silent> <M-right> :if bufnr("%") == bufnr("$")\|buffer2\|el\|bnext\|en<CR>
" ]]]
"  关闭窗口 [[[2
function! CloseWindowOrKillBuffer()
	let number_of_windows_to_this_buffer =
				\ len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

	" never bdelete a nerd tree
	if matchstr(expand("%"), 'NERD') == 'NERD'
		wincmd c
		return
	endif

	if number_of_windows_to_this_buffer > 1
		wincmd c
	else
		bdelete
	endif
endfunction
nmap <silent> <Leader>c :call CloseWindowOrKillBuffer()<CR>
" ]]]
" 自动居中 [[[2
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz
" 缩进后继续选定 [[[2
vnoremap < <gv
vnoremap > >gv
" 将Y映射为复制到行尾 [[[2
nnoremap Y y$
" 允许在Visual模式下按 . 重复执行操作 [[[2
vnoremap . :normal .<CR>
"   切换Quickfix  [[[2
" nmap <F11> :cnext<CR>
" nmap <S-F11> :cprevious<CR>
if executable('ctags')
	nmap <S-F12> :Dispatch ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>:UpdateTypesFile<CR>
endif
" ]]]
"  编辑vim配置文件并在保存时加载  [[[2
nmap <leader>rc :edit $MYVIMRC<CR>
autocmd! MyAutoCmd BufWritePost .vimrc,_vimrc,vimrc
			\ source $MYVIMRC | AirlineRefresh
" ]]]
"  切换高亮搜索关键字  [[[2
nmap <silent> <leader>nh :nohlsearch<CR>
" ]]]
"  切换绝对/相对行号 [[[2
nnoremap <Leader>nu :call <SID>toggle_number()<CR>
" ]]]
"  切换自动换行 [[[2
nnoremap <Leader>wr :execute &wrap==1 ? 'set nowrap' : 'set wrap'<CR>
" ]]]
"     Shift+鼠标滚动[[[2
if v:version < 703
	nmap <silent> <S-MouseDown> zhzhzh
	nmap <silent> <S-MouseUp> zlzlzl
	vmap <silent> <S-MouseDown> zhzhzh
	vmap <silent> <S-MouseUp> zlzlzl
else
	map <S-ScrollWheelDown> <ScrollWheelRight>
	map <S-ScrollWheelUp> <ScrollWheelLeft>
	imap <S-ScrollWheelDown> <ScrollWheelRight>
	imap <S-ScrollWheelUp> <ScrollWheelLeft>
endif
" ]]]
" Remove the Windows ^M - when the encodings gets messed up [[[2
noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" ]]]
" 修复部分错按大写按键 [[[2
if has('user_commands')
	command! -bang -nargs=* -complete=file E e<bang> <args>
	command! -bang -nargs=* -complete=file W w<bang> <args>
	command! -bang -nargs=* -complete=file Wq wq<bang> <args>
	command! -bang -nargs=* -complete=file WQ wq<bang> <args>
	command! -bang Wa wa<bang>
	command! -bang WA wa<bang>
	command! -bang Q q<bang>
	command! -bang QA qa<bang>
	command! -bang Qa qa<bang>
endif
cmap Tabe tabe
" ]]]
"  以下是刷题用的  [[[2
"map <F4> :execute IO()<CR>
"let s:isopen=0
"function IO()
"	echo s:isopen
"	if s:isopen==0
"		let s:isopen = 1
"		rightbelow split a.in
"		rightbelow vsplit a.out	í
"		wincmd h
"	else
"		let s:isopen=0
"		wincmd t
"		only
"	endif
"endfunc
" ]]]
"  回车时前字符为{时自动换行补全  [[[2
function! <SID>OpenSpecial(ochar,cchar)
	let line = getline('.')
	let col = col('.') - 2
	if(line[col] != a:ochar)
		if(col > 0)
			return "\<esc>a\<CR>"
		else
			return "\<CR>"
		endif
	endif
	if(line[col+1] != a:cchar)
		call setline('.',line[:(col)].a:cchar.line[(col+1):])
	else
		call setline('.',line[:(col)].line[(col+1):])
	endif
	return "\<esc>a\<CR>;\<CR>".a:cchar."\<esc>\"_xk$\"_xa"
endfunction
inoremap <silent> <CR> <C-R>=<SID>OpenSpecial('{','}')<CR>
" ]]]
"  执行特定命令并保留光标位置及搜索历史 [[[2
function! Preserve(command)
	" preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" do the business:
	execute a:command
	" clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction
" ]]]
"  去掉行末空格并调整缩进 [[[2
function! StripTrailingWhitespaceAndFormat()
	call Preserve("%s/\\s\\+$//e")
	call Preserve("normal gg=G")
endfunction
nmap <Leader>ff :call StripTrailingWhitespaceAndFormat()<CR>
"  打开光标下的链接 [[[2
"  取得光标处的匹配
function! GetPatternAtCursor(pat)
  let col = col('.') - 1
  let line = getline('.')
  let ebeg = -1
  let cont = match(line, a:pat, 0)
  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, a:pat, cont)
    if (cont <= col) && (col < contn)
      let ebeg = match(line, a:pat, cont)
      let elen = contn - ebeg
      break
    else
      let cont = match(line, a:pat, contn)
    endif
  endwhile
  if ebeg >= 0
    return strpart(line, ebeg, elen)
  else
    return ""
  endif
endfunction
function! OpenURL()
  let s:url = GetPatternAtCursor('\v%(https?://|ftp://|file:/{3}|www\.)%(\w|[.-])+%(:\d+)?%(/%(\w|[~@#$%^&+=/.?:-])*[^,.?:''"-])?')
  if s:url == ""
    echohl WarningMsg
    echomsg '在光标处未发现URL！'
    echohl None
  else
    echo '??URL?' . s:url
    if g:isWindows
	" start 不是程序，所以无效。并且，cmd 只能使用双引号
      call system("cmd /q /c start \"" . s:url . "\"")
    else
      call system("setsid firefox '" . s:url . "' &")
    endif
  endif
  unlet s:url
endfunction
nmap <silent> <Leader>ur :call OpenURL()<CR>
" ]]]
" ]]]
"  以下为Lilydjwg的设置  [[[1
"   切换显示行号/相对行号 [[[2
function! s:toggle_number()
	if &nu && &rnu
		setlocal nornu
		setlocal nonu
	elseif &nu && !&rnu
		setlocal rnu
	else
		setlocal nu
		setlocal nornu
	endif
endfunction

" ]]]
"  退格删除自动缩进 [[[2
function! Lilydjwg_checklist_bs(pat)
	" 退格可清除自动出来的列表符号
	if getline('.') =~ a:pat
		let ind = indent(line('.')-1)
		if !ind
			let ind = indent(line('.')+1)
		endif
		call setline(line('.'), repeat(' ', ind))
		return ""
	else
		return "\<BS>"
	endif
endfunction
" ]]]
" ]]]
"  以下为插件的设置 [[[1
"  Ack.vim [[[2
if executable('ag')
	let g:ackprg = "ag --nocolor --column --hidden --nogroup --smart-case"
endif
"  ]]]
"-------------------------AutoClose------------------------------"  [[[2
" let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"', "'": "'", '`': '`'} 
" ]]]
"-------------------------Auto-Pairs------------------------------"  [[[2
let g:AutoPairsFlyMode=1
" ]]]
"-------------------------BufExplorer----------------------------"  [[[2
" 快速轻松的在缓存中切换（相当于另一种多个文件间的切换方式）
" <Leader>be 在当前窗口显示缓存列表并打开选定文件
" <Leader>bs 水平分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
" <Leader>bv 垂直分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
let g:bufExplorerFindActive = 0
autocmd MyAutoCmd BufWinEnter \[Buf\ List\] setlocal nonumber
let g:bufExplorerDefaultHelp = 0  " 不显示默认帮助信息
let g:bufExplorerSortBy = 'mru' " 使用最近使用的排列方式
" ]]]
"  cscope-wrapper  [[[2
if g:isWindows && g:hasCscope
	set csprg=cswrapper.exe
endif
" ]]]
"   easymotion  [[[2
let EasyMotion_leader_key = '<Leader><Leader>'
let EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
augroup MyAutoCmd
	autocmd ColorScheme * highlight EasyMotionTarget ctermfg=32 guifg=#0087df
	autocmd ColorScheme * highlight EasyMotionShade ctermfg=237 guifg=#3a3a3a
augroup END
" ]]]
" Emmet [[[2
let g:user_emmet_mode='a'
let g:use_emmet_complete_tag=1
let g:user_emmet_settings = {'lang': "zh-cn"}
" ]]]
"  Fugitive/GitGutter  [[[2
autocmd MyAutoCmd BufReadPost fugitive://* setlocal bufhidden=delete
" SignColumn should match background for
" things like vim-gitgutter
highlight clear SignColumn
" Current line number row will have same background color in relative mode.
" Things like vim-gitgutter will match LineNr highlight
highlight clear LineNr
let g:gitgutter_realtime = 0
nnoremap <silent> <Leader>gg :GitGutterToggle<CR>
"  ]]]
"   grep.vim[[[2
" let g:Grep_Default_Options = '--binary-files=without-match'
"  plugin - matchit.vim 对%命令进行扩展使得能在嵌套标签和语句之间跳转  [[[2
" % 正向匹配      g% 反向匹配
" [% 定位块首     ]% 定位块尾
" ]]]
" plugin - mark.vim 给各种tags标记不同的颜色，便于观看调式的插件。  [[[2
" 这样，当我输入“,hl”时，就会把光标下的单词高亮，在此单词上按“,hh”会清除该单词的高亮。如果在高亮单词外输入“,hh”，会清除所有的高亮。
" 你也可以使用virsual模式选中一段文本，然后按“,hl”，会高亮你所选中的文本；或者你可以用“,hr”来输入一个正则表达式，这会高亮所有符合这个正则表达式的文本。
nmap <silent> <leader>hl <plug>MarkSet
vmap <silent> <leader>hl <plug>MarkSet
nmap <silent> <leader>hh <plug>MarkClear
vmap <silent> <leader>hh <plug>MarkClear
nmap <silent> <leader>hr <plug>MarkRegex
vmap <silent> <leader>hr <plug>MarkRegex
" 自动居中
augroup MyAutoCmd
	autocmd VimEnter * nmap <silent> * <Plug>MarkSearchNext<Esc>zz
	autocmd VimEnter * nmap <silent> # <Plug>MarkSearchNext<Esc>zz
augroup END
" 你可以在高亮文本上使用“,#”或“,*”来上下搜索高亮文本。在使用了“,#”或“,*”后，就可以直接输入“#”或“*”来继续查找该高亮文本，直到你又用“#”或“*”查找了其它文本。
" <silent>* 当前MarkWord的下一个     <silent># 当前MarkWord的上一个
" <silent>/ 所有MarkWords的下一个    <silent>? 所有MarkWords的上一个
"- default highlightings ------------------------------------------------------
highlight def MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
highlight def MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
highlight def MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
highlight def MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
highlight def MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
highlight def MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black
" ]]]
"  plugin - NERD_commenter.vim 注释代码用的，以下映射已写在插件中 [[[2
" <leader>ca 在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
" <leader>cc 注释当前行
" <leader>cs 以”性感”的方式注释
" <leader>cA 在当前行尾添加注释符，并进入Insert模式
" <leader>cu 取消注释
" <leader>cm 添加块注释
" let NERD_c_alt_style = 1
" let NERDSpaceDelims = 1
" ]]]
"  plugin - NERD_tree.vim 文件管理器  [[[2
" 让Tree把自己给装饰得多姿多彩漂亮点
let NERDChristmasTree=1
" 控制当光标移动超过一定距离时，是否自动将焦点调整到屏中心
let NERDTreeAutoCenter=1
" 指定书签文件
let NERDTreeBookmarksFile=$VIMFILES.'/.cache/NERDTree_bookmarks'
" 排除 . .. 文件
let NERDTreeIgnore=['^\.$', '^\.\.$', '\.pyc', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
" 指定鼠标模式(1.双击打开 2.单目录双文件 3.单击打开)
let NERDTreeMouseMode=2
let NERDTreeQuitOnOpen=1
" 是否默认显示书签列表
let NERDTreeShowBookmarks=1
" 是否默认显示文件
let NERDTreeShowFiles=1
" 是否默认显示隐藏文件
let NERDTreeShowHidden=1
" 是否默认显示行号
let NERDTreeShowLineNumbers=0
" 窗口位置（'left' or 'right'）
let NERDTreeWinPos='left'
" 窗口宽度
let NERDTreeWinSize=31
" 启动时不默认打开NERDTreeTabs
let g:nerdtree_tabs_open_on_gui_startup=0
" ]]]
"  Tagbar [[[2
"let tagbar_left=1
let tagbar_width=30
let tagbar_singleclick=1
let g:tagbar_type_dosini = {
			\ 'ctagstype': 'ini',
			\ 'kinds': ['s:sections', 'b:blocks'],
			\ }
let g:tagbar_type_pgsql = {
			\ 'ctagstype': 'pgsql',
			\ 'kinds': ['f:functions', 't:tables'],
			\ }
autocmd MyAutoCmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx,*.ini call tagbar#autoopen()
" ]]]
"  xml.vim，使所有的标签都关闭[[[2
let xml_use_xhtml = 1
" ]]]
"-------------------------NeoComplcache---------------------------" [[[2
" " Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplcachd.
" let g:neocomplcache_enable_at_startup = 1
" " Use smartcase.
" let g:neocomplcache_enable_smart_case = 1
" " Use camel case completion.
" let g:neocomplcache_enable_camel_case_completion = 1
" " Use underbar completion.
" let g:neocomplcache_enable_underbar_completion = 1
" " 设置缓存目录
" let g:neocomplcache_temporary_dir=$VIMFILES.'/.cache/neocon'
" let g:neocomplcache_enable_fuzzy_completion=1
" " Set minimum syntax keyword length.
" let g:neocomplcache_min_syntax_length = 3
" let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" let g:neocomplcache_enable_quick_match = 1 " 每次补全菜单弹出时，可以再按一个”-“键，这是补全菜单中的每个候选词会被标上一个字母，只要再输入对应字母就可以马上完成选择。
" let g:neocomplcache_dictionary_filetype_lists = {
" 			\ 'default'    : '',
" 			\ 'bash'       : $HOME.'/.bash_history',
" 			\ 'scheme'     : $HOME.'/.gosh_completions',
" 			\ 'css'        : $VIMFILES.'/dict/css.txt',
" 			\ 'php'        : $VIMFILES.'/dict/php.txt',
" 			\ 'javascript' : $VIMFILES.'/dict/javascript.txt',
" 			\ }
" 
" " Define keyword.
" if !exists('g:neocomplcache_keyword_patterns')
" 	let g:neocomplcache_keyword_patterns = {}
" endif
" let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" 
" " Plugin key-mappings.
" "imap <C-k>     <Plug>(neocomplcache_snippets_expand)
" "smap <C-k>     <Plug>(neocomplcache_snippets_expand)
" inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-l>     neocomplcache#complete_common_string()
" "<CR>: close popup and save indent.
" "inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
" "<TAB>: completion. NO USE with snipmate
" "<C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-Y> neocomplcache#close_popup()
" inoremap <expr><C-e> neocomplcache#cancel_popup()
" "inoremap <expr><Enter> pumvisible() ? neocomplcache#close_popup()."\<C-n>" : "\<Enter>"
" "inoremap <expr><Enter> pumvisible() ? "\<C-Y>" : "\<Enter>" 
" 
" "下面的 暂时不会，等会了再慢慢搞,暂时先用默认的
" "imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" 
" " Recommended key-mappings.
" " <CR>: close popup and save indent.
" "inoremap <expr><CR>  neocomplcache#smart_close_popup()."\<CR>"
" " <TAB>: completion. 下面的貌似冲突了
" "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" " <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y> neocomplcache#close_popup()
" inoremap <expr><C-e> neocomplcache#cancel_popup()
" " 类似于AutoComplPop用法
" let g:neocomplcache_enable_auto_select = 1
" 
" " Shell like behavior(not recommended).
" set completeopt+=longest
" "let g:neocomplcache_disable_auto_complete = 1
" "inoremap <expr><Tab>  pumvisible() ? "\<Down>" : "\<TAB>"
" "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" 
" 
" " Enable omni completion.
" augroup Filetype_Specific
" 	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" 	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" 	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" 	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" 	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" 	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
" augroup END
" 
" " Enable heavy omni completion.
" if !exists('g:neocomplcache_omni_patterns')
" 	let g:neocomplcache_omni_patterns = {}
" endif
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
" let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"------------------neocomplcache---------------------------------  ]]]
"  NeoComplete [[[2
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" 设置缓存目录
let g:neocomplete#data_directory=$VIMFILES.'/.cache/neocomplete'
let g:neocomplete#enable_auto_delimiter = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default'    : '',
			\ 'vimshell'   : $HOME.'/.vimshell_hist',
			\ 'scheme'     : $HOME.'/.gosh_completions',
			\ 'bash'       : $HOME.'/.bash_history',
			\ 'c'          : $VIMFILES.'/dict/c.dict',
			\ 'cpp'        : $VIMFILES.'/dict/cpp.dict',
			\ 'css'        : $VIMFILES.'/dict/css.txt',
			\ 'php'        : $VIMFILES.'/dict/php.txt',
			\ 'javascript' : $VIMFILES.'/dict/javascript.txt',
			\ 'lua'        : $VIMFILES.'/dict/lua.dict',
			\ 'vim'        : $VIMFILES.'/dict/vim.dict'
			\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return neocomplete#smart_close_popup() . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
augroup Filetype_Specific
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" ]]]
"  NeoSnippet  [[[2
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory=$VIMFILES.'/bundle/vim-snippets/snippets'

" Plugin key-mappings.
"imap <C-k> <Plug>(neocomplcache_snippets_force_expand)
"smap <C-k> <Plug>(neocomplcache_snippets_force_expand)
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <C-l> <Plug>(neocomplcache_snippets_force_jump)
smap <C-l> <Plug>(neocomplcache_snippets_force_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2
	" 'i' is for neosnippet
	set concealcursor=i
	if !g:isWindows
		set listchars+=conceal:Δ
	endif
endif

" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
set completeopt-=preview
" ]]]
" Unite [[[2
let bundle = neobundle#get('unite.vim')
function! bundle.hooks.on_source(bundle)
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#filters#sorter_default#use(['sorter_rank'])
	call unite#set_profile('files', 'smartcase', 1)
	call unite#custom#source('line,outline','matchers','matcher_fuzzy')
	call unite#custom#source('file_rec/async,file_mru,file_rec,buffer',
				\ 'matchers',['converter_tail', 'matcher_fuzzy'])
	call unite#custom#source('file_rec/async,file_mru',
				\ 'converters',['converter_file_directory'])
	call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
				\ 'ignore_pattern', join([
				\ '\.git/',
				\ 'git5/.*/review/',
				\ 'google/obj/',
				\ 'tmp/',
				\ '.sass-cache',
				\ ], '\|'))
endfunction

let g:unite_data_directory=$VIMFILES.'/.cache/unite'
" Start in insert mode
let g:unite_enable_start_insert=1
let g:unite_enable_short_source_names = 1
let g:unite_cursor_line_highlight = 'TabLineSel'
" Enable history yank source
let g:unite_source_history_yank_enable=1
" Open in bottom right
let g:unite_split_rule = "botright"
let g:unite_source_rec_max_cache_files=5000
if !g:isWindows
	let g:unite_prompt =  '▶'
	let g:unite_marked_icon = '✗'
endif
" For ack.
if executable('ag')
	let g:unite_source_grep_command='ag'
	let g:unite_source_grep_default_opts=
				\ '--line-numbers --nocolor --nogroup --hidden --smart-case -C4'
	let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
	let g:unite_source_grep_command='ack'
	let g:unite_source_grep_default_opts='--no-heading --no-color -a -C4'
	let g:unite_source_grep_recursive_opt=''
endif

let g:unite_source_file_mru_limit = 1000
let g:unite_cursor_line_highlight = 'TabLineSel'
" let g:unite_abbr_highlight = 'TabLine'

let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_file_mru_time_format = ''

function! s:unite_settings()
	nmap <buffer> <esc> <plug>(unite_exit)
	imap <buffer> <Esc><Esc> <plug>(unite_exit)
	imap <buffer> <BS> <Plug>(unite_delete_backward_path)
	imap <buffer><expr> j unite#smart_map('j', '')
	nmap <buffer><expr><silent> <2-leftmouse>
				\ unite#smart_map('l', unite#do_action(unite#get_current_unite().context.default_action))
	nmap <buffer> <c-j> <Plug>(unite_loop_cursor_down)
	nmap <buffer> <c-k> <Plug>(unite_loop_cursor_up)
	imap <buffer> jk <Plug>(unite_insert_leave)
endfunction
autocmd MyAutoCmd FileType unite call s:unite_settings()

" The prefix key
nmap ; [unite]
xmap ; [unite]
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>

if g:isWindows
	nnoremap <silent> [unite]<space>
				\ :<C-u>Unite -buffer-name=mixed -no-split -multi-line
				\ jump_point file_point file_rec:! file file/new buffer file_mru bookmark<cr><c-u>
	nnoremap <silent> [unite]f :<C-u>Unite -toggle -buffer-name=files file_rec<cr><c-u>
else
	nnoremap <silent> [unite]<space>
				\ :<C-u>Unite -buffer-name=mixed -no-split -multi-line
				\ jump_point file_point file_rec/async:! file file/new buffer file_mru bookmark<cr><c-u>
	nnoremap <silent> [unite]f
				\ :<C-u>Unite -toggle -buffer-name=files file_rec/async<cr><c-u>
endif
nnoremap <silent> [unite]n :<C-u>Unite -buffer-name=bundle neobundle<cr>
nnoremap <silent> [unite]*
			\ :<C-u>UniteWithCursorWord -no-split -buffer-name=line line<cr>
" Quick buffer and mru
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer file_mru<cr>
" Quick grep from cwd
nnoremap <silent> [unite]/
			\ :<C-u>Unite -auto-preview -no-empty -no-quit -resume -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m
			\ :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
" Quickly switch lcd
nnoremap <silent> [unite]d
			\ :<C-u>Unite -buffer-name=change-cwd -default-action=lcd directory_mru<CR>
" Quick registers
nnoremap <silent> [unite]y
			\ :<C-u>Unite -buffer-name=register register history/yank<CR>
xnoremap <silent> [unite]r
			\ d:<C-u>Unite -buffer-name=register register history/yank<CR>
" unite-tag
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=tag tag tag/file<cr>
" unite-outline
nnoremap <silent> [unite]o
			\ :<C-u>Unite -start-insert -resume -buffer-name=outline -vertical outline<cr>
" unite-help
nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<cr>
" ]]]
" VimShell [[[2
if g:isWindows
	let g:vimshell_prompt =  '$'
else
	let g:vimshell_prompt =  '▶'
endif
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
nmap <Leader>sh :VimShell -split<CR>
let g:vimshell_temporary_directory=$VIMFILES.'/.cache/vimshell'
let g:vimshell_vimshrc_path=$VIMFILES.'/vimshrc'
" ]]]
"   Syntastic [[[2
if !g:isWindows
	let g:syntastic_error_symbol         = '✗ '
	let g:syntastic_style_error_symbol   = '✠ '
	let g:syntastic_warning_symbol       = '∆ '
	let g:syntastic_style_warning_symbol = '≈'
endif
let g:syntastic_mode_map = { 'mode': 'passive',
			\ 'active_filetypes': ['lua', 'php', 'sh'],
			\ 'passive_filetypes': ['puppet'] }

"   ]]]
" PIV [[[2
let g:DisableAutoPHPFolding = 0
let g:PIVAutoClose = 0
" ]]]
" UndoTree  [[[2
let g:undotree_SplitLocation='botright'
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
" ]]]
" PO(Portable Object gettext翻译)  [[[2
" Actions			                           Key mappings
" -------------------------------------------------------
" Move to a string (transl. or untransl) forward      \m
" Move to a string (transl. or untransl) backward     \M
" Begin to comment this entry                         \C
" Move to an untransl. string forward                 \u
" Move to an untransl. string backward                \U
" Move to the next fuzzy translation                  \f
" Move to the previous fuzzy translation              \F
" Label the translation fuzzy                         \z
" Remove the fuzzy label                              \Z
" Split-open the file under cursor                    gf
" Show msgfmt statistics for the file(*)              \s
" Browse through msgfmt errors for the file(*)        \e
" Put the translator info in the header               \t
" Put the lang. team info in the header               \l
" Format the whole file(wrap the lines etc.)          \W
" -------------------------------------------------------
" (*) Only available on UNIX computers.
augroup Filetype_Specific
	autocmd FileType po let maplocalleader="`" | let g:maplocalleader="`"
augroup END
let g:po_translator = "Firef0x <firefgx { at } gmail { dot } com>"
" ]]]
" indent/html.vim [[[2
let g:html_indent_inctags = "html,body,head,tbody,p,li,dd,marquee,header,nav,article,section"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
"  ]]]
" syntax/haskell.vim [[[2
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
"  ]]]
" syntax/python.vim [[[2
let python_highlight_all = 1
"  ]]]
" syntax/vim.vim 默认会高亮 s:[a-z] 这样的函数名为错误 [[[2
let g:vimsyn_noerror = 1
let g:netrw_list_hide = '^\.[^.].*'
"  ]]]
" netrw使用curl  [[[2
if executable("curl")
  let g:netrw_http_cmd = "curl"
  let g:netrw_http_xcmd = "-o"
endif
"  ]]]
"   surround [[[2
"  Old text                  Command     New text ~
"  "Hello *world!"           ds"         Hello world!
"  [123+4*56]/2              cs])        (123+456)/2
"  "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
"  if *x>3 {                 ysW(        if ( x>3 ) {
"  my $str = *whee!;         vlllls'     my $str = 'whee!';
"  "Hello *world!"           ds"         Hello world!
"  (123+4*56)/2              ds)         123+456/2
"  <div>Yo!*</div>           dst         Yo!
"  Hello w*orld!             ysiw)       Hello (world)!
"      原 cs 和 cscope 的冲突了
augroup MyAutoCmd
	autocmd VimEnter * silent! nunmap cs
	autocmd VimEnter * nmap cS <Plug>Csurround
augroup END
"   VimIm，不要更改弹出菜单的颜色[[[2
"let g:vimim_menu_color = 1
"  vimwiki[[[2
"let g:vimwiki_list = [{'path': '~/.vimwiki/'}]
"let g:vimwiki_camel_case = 0
"let g:vimwiki_hl_cb_checked = 1
"let g:vimwiki_folding = 0
"let g:vimwiki_browsers = ['firefox']
"let g:vimwiki_CJK_length = 1
"let g:vimwiki_dir_link = 'index'
"let g:vimwiki_html_header_numbering = 2
"let g:vimwiki_conceallevel = 2
" PowerLine/AirLine  [[[2
" 设置显示字体和大小。guifontwide为等宽汉字字体。(干扰Airline，暂不设置)
if g:isWindows
	" set guifont=Consolas\ for\ Powerline\ FixedD:h12
	set guifont=YaHei_Consolas_Hybrid:h12
	" set guifontwide=XHei-Mono:h12,黑体:h12
	set laststatus=2
	" set t_Co=256
	" let g:Powerline_symbols = 'fancy'
elseif (g:isGUI || g:isColor)
	set guifont=Inconsolata\ for\ Powerline\ Medium\ 12
	" set guifontwide=WenQuanYi\ ZenHei\ Mono\ 12
	set laststatus=2
	" set t_Co=256
	" let g:Powerline_symbols = 'fancy'
else
	set guifont=Monospace\ 12
endif
" Airline Specific [[[3
if (g:isWindows || g:isGUI || g:isColor)
	let g:airline_powerline_fonts=1
	let g:airline_theme='light'
	let g:airline#extensions#tabline#enabled=1
	let g:airline#extensions#tabline#tab_nr_type=1
	let g:airline#extensions#tabline#buffer_nr_show=1
	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
	endif
	" let g:airline_symbols.space = "\ua0"
endif
" 显示Mode的简称
let g:airline_mode_map = {
			\ '__' : '-',
			\ 'n'  : 'N',
			\ 'i'  : 'I',
			\ 'R'  : 'R',
			\ 'c'  : 'C',
			\ 'v'  : 'V',
			\ 'V'  : 'VL',
			\ '' : 'VB',
			\ 's'  : 'S',
			\ 'S'  : 'SL',
			\ '' : 'SB',
			\ }
if g:isWindows
	let g:airline_symbols.whitespace = ""
	" powerline symbols
	" let g:airline_left_sep                         = ''
	" let g:airline_left_alt_sep                     = ''
	" let g:airline#extensions#tabline#left_sep      = ''
	" let g:airline#extensions#tabline#left_alt_sep  = ''
	" let g:airline_right_sep                        = ''
	" let g:airline_right_alt_sep                    = ''
	" let g:airline#extensions#tabline#right_sep     = ''
	" let g:airline#extensions#tabline#right_alt_sep = ''
	" let g:airline_symbols.branch                   = ''
	" let g:airline_symbols.readonly                 = ''
	" let g:airline_symbols.linenr                   = ''
	" elseif g:isGUI
	" 	" unicode symbols
	" 	let g:airline_left_sep                     = '»'
	" 	let g:airline_left_sep                     = '▶'
	" let g:airline#extensions#tabline#left_sep  = '▶'
	" 	let g:airline_right_sep                    = '«'
	" 	let g:airline_right_sep                    = '◀'
	" 	let g:airline#extensions#tabline#right_sep = '◀'
	" 	let g:airline_symbols.linenr               = '␊ '
	" 	" let g:airline_symbols.linenr             = '␤ '
	" 	" let g:airline_symbols.linenr             = '¶'
	" 	let g:airline_linecolumn_prefix            = '␊ '
	" 	" let g:airline_linecolumn_prefix          = '␤ '
	" 	" let g:airline_linecolumn_prefix          = '¶'
	" 	let g:airline_symbols.branch               = '⎇ '
	" 	let g:airline_fugitive_prefix              = '⎇ '
	" 	let g:airline_paste_symbol                 = 'ρ'
	" 	let g:airline_paste_symbol                 = 'Þ'
	" 	let g:airline_paste_symbol                 = '∥'
	"	let g:airline_symbols.whitespace           = 'Ξ'
endif
" ]]]
" ]]]
"  CtrlP  [[[2
" let g:ctrlp_working_path_mode='ra'
" " r -- the nearest ancestor that contains one of these directories or files: `.git/` `.hg/` `.svn/` `.bzr/` `_darcs/`
" let g:ctrlp_follow_symlinks = 1
" 
" let g:ctrlp_cache_dir=$VIMFILES.'/.cache/ctrlp'
" let g:ctrlp_custom_ignore = {
"     \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.rvm$',
"     \ 'file': '\.exe$\|\.so$\|\.dll$\|\.o$\|\.pyc$' }
" 
" let g:ctrlp_user_command = {
"     \ 'types': {
"         \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
"         \ 2: ['.hg', 'hg --cwd %s locate -I .'],
"     \ },
"     \ 'fallback': 'find %s -type f'
" \ }
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'mixed']
" 
" ]]]
" Rainbow Parentheses 括号显示增强 [[[2
let g:rbpt_colorpairs = [
			\ ['brown'       , 'RoyalBlue3']  ,
			\ ['Darkblue'    , 'SeaGreen3']   ,
			\ ['darkgray'    , 'DarkOrchid3'] ,
			\ ['darkgreen'   , 'firebrick3']  ,
			\ ['darkcyan'    , 'RoyalBlue3']  ,
			\ ['darkred'     , 'SeaGreen3']   ,
			\ ['darkmagenta' , 'DarkOrchid3'] ,
			\ ['brown'       , 'firebrick3']  ,
			\ ['gray'        , 'RoyalBlue3']  ,
			\ ['black'       , 'SeaGreen3']   ,
			\ ['darkmagenta' , 'DarkOrchid3'] ,
			\ ['Darkblue'    , 'firebrick3']  ,
			\ ['darkgreen'   , 'RoyalBlue3']  ,
			\ ['darkcyan'    , 'SeaGreen3']   ,
			\ ['darkred'     , 'DarkOrchid3'] ,
			\ ['red'         , 'firebrick3']  ,
			\ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
" 默认打开并关联大中小括号
augroup MyAutoCmd
	autocmd VimEnter * RainbowParenthesesToggle
	autocmd Syntax * RainbowParenthesesLoadRound
	autocmd Syntax * RainbowParenthesesLoadSquare
	autocmd Syntax * RainbowParenthesesLoadBraces
augroup END
" ]]]
"CCtree.Vim C Call-Tree Explorer 源码浏览工具 关系树 (赞) [[[2
"1. 除了cscope ctags 程序的安装,还需安装强力胶 ccglue(ctags-cscope glue): http://sourceforge.net/projects/ccglue/files/src/
" (1) ./configure && make && make install
" (2) $ccglue -S cscope.out -o cctree.out 或 $ccglue -S cscope1.out cscope2.out -o cctree.out
" (3) :CCTreeLoadXRefDBFromDisk cctree.out
"2. 映射快捷键(上面F1) 其中$CCTREE_DB是环境变量,写在~/.bashrc中
" map :CCTreeLoadXRefDBFromDisk $CCTREE_DB
" eg.
" export CSCOPE_DB=/home/tags/cscope.out
" export CCTREE_DB=/home/tags/cctree.out
" export MYTAGS_DB=/home/tags/tags

" "注: 如果没有装ccglue ( 麻烦且快捷键不好设置,都用完了 )
" (1) map xxx :CCTreeLoadDB $CSCOPE_DB "这样加载有点慢, cscope.out cctree.out存放的格式不同
" (2) map xxx :CCTreeAppendDB $CSCOPE_DB2 "最将另一个库
" (3) map xxx :CCTreSaveXRefDB $CSCOPE_DB "格式转化xref格式
" (4) map xxx :CCTreeLoadXRefDB $CSCOPE_DB "加载xref格式的库 (或者如下)
"map xxx :CCTreeLoadXRefDBFromDisk cscope.out "加载xref格式的库
" (5) map xxx :CCTreeUnLoadDB "卸载所有的数据库
"3. 设置
let g:CCTreeDisplayMode = 2 " 当设置为垂直显示时, 模式为3最合适. (1-minimum width, 2-little space, 3-wide)
let g:CCTreeWindowVertical = 1 " 水平分割,垂直显示
let g:CCTreeWindowMinWidth = 40 " 最小窗口
let g:CCTreeUseUTF8Symbols = 1 "为了在终端模式下显示符号
"4. 使用
"1) 将鼠标移动到要解析的函数上面ctrl+\组合键后，按>键，就可以看到该函数调用的函数的结果
"2) 将鼠标移动到要解析的函数上面ctrl+\组合键后，按<键，就可以看到调用该函数的函数的结果
"  ]]]
"  SrcExpl -- 增强源代码浏览，其功能就像Windows中的"Source Insight" [[[2
" :SrcExpl                                   "打开浏览窗口
" :SrcExplClose                              "关闭浏览窗口
" :SrcExplToggle                             "打开/闭浏览窗口
"  ]]]
" Tabularize  代码对齐工具 [[[2
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
"  ]]]
" Tag Highlight  代码对齐工具 [[[2
if !exists('g:TagHighlightSettings')
	let g:TagHighlightSettings = {}
endif
if !g:hasPython
	let g:TagHighlightSettings['ForcedPythonVariant'] = 'compiled'
endif
"  ]]]
"  Vim Indent Guide [[[2
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_color_change_percent=3
if g:isGUI==0
	let g:indent_guides_auto_colors=0
	function! s:indent_set_console_colors()
		hi IndentGuidesOdd ctermbg=235
		hi IndentGuidesEven ctermbg=236
	endfunction
	autocmd MyAutoCmd VimEnter,Colorscheme * call s:indent_set_console_colors()
endif
"  ]]]
"  vimperator.vim [[[2
autocmd MyAutoCmd SwapExists vimperator*.tmp
			\ :runtime plugin/vimperator.vim | call VimperatorEditorRecover(1)
" ]]]
"   插件调出快捷键  [[[2
"  a.vim  F9 切换.c/.h  [[[3
" :A  ---切换头文件并独占整个窗口
" :AV ---切换头文件并垂直分割窗口
" :AS ---切换头文件并水平分割窗口
nnoremap <silent> <F9> :A<CR>
" ]]]
"  Ack  Ctrl-F4 查找光标下词语  [[[3
nnoremap <silent> <C-F4> :Ack<CR>
"  ]]]
"  开关CCTree Ctrl-F12 [[[3
if g:hasCTags && g:hasCscope
	nmap <C-F12> :call LoadCCTree()<CR>
	function! LoadCCTree()
		if filereadable('cctree.out')
			execute "CCTreeLoadXRefDBFromDisk cctree.out"
		elseif filereadable('cscope.out')
			execute "CCTreeLoadDB cscope.out"
		endif
	endfunction
endif
"  ]]]
"  开关Fugitive ,g{c,d,r,w} [[[3
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gr :Gread<CR>:GitGutter<CR>
nnoremap <silent> <Leader>gw :Gwrite<CR>:GitGutter<CR>
"  ]]]
"  开关Gitv ,g{v,V} [[[3
nnoremap <silent> <Leader>gv :Gitv<CR>
nnoremap <silent> <Leader>gV :Gitv!<CR>
"  ]]]
"  开关NERDTree F2 [[[3
function! ShowNerdTree()
	execute "TagbarClose"
	execute "NERDTreeTabsToggle"
endfunction
nmap <F2> :call ShowNerdTree()<CR>
" ]]]
"  开关Tagbar F3 [[[3
nmap <F3> :TagbarToggle<CR>
" ]]]
"  开关SrcExpl F4 [[[3
nnoremap <silent> <F4> :SrcExplToggle<CR>
"  ]]]
"  开关撤销树 F8 [[[3
nmap <silent> <F8> :UndotreeToggle<CR>
" ]]]
"  开关CtrlP [[[3
" nmap <M-m> :CtrlPMRU<CR>
" nmap <M-n> :CtrlPBuffer<CR>
"  <Leader>sh 调出命令行界面 [[[3
" if g:isWindows
" 	nmap <Leader>sh :ConqueTermVSplit cmd.exe<CR> 
" elseif executable('zsh')
" 	nmap <Leader>sh :ConqueTermVSplit zsh<CR> 
" elseif executable('bash')
" 	nmap <Leader>sh :ConqueTermVSplit bash<CR> 
" else
" 	echo "Fail to invoke shell!"
" endif
"  ]]]
"  vim-jsbeautify 格式化javascript ,ff [[[3
augroup Filetype_Specific
	autocmd FileType javascript nnoremap <buffer> <Leader>ff :call JsBeautify()<CR>
	autocmd FileType html nnoremap <buffer> <Leader>ff :call HtmlBeautify()<CR>
	autocmd FileType css nnoremap <buffer> <Leader>ff :call CSSBeautify()<CR>
augroup END
"  ]]]
" NeoBundle [[[3
" nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>
"  ]]]
"  Vim辅助工具配置  [[[1
"  cscope setting [[[2
if g:hasCscope
	" 设置 [[[3
	set csto=1
	set cst
	set cscopequickfix=s-,c-,d-,i-,t-,e-

	" add any database in current directory
	function! Cscope_Add()
		set nocsverb
		if filereadable("cscope.out")
			cs add cscope.out
		endif
		set csverb
	endfunction

	"  调用这个函数就可以用cscope生成数据库，并添加到vim中
	function! Cscope_DoTag()
		if g:isWindows
			silent! execute "Dispatch! dir /b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
		else
			silent! execute "Dispatch! find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' >> cscope.files"
		endif
		silent! execute "Dispatch! cscope -bkq"
		call Cscope_Add()
		silent! execute "Dispatch! ccglue -S cscope.out -o cctree.out"
	endfunction

	autocmd MyAutoCmd BufRead *.c,*.cpp,*.h,*.java,*.cs call Cscope_Add()

	" 映射 [[[3
	" 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
	nmap css :cs find s <C-R>=expand("<cword>")<CR><CR>
	" 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
	nmap csg :cs find g <C-R>=expand("<cword>")<CR><CR>
	" 查找本函数调用的函数
	nmap csd :cs find d <C-R>=expand("<cword>")<CR><CR>
	" 查找调用本函数的函数
	nmap csc :cs find c <C-R>=expand("<cword>")<CR><CR>
	" 查找指定的字符串
	nmap cst :cs find t <C-R>=expand("<cword>")<CR><CR>
	" 查找egrep模式，相当于egrep功能，但查找速度快多了
	nmap cse :cs find e <C-R>=expand("<cword>")<CR><CR>
	" 查找并打开文件，类似vim的find功能
	nmap csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
	" 查找包含本文件的文件
	nmap csi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	" 生成新的数据库
	nmap csn :call Cscope_DoTag()<CR>

	" 自己来输入命令
	nmap cs<Space> :cs find 
endif
" ]]]
"  Win平台下窗口全屏组件 gvimfullscreen.dll [[[2
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
" Shift + t 降低窗口透明度
" Shift + y 加大窗口透明度
" Shift + r 切换Vim是否总在最前面显示
" Vim启动的时候自动使用当前颜色的背景色以去除Vim的白色边框
if g:isGUI && has('gui_win32') && has('libcall')
	let g:MyVimLib = 'gvimfullscreen.dll'
	function! ToggleFullScreen()
		call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
	endfunction

	let g:VimAlpha = 245
	function! SetAlpha(alpha)
		let g:VimAlpha = g:VimAlpha + a:alpha
		if g:VimAlpha < 180
			let g:VimAlpha = 180
		endif
		if g:VimAlpha > 255
			let g:VimAlpha = 255
		endif
		call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
	endfunction

	let g:VimTopMost = 0
	function! SwitchVimTopMostMode()
		if g:VimTopMost == 0
			let g:VimTopMost = 1
		else
			let g:VimTopMost = 0
		endif
		call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
	endfunction
	"映射 F11 切换全屏vim
	noremap <F11> :call ToggleFullScreen()<cr>
	"切换Vim是否在最前面显示
	nmap <M-r> :call SwitchVimTopMostMode()<cr>
	"增加Vim窗体的不透明度
	" nmap <s-t> :call SetAlpha(10)<cr>
	"增加Vim窗体的透明度
	" nmap <s-y> :call SetAlpha(-10)<cr>
	" 默认设置透明
	autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endif
" ]]]
"  Vim Modeline [[[1
" vim:fdm=marker:fmr=[[[,]]]
