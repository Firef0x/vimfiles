scriptencoding utf-8
"  Last Modified: 04 Jul 2017 21:30 +0800
"  其他文件 [[[1
"    引用 Example 设置 [[[2
if !exists("g:VimrcIsLoad")
	runtime vimrc_example.vim
endif
"]]]
"]]]
"  我的设置
"  准备工作 [[[1
"    判定语句及定义变量 [[[2
"      判定当前操作系统类型 [[[3
if has("win32") || has("win95") || has("win64") || has("win16")
	let s:isWindows=1
	" For gVimPortable
	let $VIMFILES = $VIM."/../../Data/settings/vimfiles"
else
	let s:isWindows=0
	let $VIMFILES = $HOME."/.vim"
endif
if (!s:isWindows
			\ && (has('mac') || has('macunix') || has('gui_macvim') ||
			\ (!executable('xdg-open') && system('uname') =~? '^darwin')))
	let s:isMac=1
else
	let s:isMac=0
endif
" ]]]
"      判定当前是否图形界面 [[[3
if has("gui_running")
	let s:isGUI=1
else
	let s:isGUI=0
endif
" ]]]
"      判定当前终端是否256色 [[[3
if (s:isWindows==0 && s:isGUI==0 &&
			\ (&term =~ "256color" || &term =~ "xterm" || &term =~ "fbterm"))
	let s:isColor=1
else
	let s:isColor=0
endif
" ]]]
"      判定当前是否有 Ack/Ag [[[3
if executable('ack')
	let s:hasAck=1
else
	let s:hasAck=0
endif
if executable('ag')
	let s:hasAg=1
else
	let s:hasAg=0
endif
" ]]]
"      判定当前是否有 Cscope/Global [[[3
if has('cscope')
	let s:hasCscope=1
	if executable('cscope')
		let s:hasCscopeExe=1
	else
		let s:hasCscopeExe=0
	endif
	if executable('ccglue')
		let s:hasCCglueExe=1
	else
		let s:hasCCglueExe=0
	endif
	if executable('gtags-cscope')
		let s:hasGtagsCscopeExe=1
	else
		let s:hasGtagsCscopeExe=0
	endif
else
	let s:hasCscope=0
	let s:hasCscopeExe=0
	let s:hasCcglueExe=0
	let s:hasGtagsCscopeExe=0
endif
" ]]]
"      判定当前是否有 CTags [[[3
if executable('ctags')
	let s:hasCTags=1
else
	let s:hasCTags=0
endif
" ]]]
"      判定当前是否支持 gvimfullscreen.dll [[[3
if s:isGUI && has('gui_win32') && has('libcall')
	let s:hasVFS=1
else
	let s:hasVFS=0
endif
" ]]]
"      判定当前是否支持 Lua ，并设置自动完成使用的插件 [[[3
" NeoComplete 要求支持 Lua
if has('lua')
	let s:hasLua=1
	let s:autocomplete_method = 'neocomplete'
else
	let s:hasLua=0
	let s:autocomplete_method = 'neocomplcache'
endif
" ]]]
"      判定当前是否支持 Node.js [[[3
if has('node') || has('nodejs') || has('iojs')
	let s:hasNode=1
else
	let s:hasNode=0
endif
" ]]]
"      判定当前是否支持 Python 2或3 [[[3
if has('python') || has('python3')
	let s:hasPython=1
else
	let s:hasPython=0
endif
" ]]]
"      判定当前终端是否 Tmux [[[3
if exists('$TMUX')
	let s:isTmux=1
else
	let s:isTmux=0
endif
" ]]]
"      判定当前是否服务器环境 [[[3
if filereadable(expand("$VIMFILES/vimrc.isserver"))
	let s:isServer=1
else
	let s:isServer=0
endif
" ]]]
" ]]]
"    设置自动命令组 [[[2
"      特定文件类型自动命令组 [[[3
augroup Filetype_Specific
	autocmd!
augroup END
" ]]]
"      默认自动命令组 [[[3
augroup MyAutoCmd
	autocmd!
augroup END
" ]]]
" ]]]
"    设置缓存目录 [[[2
" (以下取自 https://github.com/bling/dotvim )
let s:cache_dir = $VIMFILES."/.cache"
" ]]]
" ]]]
"  定义函数 [[[1
"    (以下取自 https://github.com/asins/vim ) [[[2
"      回车时前字符为{时自动换行补全 [[[3
function! <SID>OpenSpecial(ochar,cchar)
	let line = getline('.')
	let col = col('.') - 2
	if(line[col] != a:ochar)
		if(col > 0)
			return "\<Esc>a\<CR>"
		else
			return "\<CR>"
		endif
	endif
	if(line[col+1] != a:cchar)
		call setline('.',line[:(col)].a:cchar.line[(col+1):])
	else
		call setline('.',line[:(col)].line[(col+1):])
	endif
	return "\<Esc>a\<CR>;\<CR>".a:cchar."\<Esc>\"_xk$\"_xa"
endfunction
" ]]]
" ]]]
"    (以下取自 https://github.com/bling/dotvim ) [[[2
"      获取缓存目录 [[[3
function! s:get_cache_dir(suffix)
	return resolve(expand(s:cache_dir . "/" . a:suffix))
endfunction
" ]]]
"      保证该目录存在，若不存在则新建目录 [[[3
function! EnsureExists(path)
	if !isdirectory(expand(a:path))
		call mkdir(expand(a:path))
	endif
endfunction
" ]]]
"      执行特定命令并保留光标位置及搜索历史 [[[3
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
"      格式化全文 [[[3
function! FullFormat()
	call Preserve("normal gg=G")
endfunction
" ]]]
" ]]]
"    (以下取自 https://github.com/lilydjwg/dotvim ) [[[2
"      删除所有未显示且无修改的缓冲区以减少内存占用 [[[3
function! s:cleanbufs()
	for bufNr in filter(range(1, bufnr('$')),
				\ 'buflisted(v:val) && !bufloaded(v:val)')
		execute bufNr . 'bdelete'
	endfor
endfunction
" ]]]
"      切换显示行号/相对行号/不显示 [[[3
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
"      退格删除自动缩进 [[[3
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
"      取得光标处的匹配 [[[3
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
" ]]]
"      用火狐打开链接 [[[3
function! OpenURL()
	let s:url = GetPatternAtCursor('\v%(https?|ftp)://[^]''" \t\r\n>*。，\`)]*')
	if s:url == ""
		echohl WarningMsg
		echomsg '在光标处未发现URL！'
		echohl None
	else
		echo '打开URL：' . s:url
		if s:isWindows
			" start 不是程序，所以无效。并且，cmd 只能使用双引号
			" call system("cmd /q /c start \"" . s:url . "\"")
			call system("E:\\PortableApps\\FirefoxPortable\\firefox\\firefox.exe \"" . s:url . "\"")
		elseif s:isMac
			call system("open -a \"/Applications/Google Chrome.app\" '" . s:url . "'")
		else
			" call system("gnome-open " . s:url)
			call system("setsid firefox '" . s:url . "' &")
		endif
	endif
	unlet s:url
endfunction
" ]]]
"      %xx -> 对应的字符(到消息) [[[3
function! GetHexChar()
	let chars = GetPatternAtCursor('\(%[[:xdigit:]]\{2}\)\+')
	if chars == ''
		echohl WarningMsg
		echo '在光标处未发现%表示的十六进制字符串！'
		echohl None
		return
	endif
	let str = substitute(chars, '%', '\\x', 'g')
	exe 'echo "'. str . '"'
endfunction
" ]]]
"      打开 NERDTree，使用当前文件目录或者当前目录 [[[3
function! NERDTreeOpen()
	silent execute "TagbarClose"
	if exists("t:NERDTreeBufName")
		NERDTreeToggle
	else
		try
			NERDTree `=expand('%:h')`
		catch /E121/
			NERDTree `=getcwd()`
		endtry
	endif
endfunction
" ]]]
" ]]]
"    (以下取自 https://github.com/Shougo/shougo-s-github ) [[[2
"      切换选项开关 [[[3
function! ToggleOption(option_name)
	execute 'setlocal' a:option_name.'!'
	execute 'setlocal' a:option_name.'?'
endfunction
" ]]]
"      切换变量开关 [[[3
function! ToggleVariable(variable_name)
	if eval(a:variable_name)
		execute 'let' a:variable_name.' = 0'
	else
		execute 'let' a:variable_name.' = 1'
	endif
	echo printf('%s = %s', a:variable_name, eval(a:variable_name))
endfunction
" ]]]
" ]]]
"    (以下取自 https://github.com/terryma/dotfiles ) [[[2
"      调整 Quickfix 窗口高度 [[[3
function! AdjustWindowHeight(minheight, maxheight)
	execute max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" ]]]
" ]]]
"    (以下取自 http://wyw.dcweb.cn/vim/_vimrc.html ) [[[2
"      设置文件编码 [[[3
function! s:SetFileEncodings(encodings)
	let b:myfileencodingsbak=&fileencodings
	let &fileencodings=a:encodings
endfunction
" ]]]
"      还原文件编码 [[[3
function! s:RestoreFileEncodings()
	let &fileencodings=b:myfileencodingsbak
	unlet b:myfileencodingsbak
endfunction
" ]]]
" ]]]
"    自己原创修改 [[[2
"      编译单个源文件 [[[3
function! Do_OneFileMake()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg
					\| echo "Fail to make! This file is not in the current directory!"
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
		if s:isWindows==1
			setlocal makeprg=gcc\ -Wall\ -Wconversion\ -o\ %<.exe\ %
		else
			setlocal makeprg=gcc\ -Wall\ -Wconversion\ -o\ %<\ %
		endif
	elseif &filetype=="cpp"
		if s:isWindows==1
			setlocal makeprg=g++\ -o\ %<.exe\ %
		else
			setlocal makeprg=g++\ -o\ %<\ %
		endif
	" elseif &filetype=="cs"
		" setlocal makeprg=csc\ \/nologo\ \/out:%<.exe\ %
	endif
	if(s:isWindows==1)
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'.exe','g')
		let toexename=outfilename
	else
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\)' ,'','g')
		let toexename=outfilename
	endif
	if filereadable(outfilename)
		if(s:isWindows==1)
			let outdeletedsuccess=delete(getcwd()."\\".outfilename)
		else
			let outdeletedsuccess=delete("./".outfilename)
		endif
		if(outdeletedsuccess!=0)
			setlocal makeprg=make
			echohl WarningMsg
						\| echo "Fail to make! I cannot delete the ".outfilename
						\| echohl None
			return
		endif
	endif
	" Use Dispatch Make
	execute "Make"
	setlocal makeprg=make
	if getqflist() == [] "compile successfully and no warning
		let l:flag = 0
		silent execute "cclose"
		execute "normal :"
		if filereadable(outfilename)
			if(s:isWindows==1)
				execute "!".toexename
			else
				execute "!./".toexename
			endif
		endif
	else
		for l:inx in getqflist()
			for l:val in values(l:inx)
				if l:val =~ 'error'
					let l:flag = 1
					break
				elseif l:val =~ 'warning'
					let l:flag = 2
				else
					let l:flag = 0
				endif
			endfor
			if l:val =~ 'error'
				break
			endif
		endfor
	endif
	if l:flag == 1
		" Use Dispatch Copen
		execute "Copen"
	elseif l:flag == 2
		let l:select = input('There are warnings! [r]un or [s]olve? ')
		if l:select == 'r'
			execute "normal :"
			if filereadable(outfilename)
				if(s:isWindows==1)
					execute "!".toexename
				else
					execute "!./".toexename
				endif
			endif
			execute "cwindow"
		elseif l:select == 's'
			" Use Dispatch Copen
			execute "Copen"
		else
			echohl WarningMsg
						\| echo "Input error!"
						\| echohl None
		endif
	else
		execute "cwindow"
	endif
endfunction
" ]]]
"      执行 make 的设置 [[[3
function! Do_make()
	setlocal makeprg=make
	" Use Dispatch Make
	execute "Make"
	execute "cwindow"
endfunction
" ]]]
"      关闭窗口或卸载缓冲区 [[[3
function! CloseWindowOrKillBuffer()
	let number_of_windows_to_this_buffer =
				\ len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

	" never bdelete a nerd tree
	if matchstr(expand("%"), 'NERD') == 'NERD'
		wincmd c
		return
	endif

	" never bdelete a scratch buffer
	if (bufname('') =~# '\[Scratch]')
		ScratchClose
		return
	endif

	if number_of_windows_to_this_buffer > 1
		wincmd c
	else
		bdelete
	endif
endfunction
" ]]]
"      切换左右缓冲区 [[[3
function! SwitchBuffer(direction)
	if a:direction == 0
		if bufnr("%") == 2
			exe "buffer ".bufnr("$")
		else
			bprev
		endif
	else
		if bufnr("%") == bufnr("$")
			buffer2
		else
			bnext
		endif
	endif
endfunction
" ]]]
" ]]]
" ]]]
"  NeoBundle.vim 插件管理器 [[[1
"    运行路径添加 NeoBundle 目录 [[[2
if has('vim_starting')
	set runtimepath+=$VIMFILES/bundle/neobundle.vim/
endif
" ]]]
"    开始配置 NeoBundle [[[2
call neobundle#begin(expand("$VIMFILES/bundle"))
" set shellquote="\""
" set shellxquote="\""
" set noshellslash
" ]]]
	"  载入 NeoBundle 缓存或配置 NeoBundle [[[2
if neobundle#load_cache()
	"  使 NeoBundle 管理 NeoBundle [[[3
	" required!
	NeoBundleFetch 'Shougo/neobundle.vim'
	" ]]]
	"  初始化插件组设置 [[[3
	let s:plugin_groups = []
	call add(s:plugin_groups, 'core')
	call add(s:plugin_groups, 'autocomplete')
	call add(s:plugin_groups, 'editing')
	call add(s:plugin_groups, 'lint')
	if !s:isWindows
		call add(s:plugin_groups, 'linux')
		" FIXME Windows 下的 GitGutter 似乎有点问题
		call add(s:plugin_groups, 'scm')
		if s:isTmux
			call add(s:plugin_groups, 'tmux')
		endif
	else
		call add(s:plugin_groups, 'windows')
	endif
	call add(s:plugin_groups, 'misc')
	call add(s:plugin_groups, 'navigation')
	call add(s:plugin_groups, 'unite')
	" 仅在非生产环境下载入开发插件
	if !s:isServer
		call add(s:plugin_groups, 'indent')
		call add(s:plugin_groups, 'javascript')
		if s:hasLua
			call add(s:plugin_groups, 'lua')
		endif
		call add(s:plugin_groups, 'php')
		call add(s:plugin_groups, 'web')
	endif
	" ]]]
	" My bundles here:
	"  核心 [[[3
	if count(s:plugin_groups, 'core')
		if !s:isServer
			" vim-airline 是更轻巧的 vim-powerline 代替品
			NeoBundle 'vim-airline/vim-airline'
			NeoBundle 'vim-airline/vim-airline-themes'
		endif
		" MatchIt -- 扩展%的匹配功能，对%命令进行扩展使得能在嵌套标签和语句之间跳转
		NeoBundleLazy 'git@github.com:Firef0x/matchit.git',
					\ {'autoload':{'mappings':[
					\ ['nxo', '%', 'g%', '[%', ']%']
					\ ]}}
		NeoBundle 'Shougo/vimproc.vim',
					\ {'build' : {
					\     'windows' : 'tools\\update-dll-mingw',
					\     'cygwin'  : 'make -f make_cygwin.mak',
					\     'mac'     : 'make -f make_mac.mak',
					\     'unix'    : 'make -f make_unix.mak',
					\    },
					\ }
		" Repeat -- 支持普通模式使用"."来重复执行一些插件的命令
		NeoBundle 'tpope/vim-repeat'
		" VisualRepeat -- 支持可视模式使用"."来重复执行一些插件的命令
		NeoBundle 'visualrepeat',
					\ {'depends':'ingo-library'}
		" 包含普遍使用的 Vim 的通用配置
		NeoBundle 'tpope/vim-sensible'
		" Surround -- 快速添加、替换、清除包围符号、标签
		" 在 Visual Mode 内原来的 s 与 S（substitute）命令便不再有效
		NeoBundle 'tpope/vim-surround'
		NeoBundle 'tpope/vim-dispatch'
	endif
	" ]]]
	"  自动完成 [[[3
	if count(s:plugin_groups, 'autocomplete')
		" 解决插入模式下自动补全会定住的问题
		" 以下取自 https://github.com/bling/dotvim/pull/30
		NeoBundle 'Konfekt/FastFold'
		if s:autocomplete_method == 'neocomplcache'
			NeoBundleLazy 'Shougo/neocomplcache.vim',
						\ {'autoload':{'insert':1}}
		elseif s:autocomplete_method == 'neocomplete'
			NeoBundleLazy 'Shougo/neocomplete.vim',
						\ {'autoload':{
						\ 'depends':'Shougo/context_filetype.vim',
						\ 'insert':1},
						\ 'vim_version':'7.3.885'}
		endif
		NeoBundleLazy 'Shougo/neosnippet.vim',
					\ {'autoload':{
					\ 'insert':1,
					\ 'filetypes':'snippet',
					\ 'unite_sources':['neosnippet/runtime',
					\ 'neosnippet/user',
					\ 'snippet']},
					\ 'depends': ['Shougo/context_filetype.vim',
					\ 'Shougo/neosnippet-snippets']}
		NeoBundle 'honza/vim-snippets'
		" React 特定的代码片段
		NeoBundle 'justinj/vim-react-snippets'
	endif
	" ]]]
	"  文本编辑 [[[3
	if count(s:plugin_groups, 'editing')
		" 比较指定文本块
		NeoBundleLazy 'AndrewRadev/linediff.vim',
					\ {'autoload':{'commands':[
					\ 'Linediff',
					\ 'LinediffReset'
					\ ]}}
		" 打散合并单行语句
		NeoBundleLazy 'AndrewRadev/splitjoin.vim',
					\ {'autoload':{'commands':[
					\ 'SplitjoinJoin',
					\ 'SplitjoinSplit'
					\ ]}}
		NeoBundle 'chrisbra/NrrwRgn'
		" 给各种 tags 标记不同的颜色，便于观看调试的插件
		NeoBundle 'dimasg/vim-mark'
		" tabular 比 Align 更简单，所以替换
		NeoBundleLazy 'godlygeek/tabular',
					\ {'autoload':{
					\ 'commands':[
					\ 'Tabularize',
					\ 'AddTabularPipeline'
					\ ]}}
		NeoBundleLazy 'gorkunov/smartpairs.vim',
					\ {'autoload':{
					\ 'commands':[
					\ 'SmartPairs',
					\ 'SmartPairsI',
					\ 'SmartPairsA'
					\ ],
					\ 'mappings':[
					\ ['n', 'viv', 'vav', 'civ', 'cav', 'div', 'dav', 'yiv', 'yav'],
					\ ['xv', 'v']
					\ ]}}
		" “盘古之白”中文排版自动规范化的 Vim 插件(弃用，副作用太大)
		" NeoBundleLazy 'hotoo/pangu.vim',
		" 			\ {'autoload':{
		" 			\ 'commands':[
		" 			\ 'Pangu',
		" 			\ 'PanguEnable',
		" 			\ 'PanguDisable'
		" 			\ ],
		" 			\ 'filetypes':[
		" 			\ 'markdown',
		" 			\ 'text'
		" 			\ ]}}
		NeoBundle 'jiangmiao/auto-pairs'
		" 自动更新 Last Modified 字符串
		NeoBundle 'jmcantrell/vim-lastmod'
		" TODO vim-sneak 是 vim-easymotion 的代替品，考虑是否替换
		" NeoBundle 'justinmk/vim-sneak'
		NeoBundleLazy 'kana/vim-scratch',
					\ {'autoload':{
					\ 'commands':[
					\ 'ScratchClose',
					\ 'ScratchEvaluate',
					\ 'ScratchOpen'
					\ ]}}
		" rainbow 是 rainbow_parentheses.vim 的改进版，所以替换
		" NeoBundle 'kien/rainbow_parentheses.vim'
		" EasyMotion -- 移动命令增强插件
		NeoBundle 'Lokaltog/vim-easymotion'
		NeoBundle 'luochen1990/rainbow'
		" 连续按 j/k 时加速移动光标
		NeoBundle 'rhysd/accelerated-jk'
		NeoBundle 'rhysd/clever-f.vim'
		NeoBundle 'terryma/vim-multiple-cursors'
		" 在 Visual 模式下使用 */# 跳转
		NeoBundleLazy 'thinca/vim-visualstar',
					\ {'autoload':{'mappings':[
					\ ['xv', '*', '#', 'g*', 'g#']
					\ ]}}
		" tcomment_vim 比 nerdcommenter 更智能，所以替换
		" NeoBundle 'scrooloose/nerdcommenter'
		NeoBundleLazy 'tomtom/tcomment_vim',
					\ {'autoload':{'mappings':[
					\ ['nx', 'gc', 'gcc', 'gC']
					\ ]}}
	endif
	" ]]]
	"  代码缩进 [[[3
	if count(s:plugin_groups, 'indent')
		" vim-indent-guides -- 显示缩进线
		NeoBundle 'nathanaelkane/vim-indent-guides'
	endif
	" ]]]
	"  JavaScript [[[3
	if count(s:plugin_groups, 'javascript')
		" 以下3个插件以 vim-javascript 和 javascript-libraries-syntax.vim 取代
		" NeoBundleLazy 'JavaScript-Indent',
		" 			\ { 'autoload' : {'filetypes':['javascript']} }
		" NeoBundleLazy 'jQuery',
		" 			\ { 'autoload' : {'filetypes':['javascript']} }
		" NeoBundleLazy 'jelera/vim-javascript-syntax',
		" 			\ {'autoload':{'filetypes':['javascript']}}
		" Require.js 快速定位模块(似乎没有作用)
		" NeoBundleLazy 'nyanhan/requirejs.vim',
		" 			\ {'autoload':{
		" 			\ 'filetypes':[
		" 			\ 'javascript'
		" 			\ ]}}
		NeoBundleLazy 'ohle/underscore-templates.vim',
					\ {'autoload':{
					\ 'filetypes':[
					\ 'underscore_template'
					\ ]}}
		NeoBundleLazy 'mustache/vim-mustache-handlebars',
					\ {'autoload':{
					\ 'filetypes':[
					\ 'mustache',
					\ 'handlebars'
					\ ]}}
		NeoBundleLazy 'mxw/vim-jsx',
					\ {'autoload':{'filetypes':['javascript.jsx']}}
		NeoBundleLazy 'pangloss/vim-javascript',
					\ {'autoload':{'filetypes':['javascript']}}
		NeoBundleLazy 'othree/javascript-libraries-syntax.vim',
					\ {'autoload':{
					\ 'filetypes':[
					\ 'javascript',
					\ 'coffee',
					\ 'ls',
					\ 'typescript'
					\ ]}}
		if s:hasNode
			NeoBundleLazy 'maksimr/vim-jsbeautify',
						\ {'autoload':{
						\ 'commands':[
						\ 'CSSBeautify',
						\ 'JsBeautify',
						\ 'HtmlBeautify'
						\ ],
						\ 'filetypes':[
						\ 'css',
						\ 'html',
						\ 'javascript',
						\ 'jinja',
						\ 'json',
						\ 'less',
						\ 'mustache'
						\ ]}}
			" JavaScript 自动补全引擎
			NeoBundleLazy 'ternjs/tern_for_vim',
						\ {'autoload':{
						\ 'commands':[
						\ 'TernDef',
						\ 'TernDoc',
						\ 'TernType',
						\ 'TernRefs',
						\ 'TernRename'
						\ ],
						\ 'filetypes':[
						\ 'javascript'
						\ ]},
						\ 'build':{
						\ 'cygwin'  : 'npm install',
						\ 'mac'     : 'npm install',
						\ 'unix'    : 'npm install',
						\ 'windows' : 'npm install',
						\ }}
		endif
	endif
	" ]]]
	"  代码检查 [[[3
	if count(s:plugin_groups, 'lint')
		" Syntastic -- 包含很多语言的语法与编码风格检查插件
		NeoBundle 'scrooloose/syntastic'
		NeoBundle 'syngan/vim-vimlint',
					\ {'depends':'ynkdir/vim-vimlparser'}
	endif
	" ]]]
	"  Linux [[[3
	if count(s:plugin_groups, 'linux')
		" 以 root 权限打开文件，以 SudoEdit.vim 代替 sudo.vim
		" 参见 http://vim.wikia.com/wiki/Su-write
		NeoBundle 'chrisbra/SudoEdit.vim'
		" 在终端下自动开启关闭 paste 选项
		NeoBundle 'ConradIrwin/vim-bracketed-paste'
		if s:hasPython && executable('fcitx')
			NeoBundle 'fcitx.vim'
		endif
	endif
	" ]]]
	"  Lua [[[3
	if count(s:plugin_groups, 'lua')
		" NeoBundleLazy 'luarefvim',
		" 			\ {'autoload':{'filetypes':['lua']}}
	endif
	" ]]]
	"  文本定位/纵览 [[[3
	if count(s:plugin_groups, 'navigation')
		if s:hasCTags
			" CTags 语法高亮
			NeoBundle 'bb:abudden/taghighlight'
			" C Call-Tree Explorer 源码浏览工具
			if s:hasCscope
				NeoBundleLazy 'hari-rangarajan/CCTree',
							\ {'autoload':{
							\ 'commands':[
							\ 'CCTreeLoadDB',
							\ 'CCTreeLoadXRefDBFromDisk'
							\ ]}}
			endif
			" Tagbar -- 提供单个源代码文件的函数列表之类的功能，强于 Taglist
			NeoBundleLazy 'majutsushi/tagbar',
						\ {'autoload':{'commands':[
						\ 'TagbarClose',
						\ 'TagbarToggle'
						\ ]}}
			" 增强源代码浏览
			NeoBundleLazy 'wesleyche/SrcExpl',
						\ {'autoload':{'commands':'SrcExplToggle'}}
		endif
		" 在同一文件名的.h与.c/.cpp之间切换
		NeoBundleLazy 'a.vim',
					\ {'autoload':{'filetypes':['c', 'cpp']}}
		" 对三路合并时的<<< >>> === 标记语法高亮
		NeoBundle 'ConflictDetection',
					\ {'depends':'ingo-library'}
		" 在三路合并时的<<< >>> === 代码块之间快速移动
		NeoBundle 'ConflictMotions',
					\ {'depends':['ingo-library','CountJump']}
		" 模糊检索文件, 缓冲区, 最近最多使用, 标签等的 Vim 插件
		" Unite 比 CtrlP 更强大，所以替换
		" NeoBundle 'ctrlpvim/ctrlp.vim'
		" 删除尾部多余空格
		NeoBundle 'DeleteTrailingWhitespace'
		NeoBundleLazy 'mbbill/undotree',
					\ {'autoload':{'commands':'UndotreeToggle'}}
		if s:hasAck || s:hasAg
			NeoBundle 'mileszs/ack.vim'
			" 在 NERDTree 中搜索目录
			NeoBundle 'tyok/nerdtree-ack',
						\ {'depends':['scrooloose/nerdtree','mileszs/ack.vim']}
		endif
		" NERDTree -- 树形的文件系统浏览器（替代 Netrw)，功能比 Vim 自带的 Netrw 强大
		NeoBundle 'scrooloose/nerdtree'
		" 显示尾部多余空格
		NeoBundle 'ShowTrailingWhitespace'
		NeoBundle 'Xuyuanp/nerdtree-git-plugin',
					\ {'depends':'scrooloose/nerdtree',
					\ 'external_command':'git'}
	endif
	" ]]]
	"  PHP [[[3
	if count(s:plugin_groups, 'php')
		NeoBundleLazy '2072/PHP-Indenting-for-VIm',
					\ {'autoload':{'filetypes':['php']}}
		" 高亮与光标下变量相同名字的变量
		NeoBundleLazy 'alexander-alzate/vawa.vim',
					\ {'autoload':{'filetypes':['php']}}
		NeoBundleLazy 'php_localvarcheck.vim',
					\ {'autoload':{'filetypes':['php']}}
		"press K on a function for full php manual
		NeoBundleLazy 'spf13/PIV',
					\ {'autoload':{'filetypes':['blade', 'php']}}
	endif
	" ]]]
	"  代码管理 [[[3
	if count(s:plugin_groups, 'scm')
		NeoBundle 'airblade/vim-gitgutter',
					\ {'autoload':{'insert':1},
					\ 'disabled':!has('signs'),
					\ 'external_command':'git'}
		NeoBundleLazy 'gregsexton/gitv',
					\ {'depends':['tpope/vim-fugitive'],
					\ 'autoload':{'commands':'Gitv'},
					\ 'external_command':'git'}
		NeoBundle 'tpope/vim-fugitive',
					\ {'augroup':'fugitive',
					\ 'commands':[
					\ 'Git',
					\ 'Gdiff',
					\ 'Gstatus',
					\ 'Gwrite',
					\ 'Gcd',
					\ 'Glcd',
					\ 'Ggrep',
					\ 'Glog',
					\ 'Gcommit',
					\ 'Gblame',
					\ 'Gbrowse'
					\ ],
					\ 'external_command':'git'}
	endif
	" ]]]
	"  TMux [[[3
	if count(s:plugin_groups, 'tmux')
		NeoBundle 'christoomey/vim-tmux-navigator'
	endif
	"  Unite 插件组 [[[3
	if count(s:plugin_groups, 'unite')
		" Unite -- 全能查找插件，查找文件、寄存器、缓冲区、MRU 等
		NeoBundleLazy 'Shougo/unite.vim',
					\ {'autoload':{
					\ 'commands':[{
					\ 'name':'Unite',
					\ 'complete':'customlist,unite#complete_source'
					\ }],
					\ 'depends':'Shougo/neomru.vim',
					\ }}
		NeoBundleLazy 'Shougo/neomru.vim',
					\ {'autoload':{
					\ 'filetypes':'all',
					\ 'on_source':'unite.vim'}}
		NeoBundleLazy 'Shougo/unite-help',
					\ {'autoload':{'on_source':'unite.vim'}}
		NeoBundleLazy 'Shougo/unite-outline',
					\ {'autoload':{'on_source':'unite.vim'}}
		NeoBundleLazy 'tsukkee/unite-tag',
					\ {'autoload':{'on_source':'unite.vim'}}
	endif
	" ]]]
	"  Web 开发 [[[3
	if count(s:plugin_groups, 'web')
		NeoBundleLazy 'amirh/HTML-AutoCloseTag',
					\ {'autoload':{'filetypes':['html', 'xml']}}
		NeoBundleLazy 'ap/vim-css-color',
					\ {'autoload':{'filetypes':[
					\ 'css',
					\ 'scss',
					\ 'sass',
					\ 'less'
					\ ]}}
		NeoBundleLazy 'ariutta/Css-Pretty',
					\ {'autoload':{
					\ 'commands':'Csspretty',
					\ 'filetypes':['css']
					\ }}
		NeoBundleLazy 'cakebaker/scss-syntax.vim',
					\ {'autoload':{'filetypes':[
					\ 'sass',
					\ 'scss'
					\ ]}}
		NeoBundleLazy 'evanmiller/nginx-vim-syntax',
					\ {'autoload':{'filetypes':['nginx']}}
		" 避免 CSS3 高亮问题
		NeoBundleLazy 'hail2u/vim-css3-syntax',
					\ {'autoload':{'filetypes':[
					\ 'css',
					\ 'sass',
					\ 'scss'
					\ ]}}
		NeoBundleLazy 'gregsexton/MatchTag',
					\ {'autoload':{'filetypes':[
					\ 'html',
					\ 'javascript.jsx',
					\ 'xml',
					\ 'xsl'
					\ ]}}
		" Emmet -- 用于快速编辑 HTML 文件
		NeoBundleLazy 'mattn/emmet-vim',
					\ {'autoload':{'filetypes':[
					\ 'css',
					\ 'handlebars',
					\ 'html',
					\ 'less',
					\ 'mustache',
					\ 'sass',
					\ 'scss',
					\ 'xml',
					\ 'xsd',
					\ 'xsl',
					\ 'xslt'
					\ ]}}
		NeoBundleLazy 'othree/html5.vim',
					\ {'autoload':{'filetypes':['html']}}
		NeoBundleLazy 'othree/html5-syntax.vim',
					\ {'autoload':{'filetypes':['html']}}
		NeoBundleLazy 'othree/xml.vim',
					\ {'autoload':{'filetypes':['html', 'xml']}}
	endif
	"  Windows [[[3
	if count(s:plugin_groups, 'windows') && s:hasCscope && s:hasCscopeExe
		" NeoBundle 'cscope-wrapper'
	endif
	" ]]]
	"  杂项 [[[3
	if count(s:plugin_groups, 'misc')
		" Vim 中文文档计划
		NeoBundle 'asins/vimcdoc'
		" 在单独的窗口管理缓冲区
		NeoBundle 'jlanzarotta/bufexplorer'
		" colorizer -- 提供实时显示颜色的功能
		NeoBundle 'lilydjwg/colorizer'
		" 自动识别并设定文件编码
		NeoBundle 'mbbill/fencview'
		if !s:isServer
			NeoBundle 'mhinz/vim-startify'
			" ConqueTerm -- 提供在 Vim 中打开终端的功能，Windows 下应有 PowerShell 支持
			" 使用 VimShell 暂时取代
			" NeoBundle 'scottmcginness/Conque-Shell'
			" VimShell -- Vim 中运行终端，使用该插件必须设置 set noautochdir
			NeoBundleLazy 'Shougo/vimshell.vim',
						\ {'autoload':{'commands':[
						\ {'name':'VimShell',
						\ 'complete':'customlist,vimshell#complete'},
						\ 'VimShellExecute',
						\ 'VimShellInteractive',
						\ 'VimShellTerminal',
						\ 'VimShellPop'
						\ ],
						\ 'explorer':1,
						\ 'mappings':['<Plug>(vimshell_']
						\ }}
		endif

		"  语法相关插件 [[[4
		NeoBundleLazy 'dogrover/vim-pentadactyl',
					\ {'autoload':{'filetypes':['pentadactyl']}}
		NeoBundleLazy 'git@github.com:Firef0x/PKGBUILD.vim.git',
					\ {'autoload':{'filetypes':['PKGBUILD']}}
		NeoBundleLazy 'git@github.com:Firef0x/vim-smali.git',
					\ {'autoload':{'filetypes':['smali']}}
		NeoBundleLazy 'openvpn',
					\ {'autoload':{'filetypes':['openvpn']}}
		" Ansible Playbook 语法高亮
		NeoBundleLazy 'pearofducks/ansible-vim',
					\ {'autoload':{
					\ 'filetypes':[
					\ 'ansible',
					\ 'ansible_hosts',
					\ 'ansible_template'
					\ ]}}
		" PO (Portable Object, gettext)
		NeoBundleLazy 'po.vim--gray',
					\ {'autoload':{'filetypes':['po']}}
		NeoBundleLazy 'robbles/logstash.vim',
					\ {'autoload':{'filetypes':['logstash']}}
		" STL 语法高亮
		NeoBundleLazy 'STL-improved',
					\ {'autoload':{'filetypes':['c', 'cpp']}}
		NeoBundleLazy 'superbrothers/vim-vimperator',
					\ {'autoload':{'filetypes':['vimperator']}}
		" 0xBADDCAFE 的版本相比原版去除了单下划线的语法错误提示及折叠，符合
		" GitHub 口味的 Markdown 语法
		" NeoBundleLazy 'tpope/vim-markdown',
		NeoBundleLazy '0xBADDCAFE/vim-markdown',
					\ {'autoload':{'filetypes':[
					\ 'markdown'
					\ ]}}
		" ]]]

		"  主题及配色 [[[4
		NeoBundle 'crusoexia/vim-monokai'
		" NeoBundle 'tomasr/molokai'
		" ]]]

		"  其它从 vim-scripts 仓库中安装的脚本 [[[4
		" 保存时自动创建空文件夹
		NeoBundle 'auto_mkdir'
		" 重命名当前文件
		NeoBundle 'Rename'
		" VisIncr -- 给 Vim 增加生成递增或者递减数列的功能
		" 支持十进制,十六进制,日期,星期等,功能强大灵活
		NeoBundle 'VisIncr'
		" ]]]
	endif
	" ]]]
	"  保存 NeoBundle 缓存 [[[3
	NeoBundleSaveCache
	" ]]]
endif
	" ]]]
"    运行路径添加 bundle 目录 [[[2
NeoBundleLocal $VIMFILES/bundle
" ]]]
"    结束配置 NeoBundle [[[2
call neobundle#end()
" ]]]
"    针对不同的文件类型加载对应的插件 [[[2
filetype plugin indent on     " required!
" ]]]
"    NeoBundle 插件安装检查 [[[2
if !has('vim_starting')
	NeoBundleCheck
endif
" ]]]
"    NeoBundle 帮助 [[[2
" non github repos
" NeoBundle 'git://git.wincent.com/command-t.git'
" ...

" brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleSearch(!) foo - search(or refresh cache first) for foo
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h neobundle for more details or wiki for faq
" note: comments after bundle command are not allowed..
" ]]]
" ]]]
"  以下为自己的自定义设置 [[[1
"    以下设置在 Vim 全屏运行时 source vimrc 的时候不能再执行 [[[2
"  否则会退出全屏
if !exists('g:VimrcIsLoad')
	"  设置语言编码 [[[3
	set langmenu=zh_CN.UTF-8
	let $LANG='zh_CN.UTF-8'
	" 显示中文帮助
	set helplang=cn
	if s:isWindows && has("multi_byte")
		set termencoding=cp850
	else
		set termencoding=utf-8
	endif
	set fileencodings=utf-8,chinese,taiwan,ucs-2,ucs-2le,ucs-bom,latin1,gbk,gb18030,big5,utf-16le,cp1252,iso-8859-15
	set encoding=utf-8
	set fileencoding=utf-8
	" ]]]
	"  解决菜单乱码 [[[3
	if s:isWindows && s:isGUI
		source $VIMRUNTIME/delmenu.vim
		source $VIMRUNTIME/menu.vim
		" 解决console输出乱码
		language messages zh_CN.UTF-8
	endif
	" ]]]
	"  设置图形界面选项  [[[3
	if s:isGUI
		set shortmess=atI  " 启动的时候不显示那个援助乌干达儿童的提示
		" set guioptions=   "无菜单、工具栏
		set guioptions+=t  "分离式菜单
		set guioptions-=T  "不显示工具栏
		if s:isWindows
			autocmd MyAutoCmd GUIEnter * simalt ~x    " 在Windows下启动时最大化窗口
			if has('directx')
				set renderoptions=type:directx
			endif
		endif
		set guitablabel=%N\ \ %t\ %M   "标签页上显示序号
	endif
	" ]]]
endif
" ]]]
"    设置更多图形界面选项  [[[2
" 执行宏、寄存器和其它不通过输入的命令时屏幕不会重画(提高性能)
set lazyredraw
" Change the terminal's title
set title
" Avoid command-line redraw on every entered character by turning off Arabic
" shaping (which is implemented poorly).
if has('arabic')
	set noarabicshape
endif
" ]]]
"    图形与终端  [[[2
"  以下设置在 Vim 全屏运行时 source vimrc 的时候不能再执行
"  否则会退出全屏
if !exists('g:VimrcIsLoad')
	" 设置字体  [[[3
	" 设置显示字体和大小。guifontwide 为等宽汉字字体。(干扰 Airline，暂不设置)
	if s:isWindows
		" set guifont=Consolas\ for\ Powerline\ FixedD:h12
		" 雅黑 Consolas Powerline 混合字体
		" 该字体取自 https://github.com/Jackson-soft/Vim/tree/master/user_fonts
		set guifont=YaHei_Consolas_Hybrid:h12
	elseif (s:isGUI && s:isMac)
		set guifont=Inconsolata\ for\ Powerline:h15
	elseif (s:isGUI || s:isColor)
		set guifont=Inconsolata\ for\ Powerline\ Medium\ 12
		" set guifontwide=WenQuanYi\ ZenHei\ Mono\ 12
	else
		set guifont=Monospace\ 12
	endif
	" ]]]
	" 设置配色方案  [[[3
	" let colorscheme = 'molokai'
	let colorscheme = 'monokai'
	" (以下取自 https://github.com/lilydjwg/dotvim )
	if s:isGUI
		" 有些终端不能改变大小
		set columns=88
		set lines=32
		set number
		set cursorline
		" 原为double，为了更好地显示airline，改为single
		set ambiwidth=single
		exe 'colorscheme' colorscheme
	elseif has("unix")
		" 原为double，为了更好地显示airline，改为single
		set ambiwidth=single
		"开启molokai终端256色配色
		" let g:rehash256=1
		" 防止退出时终端乱码
		" 这里两者都需要。只前者标题会重复，只后者会乱码
		set t_fs=(B
		set t_IE=(B
		if s:isColor
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
			endif
		endif
		" 在不同模式下使用不同颜色的光标
		" 不要在 ssh 下使用
		if s:isColor && !exists('$SSH_TTY')
			let color_normal = 'HotPink'
			let color_insert = 'RoyalBlue1'
			let color_exit = 'green'
			if &term =~ 'xterm\|rxvt'
				exe 'silent !echo -ne "\e]12;"' . shellescape(color_normal, 1) . '"\007"'
				let &t_SI="\e]12;" . color_insert . "\007"
				let &t_EI="\e]12;" . color_normal . "\007"
				exe 'autocmd VimLeave * :silent !echo -ne "\e]12;"' . shellescape(color_exit, 1) . '"\007"'
			elseif &term =~ "screen"
				if s:isTmux
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
	elseif has('win32') && exists('$CONEMUBUILD')
		" 在 Windows 的 ConEmu 终端下开启256色
		set term=xterm
		set t_Co=256
		let &t_AB="\e[48;5;%dm"
		let &t_AF="\e[38;5;%dm"
		set cursorline
		exe 'colorscheme' colorscheme
	endif
	unlet colorscheme
	" ]]]
endif
"]]]
"    关闭错误声音 [[[2
" 去掉输入错误的提示声音
set noerrorbells
" 不要闪烁
set visualbell t_vb=
" ]]]
"    设置文字编辑选项 [[[2
set background=dark "背景使用黑色，开启molokai终端配色必须指令
set confirm " 在处理未保存或只读文件的时候，弹出确认
set noexpandtab  "键入Tab时不转换成空格
set nowrap "不自动换行
set shiftwidth=4  " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4  " 设置按BackSpace的时候可以一次删除掉4个空格
set tabstop=4 "tab = 4 spaces
" [Disabled]自动切换当前目录为当前文件所在的目录(与 Fugitive 冲突，因而禁用)
" set autochdir
" 搜索时忽略大小写，但在有一个或以上大写字母时仍大小写敏感
set ignorecase
set smartcase
set nobackup " 覆盖文件时不备份
set nowritebackup "文件保存后取消备份
set noswapfile  "取消交换区
set mousehide  " 键入时隐藏鼠标
set magic " 设置模式的魔术
set sessionoptions=blank,buffers,curdir,folds,slash,tabpages,unix,winsize
set viminfo=%,'1000,<50,s20,h,n$VIMFILES/viminfo
" 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
set hidden
" 保证缓存目录存在
call EnsureExists(s:cache_dir)
" 将撤销树保存到文件
if has('persistent_undo')
	set undofile
	let &undodir = s:get_cache_dir("undo")
	" 保证撤销缓存目录存在
	call EnsureExists(&undodir)
endif
" 设置光标之下的最少行数(暂时使用 vim-sensible 中的设置，不在此处设置)
" set scrolloff=3
" 将命令输出重定向到文件的字符串不要包含标准错误
set shellredir=>
" 使用管道
set noshelltemp
"      显示部分 list 模式下的特殊字符 [[[3
" 不在 Windows 和 Mac 下使用 Unicode 符号
" 参见 https://github.com/tpope/vim-sensible/issues/44
" 和   https://github.com/tpope/vim-sensible/issues/57
if !s:isWindows && !s:isMac && s:isGUI
	set list
	" set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
	let &listchars="tab:\u25b8 ,extends:\u276f,precedes:\u276e,nbsp:\u2423"
	set showbreak=↪
endif
" ]]]
" ]]]
"    设置加密选项 [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
try
	" Vim 7.4.399+
	set cryptmethod=blowfish2
catch /.*/
	" Vim 7.3+
	try
		set cryptmethod=blowfish
	catch /.*/
		" Vim 7.2-, neovim
	endtry
endtry
" ]]]
"    开启 Wild 菜单 [[[2
" Command <Tab> completion, list matches, then longest common part, then all.
set wildmode=list:longest,full
"      Tab 键的自动完成忽略这些，影响代码提示 [[[3
" Ignore compiled files
set wildignore=*.o,*.obj,*~,*.class
" Ignore Python compiled files
set wildignore+=*.pyc,*.pyo,*/__pycache__/**,*.egginfo/**
" Ignore Ruby gem
set wildignore+=*.gem
" Ignore temp folder
set wildignore+=**/tmp/**
" Ignore Node.js modules
set wildignore+=*/node_modules/**
" Ignore image file
set wildignore+=*.png,*.jpg,*.gif,*.xpm,*.tiff
" 不应该忽略.git，因为会破坏 Fugitive 的功能
" 参见 https://github.com/tpope/vim-fugitive/issues/121
set wildignore+=*.so,*.swp,*.lock,*.db,*.zip,*/.Trash/**,*.pdf,*.xz,*.DS_Store,*/.sass-cache/**
" ]]]
" 光标移到行尾时，自动换下一行开头 Backspace and cursor keys wrap too
set whichwrap=b,s,h,l,<,>,[,]
" ]]]
"    设置代码相关选项 [[[2
" ( autoindent 使用 vim-sensible 中的设置，不在此处设置)
" 打开自动 C 程序缩进
set cindent
" 智能自动缩进
set smartindent
" 设定命令行的行数为 1
set cmdheight=1
" 显示括号配对情况
set showmatch
set tags+=$VIMFILES/tags/cpp/stl.tags  " 增加C++ STL Tags
set tags+=$VIMFILES/tags/perl/cpan.tags  " 增加Perl CPAN Tags
source $VIMRUNTIME/ftplugin/man.vim
" ]]]
"    设置自动排版选项 [[[2
" 'formatoptions' 控制 Vim 如何对文本进行排版
" r 在插入模式按回车时，自动插入当前注释前导符。
" o 在普通模式按 'o' 或者 'O' 时，自动插入当前注释前导符。
" 2 在对文本排版时，将段落第二行而非第一行的缩进距离应用到其后的行上。
" m 可以在任何值高于 255 的多字节字符上分行。这对亚洲文本尤其有用，因为每
"   个字符都是单独的单位。
" B 在连接行时，不要在两个多字节字符之间插入空格。
" 1 不要在单字母单词后分行。如有可能，在它之前分行。
" j 在合适的场合，连接行时删除注释前导符。
" (使用 vim-sensible 中的设置，不在此处设置)
set formatoptions+=ro2mB1
" t 使用 'textwidth' 自动回绕文本
set formatoptions-=t
" ]]]
"    自动关联系统剪贴板(即+、*寄存器) [[[2
if has('clipboard')
	if s:isTmux
		set clipboard=
	elseif has ('unnamedplus')
		" When possible use + register for copy-paste
		set clipboard=unnamedplus
	else
		" On Mac and Windows, use * register for copy-paste
		set clipboard=unnamed
	endif
endif
" ]]]
"    设置语法折叠 [[[2
" 允许折叠
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
"    Ack/Ag 程序参数及输出格式选项 [[[2
if s:hasAg
	set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ --ignore\ '.hg'\ --ignore\ '.svn'\ --ignore\ '.git'\ --ignore\ '.bzr'
	set grepformat=%f:%l:%c:%m
elseif s:hasAck
	set grepprg=ack\ --nogroup\ --column\ --smart-case\ --no-color\ --follow\ $*
	set grepformat=%f:%l:%c:%m
endif
" ]]]
" ]]]
"  以下为插件的设置 [[[1
"    2html.vim [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
" 使用 XHTML 格式
let use_xhtml = 1
" ]]]
"    Ack.vim [[[2
" Ag 比 Ack 速度要快
if s:hasAg && neobundle#tap('ack.vim')
	let g:ackprg = "ag --nogroup --column --hidden --smart-case --nocolor --follow"
	call neobundle#untap()
endif
" ]]]
"    Auto-Pairs [[[2
" System Shortcuts:
"        <CR>  : Insert new indented line after return if cursor in blank brackets or quotes.
"        <BS>  : Delete brackets in pair
"        <M-p> : Toggle Autopairs (g:AutoPairsShortcutToggle)
"        <M-e> : Fast Wrap (g:AutoPairsShortcutFastWrap)
"        <M-n> : Jump to next closed pair (g:AutoPairsShortcutJump)
"        <M-b> : BackInsert (g:AutoPairsShortcutBackInsert)

" Fly Mode
" --------
" Fly Mode will always force closed-pair jumping instead of inserting.
" only for ")", "}", "]"

" If jumps in mistake, could use AutoPairsBackInsert(Default Key: `<M-b>`)
" to jump back and insert closed pair.

" the most situation maybe want to insert single closed pair in the string, eg ")"

" Fly Mode is DISABLED by default.

" add **let g:AutoPairsFlyMode = 1** .vimrc to turn it on

" Default Options:

"     let g:AutoPairsFlyMode = 0
"     let g:AutoPairsShortcutBackInsert = '<M-b>'
" if neobundle#tap('auto-pairs')
" 	let g:AutoPairsFlyMode = 1
" 	call neobundle#untap()
" endif
" ]]]
"    BufExplorer [[[2
" 快速轻松的在缓存中切换（相当于另一种多个文件间的切换方式）
if neobundle#tap('bufexplorer')
	let g:bufExplorerDefaultHelp = 0  " 不显示默认帮助信息
	let g:bufExplorerFindActive = 0
	let g:bufExplorerSortBy = 'mru' " 使用最近使用的排列方式
	autocmd MyAutoCmd BufWinEnter \[Buf\ List\] setlocal nonumber
	call neobundle#untap()
endif
" ]]]
"    CCTree.Vim C Call-Tree Explorer 源码浏览工具 关系树 (赞) [[[2
" (以下取自 http://blog.csdn.net/qrsforever/article/details/6365651 )
"1. 除了cscope ctags 程序的安装,还需安装强力胶 ccglue(ctags-cscope glue):
" http://sourceforge.net/projects/ccglue/files/src/
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
if neobundle#tap('CCTree')
	" 当设置为垂直显示时, 模式为3最合适. (1-minimum width, 2-little space, 3-wide)
	let g:CCTreeDisplayMode = 2
	let g:CCTreeUseUTF8Symbols = 1 "为了在终端模式下显示符号
	let g:CCTreeWindowMinWidth = 40 " 最小窗口
	let g:CCTreeWindowVertical = 1 " 水平分割,垂直显示
	call neobundle#untap()
endif
"4. 使用
"1) 将鼠标移动到要解析的函数上面ctrl+\组合键后，按>键，就可以看到该函数调用的函数的结果
"2) 将鼠标移动到要解析的函数上面ctrl+\组合键后，按<键，就可以看到调用该函数的函数的结果
" ]]]
"    cscope-wrapper [[[2
if s:isWindows && s:hasCscope && s:hasCscopeExe && executable('cswrapper')
	set csprg=cswrapper.exe
endif
" ]]]
"    [Disabled]CtrlP [[[2
" let g:ctrlp_working_path_mode = 'ra'
" " r -- the nearest ancestor that contains one of these directories or files:
" " `.git/` `.hg/` `.svn/` `.bzr/` `_darcs/`
" let g:ctrlp_follow_symlinks = 1

" 设置缓存目录
" let g:ctrlp_cache_dir = s:get_cache_dir("ctrlp")
" let g:ctrlp_custom_ignore = {
"     \ 'dir' : '\v[\/](\.bzr|\.git|\.hg|\.idea|\.rvm|\.sass-cache|\.svn|node_modules)$',
"     \ 'file': '\v\.(dll|exe|o|pyc|pyo|so|DS_Store)$' }

" let g:ctrlp_user_command = {
"     \ 'types': {
"         \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
"         \ 2: ['.hg', 'hg --cwd %s locate -I .'],
"     \ },
"     \ 'fallback': 'find %s -type f'
" \ }
" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'mixed']

" ]]]
"    DeleteTrailingWhitespace 删除尾部多余空格 [[[2
if neobundle#tap('DeleteTrailingWhitespace')
	" Turn off the automatic deletion of trailing whitespace
	let g:DeleteTrailingWhitespace = 0
	call neobundle#untap()
endif
" ]]]
"    dictfile.vim 自动设置 'dict' 选项 [[[2
"  设置词典目录
" (以下取自 https://github.com/bling/dotvim )
let g:dictfilePrefix = $VIMFILES . "/dict/"
" ]]]
"  EasyMotion [[[2
if neobundle#tap('vim-easymotion')
	let EasyMotion_leader_key = '<Leader><Leader>'
	let EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
	augroup MyAutoCmd
		autocmd ColorScheme * highlight EasyMotionTarget ctermfg=32 guifg=#0087df
		autocmd ColorScheme * highlight EasyMotionShade ctermfg=237 guifg=#3a3a3a
	augroup END
	call neobundle#untap()
endif
" ]]]
"    Emmet [[[2
if neobundle#tap('emmet-vim')
	function! neobundle#hooks.on_source(bundle)
		let g:use_emmet_complete_tag = 1
		let g:user_emmet_mode = 'a'
		let g:user_emmet_settings = {'lang': "zh-cn"}
	endfunction
	call neobundle#untap()
endif
" ]]]
"    FastFold 自动折叠代码 [[[2
if neobundle#tap('FastFold')
	let g:fastfold_savehook = 1
	let g:fastfold_fold_command_suffixes = []
endif
" ]]]
"    Fugitive Vim 内快捷 Git 命令操作 [[[2
if neobundle#tap('vim-fugitive')
	autocmd MyAutoCmd BufReadPost fugitive://* setlocal bufhidden=delete
	call neobundle#untap()
endif
" ]]]
"    GitGutter 在行数的前面显示当前文件相对于 Git HEAD 增改删行 [[[2
if neobundle#tap('vim-gitgutter')
	" SignColumn should match background for
	" things like vim-gitgutter
	highlight clear SignColumn
	" Current line number row will have same background color in relative mode.
	" Things like vim-gitgutter will match LineNr highlight
	highlight clear LineNr
	let g:gitgutter_realtime = 0
	call neobundle#untap()
endif
" ]]]
"    indent/html.vim [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
let g:html_indent_inctags = "html,body,head,tbody,p,li,dd,marquee,header,nav,article,section"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
" ]]]
"    Linediff [[[2
if neobundle#tap('linediff.vim')
	function! neobundle#hooks.on_source(bundle)
		let g:linediff_buffer_type = 'scratch'
	endfunction
	call neobundle#untap()
endif
"    mark.vim 给各种 tags 标记不同的颜色，便于观看调试的插件。 [[[2
" (以下取自 http://easwy.com/blog/archives/advanced-vim-skills-syntax-on-colorscheme/ )
" 当我输入“,hl”时，就会把光标下的单词高亮，在此单词上按“,hh”会清除该单词的高亮。
" 如果在高亮单词外输入“,hh”，会清除所有的高亮。
" 你也可以使用virsual模式选中一段文本，然后按“,hl”，会高亮你所选中的文本；或者
" 你可以用“,hx”来输入一个正则表达式，这会高亮所有符合这个正则表达式的文本。
"
" 你可以在高亮文本上使用“,#”或“,*”来上下搜索高亮文本。在使用了“,#”或“,*”后，就
" 可以直接输入“#”或“*”来继续查找该高亮文本，直到你又用“#”或“*”查找了其它文本。
" <Leader>* 当前MarkWord的下一个     <Leader># 当前MarkWord的上一个
" <Leader>/ 所有MarkWords的下一个    <Leader>? 所有MarkWords的上一个
"
" 如果你在启动vim后重新执行了colorscheme命令，或者载入了会话文件，那么mark插件
" 的颜色就会被清掉，解决的办法是重新source一下mark插件。或者像我一样，把mark插
" 件定义的highlight组加入到你自己的colorscheme文件中。
if neobundle#tap('vim-mark')
	"  默认高亮配色 [[[3
	augroup MyAutoCmd
		autocmd ColorScheme * highlight def MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
		autocmd ColorScheme * highlight def MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
		autocmd ColorScheme * highlight def MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
		autocmd ColorScheme * highlight def MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
		autocmd ColorScheme * highlight def MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
		autocmd ColorScheme * highlight def MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black
	augroup END
	" ]]]
	call neobundle#untap()
endif
" ]]]
"    MatchIt 对%命令进行扩展使得能在嵌套标签和语句之间跳转 [[[2
if neobundle#tap('matchit')
	" (以下取自 https://github.com/Shougo/neobundle.vim/issues/153 )
	function! neobundle#hooks.on_post_source(bundle)
		silent! execute 'doautocmd FileType' &filetype
	endfunction
	call neobundle#untap()
endif
" ]]]
"    自动完成插件 [[[2
if s:autocomplete_method == 'neocomplcache'
	"  NeoComplcache [[[3
	if neobundle#tap('neocomplcache.vim')
		" Disable AutoComplPop.
		let g:acp_enableAtStartup = 0
		" Use neocomplcachd.
		let g:neocomplcache_enable_at_startup = 1
		function! neobundle#hooks.on_source(bundle)
			"  设置选项 [[[4
			" Use smartcase.
			let g:neocomplcache_enable_smart_case = 1
			" Use camel case completion.
			let g:neocomplcache_enable_camel_case_completion = 1
			" Use underbar completion.
			let g:neocomplcache_enable_underbar_completion = 1
			" 设置缓存目录
			let g:neocomplcache_temporary_dir = s:get_cache_dir("neocon")
			" Use fuzzy completion.
			let g:neocomplcache_enable_fuzzy_completion = 1
			" Set minimum syntax keyword length.
			let g:neocomplcache_min_syntax_length = 3
			" buffer file name pattern that disables neocomplcache.
			let g:neocomplcache_disable_caching_file_path_pattern = '\.log\|\.log\.\|.*quickrun.*\|\.cnx\|Log.txt\|\.user.js'
			" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
			let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*\|\*unite\*\|Command Line'
			" 每次补全菜单弹出时，可以再按一个”-“键，这是补全菜单中的每个候选词
			" 会被标上一个字母，只要再输入对应字母就可以马上完成选择。
			let g:neocomplcache_enable_quick_match = 1
			" ]]]

			"  Define dictionary. [[[4
			let g:neocomplcache_dictionary_filetype_lists = {
						\ 'default'    : '',
						\ 'bash'       : $HOME.'/.bash_history',
						\ 'c'          : $VIMFILES.'/dict/c.txt',
						\ 'cpp'        : $VIMFILES.'/dict/c.txt',
						\ 'css'        : $VIMFILES.'/dict/css.txt',
						\ 'java'       : $VIMFILES.'/dict/java.txt',
						\ 'javascript' : $VIMFILES.'/dict/javascript.txt'.','.$VIMFILES.'/dict/node.txt',
						\ 'lua'        : $VIMFILES.'/dict/lua.txt',
						\ 'php'        : $VIMFILES.'/dict/php.txt',
						\ 'python'     : $VIMFILES.'/dict/python.txt',
						\ 'ruby'       : $VIMFILES.'/dict/ruby.txt',
						\ 'scheme'     : $HOME.'/.gosh_completions',
						\ 'vim'        : $VIMFILES.'/dict/vim.txt',
						\ 'vimshell'   : s:get_cache_dir("vimshell").'/command-history',
						\ 'zsh'        : $VIMFILES.'/dict/zsh.txt'
						\ }
			" ]]]

			"  Define keyword. [[[4
			if !exists('g:neocomplcache_keyword_patterns')
				let g:neocomplcache_keyword_patterns = {}
			endif
			let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
			" ]]]

			"  键映射 [[[4
			" Plugin key-mappings.
			"imap <C-k>     <Plug>(neocomplcache_snippets_expand)
			"smap <C-k>     <Plug>(neocomplcache_snippets_expand)
			inoremap <expr> <C-g>     neocomplcache#undo_completion()
			inoremap <expr> <C-l>     neocomplcache#complete_common_string()
			"<CR>: close popup and save indent.
			"inoremap <expr> <CR> neocomplcache#smart_close_popup() . "\<CR>"
			"<TAB>: completion. NO USE with snipmate
			"<C-h>, <BS>: close popup and delete backword char.
			inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
			inoremap <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
			inoremap <expr> <C-Y> neocomplcache#close_popup()
			inoremap <expr> <C-e> neocomplcache#cancel_popup()
			"inoremap <expr> <Enter> pumvisible() ? neocomplcache#close_popup()."\<C-n>" : "\<Enter>"
			"inoremap <expr> <Enter> pumvisible() ? "\<C-Y>" : "\<Enter>"

			"下面的 暂时不会，等会了再慢慢搞,暂时先用默认的
			"imap <expr> <TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

			" Recommended key-mappings.
			" <CR>: close popup and save indent.
			"inoremap <expr> <CR>  neocomplcache#smart_close_popup()."\<CR>"
			" <TAB>: completion. 下面的貌似冲突了
			"inoremap <expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
			" <C-h>, <BS>: close popup and delete backword char.
			inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
			inoremap <expr> <BS> neocomplcache#smart_close_popup()."\<C-h>"
			inoremap <expr> <C-y> neocomplcache#close_popup()
			inoremap <expr> <C-e> neocomplcache#cancel_popup()
			" 类似于 AutoComplPop 用法
			let g:neocomplcache_enable_auto_select = 1

			" Shell like behavior(not recommended).
			set completeopt+=longest
			"let g:neocomplcache_disable_auto_complete = 1
			"inoremap <expr> <TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
			"inoremap <expr> <CR>  neocomplcache#smart_close_popup() . "\<CR>"
			" ]]]

			"  设置全能补全 [[[4
			" Enable omni completion.
			augroup Filetype_Specific
				autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
				autocmd FileType html,markdown,ctp setlocal omnifunc=htmlcomplete#CompleteTags
				autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
				autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
				autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
				autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
				autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
				autocmd FileType vim setlocal omnifunc=syntaxcomplete#Complete
			augroup END

			" Enable heavy omni completion.
			if !exists('g:neocomplcache_omni_patterns')
				let g:neocomplcache_omni_patterns = {}
			endif
			let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
			let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
			let g:neocomplcache_omni_patterns.php =
						\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
			let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

			" For perlomni.vim setting.
			" https://github.com/c9s/perlomni.vim
			let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
			" ]]]
		endfunction
		call neobundle#untap()
	endif
	"------------------NeoComplcache---------------------------------  ]]]
elseif s:autocomplete_method == 'neocomplete'
	"  NeoComplete [[[3
	if neobundle#tap('neocomplete.vim')
		" Disable AutoComplPop.
		let g:acp_enableAtStartup = 0
		" Use neocomplete.
		let g:neocomplete#enable_at_startup = 1
		function! neobundle#hooks.on_source(bundle)
			"  设置选项 [[[4
			" Use smartcase.
			let g:neocomplete#enable_smart_case = 1
			" Use camel case completion.
			let g:neocomplete#enable_camel_case = 1
			" Use fuzzy completion.
			let g:neocomplete#enable_fuzzy_completion = 1
			" 设置缓存目录
			let g:neocomplete#data_directory = s:get_cache_dir("neocomplete")
			let g:neocomplete#enable_auto_delimiter = 1
			" Set minimum syntax keyword length.
			let g:neocomplete#sources#syntax#min_keyword_length = 3
			" Set auto completion length.
			let g:neocomplete#auto_completion_start_length = 2
			" Set manual completion length.
			let g:neocomplete#manual_completion_start_length = 0
			" Set minimum keyword length.
			let g:neocomplete#min_keyword_length = 3
			" buffer file name pattern that disables neocomplete.
			let g:neocomplete#sources#buffer#disabled_pattern = '\.log\|\.log\.\|.*quickrun.*\|\.cnx\|Log.txt\|\.user.js'
			" buffer file name pattern that locks neocomplete. e.g. ku.vim or fuzzyfinder
			let g:neocomplete#lock_buffer_name_pattern = '\*ku\*\|\*unite\*\|Command Line'
			let g:neocomplete#sources#buffer#cache_limit_size = 300000
			let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]
			" ]]]

			"  Define dictionary. [[[4
			let g:neocomplete#sources#dictionary#dictionaries = {
						\ 'default'    : '',
						\ 'bash'       : $HOME.'/.bash_history',
						\ 'c'          : $VIMFILES.'/dict/c.txt',
						\ 'cpp'        : $VIMFILES.'/dict/c.txt',
						\ 'css'        : $VIMFILES.'/dict/css.txt',
						\ 'java'       : $VIMFILES.'/dict/java.txt',
						\ 'javascript' : $VIMFILES.'/dict/javascript.txt'.','.$VIMFILES.'/dict/node.txt',
						\ 'lua'        : $VIMFILES.'/dict/lua.txt',
						\ 'php'        : $VIMFILES.'/dict/php.txt',
						\ 'python'     : $VIMFILES.'/dict/python.txt',
						\ 'ruby'       : $VIMFILES.'/dict/ruby.txt',
						\ 'scheme'     : $HOME.'/.gosh_completions',
						\ 'vim'        : $VIMFILES.'/dict/vim.txt',
						\ 'vimshell'   : s:get_cache_dir("vimshell").'/command-history',
						\ 'zsh'        : $VIMFILES.'/dict/zsh.txt'
						\ }
			" ]]]

			"  Define keyword. [[[4
			if !exists('g:neocomplete#keyword_patterns')
				let g:neocomplete#keyword_patterns = {}
			endif
			let g:neocomplete#keyword_patterns['default'] = '\h\w*'
			" ]]]

			"  键映射 [[[4
			" Plugin key-mappings.
			inoremap <expr> <C-g>     neocomplete#undo_completion()
			inoremap <expr> <C-l>     neocomplete#complete_common_string()

			" Recommended key-mappings.
			" <CR>: close popup and save indent.
			inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
			function! s:my_cr_function()
				return neocomplete#smart_close_popup() . "\<CR>"
				" For no inserting <CR> key.
				"return pumvisible() ? neocomplete#close_popup() : "\<CR>"
			endfunction
			" <TAB>: completion.
			" For smart TAB completion.
			inoremap <silent><expr> <TAB>
						\ pumvisible() ? "\<C-n>" :
						\ <SID>check_back_space() ? "\<TAB>" :
						\ neocomplete#start_manual_complete()
			function! s:check_back_space()
				let col = col('.') - 1
				return !col || getline('.')[col - 1] =~ '\s'
			endfunction
			" <S-TAB>: completion back.
			inoremap <expr> <S-TAB>  pumvisible() ? "\<C-p>" : "\<TAB>"
			" <C-h>, <BS>: close popup and delete backword char.
			inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
			inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
			inoremap <expr> <C-y>  neocomplete#close_popup()
			inoremap <expr> <C-e>  neocomplete#cancel_popup()
			" Close popup by <Space>.
			"inoremap <expr> <Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

			" For cursor moving in insert mode(Not recommended)
			"inoremap <expr> <Left>  neocomplete#close_popup() . "\<Left>"
			"inoremap <expr> <Right> neocomplete#close_popup() . "\<Right>"
			"inoremap <expr> <Up>    neocomplete#close_popup() . "\<Up>"
			"inoremap <expr> <Down>  neocomplete#close_popup() . "\<Down>"
			" Or set this.
			"let g:neocomplete#enable_cursor_hold_i = 1
			" Or set this.
			"let g:neocomplete#enable_insert_char_pre = 1

			" 类似于 AutoComplPop 用法
			"let g:neocomplete#enable_auto_select = 1

			" Shell like behavior(not recommended).
			"set completeopt+=longest
			"let g:neocomplete#enable_auto_select = 1
			"let g:neocomplete#disable_auto_complete = 1
			"inoremap <expr> <TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
			" ]]]

			"  设置全能补全 [[[4
			" Enable omni completion.
			augroup Filetype_Specific
				autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
				autocmd FileType html,markdown,ctp setlocal omnifunc=htmlcomplete#CompleteTags
				autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
				autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
				autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
				autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
				autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
				autocmd FileType vim setlocal omnifunc=syntaxcomplete#Complete
			augroup END

			" Enable heavy omni completion.
			if !exists('g:neocomplete#sources#omni#input_patterns')
				let g:neocomplete#sources#omni#input_patterns = {}
			endif
			let g:neocomplete#sources#omni#input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
			let g:neocomplete#sources#omni#input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
			let g:neocomplete#sources#omni#input_patterns.php =
						\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
			let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::\w*'

			" For perlomni.vim setting.
			" https://github.com/c9s/perlomni.vim
			let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
			" ]]]
		endfunction
		call neobundle#untap()
	endif
	" ]]]
endif
" ]]]
"    NeoMRU.vim [[[2
if neobundle#tap('neomru.vim')
	function! neobundle#hooks.on_source(bundle)
		" Specifies the directory to write the information of most recent used directory.
		let g:neomru#directory_mru_path = s:get_cache_dir("neomru/directory")
		" Specifies the file to write the information of most recent used files.
		let g:neomru#file_mru_path = s:get_cache_dir("neomru/file")
	endfunction
	call neobundle#untap()
endif
" ]]]
"    NeoSnippet.vim [[[2
if neobundle#tap('neosnippet.vim')
	function! neobundle#hooks.on_source(bundle)
		"  设置选项 [[[3
		" Enable snipMate compatibility feature.
		let g:neosnippet#enable_snipmate_compatibility = 1
		" Tell Neosnippet about the other snippets
		let g:neosnippet#snippets_directory = $VIMFILES.'/bundle/vim-snippets/snippets'
		" Specifies directory for neosnippet cache.
		let g:neosnippet#data_directory = s:get_cache_dir("neosnippet")
		" For snippet_complete marker.
		if has('conceal')
			set conceallevel=2
			" 'i' is for neosnippet
			set concealcursor=i
			if !s:isWindows && !s:isMac && s:isGUI
				" set listchars+=conceal:Δ
				let &listchars=&listchars.",conceal:\u0394"
			endif
		endif
		" Disable the neosnippet preview candidate window
		" When enabled, there can be too much visual noise
		" especially when splits are used.
		set completeopt-=preview
		" ]]]

		"  键映射 [[[3
		" Plugin key-mappings.
		imap <silent> <C-k> <Plug>(neosnippet_expand_or_jump)
		smap <silent> <C-k> <Plug>(neosnippet_expand_or_jump)
		xmap <silent> <C-k> <Plug>(neosnippet_expand_target)
		imap <silent> <C-l> <Plug>(neosnippet_jump_or_expand)
		smap <silent> <C-l> <Plug>(neosnippet_jump_or_expand)
		xmap <silent> <C-l> <Plug>(neosnippet_start_unite_snippet_target)

		" SuperTab like snippets behavior.
		imap <expr> <TAB> neosnippet#expandable_or_jumpable() ?
					\ "\<Plug>(neosnippet_expand_or_jump)"
					\: pumvisible() ? "\<C-n>" : "\<TAB>"
		smap <expr> <TAB> neosnippet#expandable_or_jumpable() ?
					\ "\<Plug>(neosnippet_expand_or_jump)"
					\: "\<TAB>"
		" ]]]
	endfunction
	call neobundle#untap()
endif
" ]]]
"    [Disabled]NERD_commenter.vim 注释代码用的，以下映射已写在插件中 [[[2
" <Leader>ca 在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
" <Leader>cc 注释当前行
" <Leader>cs 以”性感”的方式注释
" <Leader>cA 在当前行尾添加注释符，并进入Insert模式
" <Leader>cu 取消注释
" <Leader>cm 添加块注释
" let NERD_c_alt_style = 1
" let NERDSpaceDelims = 1
" ]]]
"    NERD_tree.vim 文件管理器 [[[2
if neobundle#tap('nerdtree')
	" 指定书签文件
	let NERDTreeBookmarksFile = s:get_cache_dir("NERDTreeBookmarks")
	" 同时改变当前工作目录
	let NERDTreeChDirMode = 2
	" NERDTree 替代 Netrw 插件来浏览本地目录
	" 由于跟 Startify 可能有些冲突，所以禁用，见 :help startify-faq-08
	" let NERDTreeHijackNetrw = 0
	" 排除 . .. 文件
	let NERDTreeIgnore = [
				\ '__pycache__',
				\ '\.DS_Store',
				\ '\.bzr',
				\ '\.class',
				\ '\.git',
				\ '\.hg',
				\ '\.idea',
				\ '\.pyc',
				\ '\.pyo',
				\ '\.rvm',
				\ '\.sass-cache',
				\ '\.svn',
				\ '\.swo$',
				\ '\.swp$',
				\ 'node_modules',
				\ '^\.$',
				\ '^\.\.$',
				\ ]
	" 指定鼠标模式(1.双击打开 2.单目录双文件 3.单击打开)
	let NERDTreeMouseMode = 2
	" 打开文件后关闭树窗口
	let NERDTreeQuitOnOpen = 1
	" 是否默认显示书签列表
	let NERDTreeShowBookmarks = 1
	" 是否默认显示隐藏文件
	let NERDTreeShowHidden = 1
	" 窗口在加载时的宽度
	let NERDTreeWinSize = 31
	call neobundle#untap()
endif
" ]]]
"    Netrw [[[2
" Netrw 使用 curl
if executable("curl")
	let g:netrw_http_cmd = "curl"
	let g:netrw_http_xcmd = "-L --compressed -o"
endif
" 隐藏文件的模式列表
let g:netrw_list_hide = '^\.[^.].*'
" ]]]
"    php_localvarcheck [[[2
if neobundle#tap('php_localvarcheck.vim')
	let g:php_localvarcheck_enable=1
	call neobundle#untap()
endif
" ]]]
"    PIV [[[2
if neobundle#tap('PIV')
	function! neobundle#hooks.on_source(bundle)
		let g:DisableAutoPHPFolding = 0
		let g:PIVAutoClose = 0
	endfunction
	call neobundle#untap()
endif
" ]]]
"    PO (Portable Object -- gettext 翻译)  [[[2
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
if neobundle#tap('po.vim--gray')
	function! neobundle#hooks.on_source(bundle)
		let g:po_translator = "Firef0x <firefgx { at ) gmail [ dot } com>"
	endfunction
	call neobundle#untap()
endif
" ]]]
"    Rainbow 彩虹括号增强版 (Rainbow Parentheses Improved) [[[2
" 通过将不同层次的括号高亮为不同的颜色, 帮助你阅读世界上最复杂的代码
if neobundle#tap('rainbow')
	let g:rainbow_active = 1
	" 高级配置
	" 'guifgs': GUI界面的括号颜色(将按顺序循环使用)
	" 'ctermfgs': 终端下的括号颜色(同上,插件将根据环境进行选择)
	" 'operators': 描述你希望哪些运算符跟着与它同级的括号一起高亮(见vim帮助 :syn-pattern)
	" 'parentheses': 描述哪些模式将被当作括号处理,每一组括号由两个vim正则表达式描述
	" 'separately': 针对文件类型(由&ft决定)作不同的配置,未被设置的文件类型使用'*'下的配置
	let g:rainbow_conf = {
				\	'guifgs': ['RoyalBlue3', 'DarkOrange3', 'SeaGreen3', 'firebrick3', 'DarkOrchid3'],
				\	'ctermfgs': [
				\			  'brown',
				\			  'lightblue',
				\			  'lightyellow',
				\			  'lightcyan',
				\			  'lightmagenta',
				\			  'darkgreen',
				\			  'darkred',
				\			  'brown',
				\			  'Darkblue',
				\			  'gray',
				\			  'black',
				\			  'darkmagenta',
				\			  'darkgreen',
				\			  'darkcyan',
				\			  'darkred',
				\			  ],
				\	'operators': '_,_',
				\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
				\	'separately': {
				\		'*': {},
				\		'cpp': {
				\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/\v%(<operator\_s*)@<!%(%(\i|^\_s*|template\_s*)@<=\<[<#=]@!|\<@<!\<[[:space:]<#=]@!)/ end=/\v%(-)@<!\>/ fold'],
				\		},
				\		'cs': {
				\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/\v%(\i|^\_s*)@<=\<[<#=]@!|\<@<!\<[[:space:]<#=]@!/ end=/\v%(-)@<!\>/ fold'],
				\		},
				\		'css': 0,
				\		'html': {
				\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
				\		},
				\		'java': {
				\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/\v%(\i|^\_s*)@<=\<[<#=]@!|\<@<!\<[[:space:]<#=]@!/ end=/\v%(-)@<!\>/ fold'],
				\		},
				\		'php': {
				\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
				\		},
				\		'tex': {
				\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
				\		},
				\		'vim': {
				\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
				\		},
				\		'xhtml': {
				\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
				\		},
				\		'xml': {
				\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
				\		},
				\	}
				\}
	call neobundle#untap()
endif
" ]]]
"    ShowTrailingWhitespace 显示尾部多余空格 [[[2
if neobundle#tap('ShowTrailingWhitespace')
	highlight ShowTrailingWhitespace ctermbg=Red guibg=Red
	call neobundle#untap()
endif
" ]]]
"    SrcExpl -- 增强源代码浏览，其功能就像 Windows 中的 Source Insight [[[2
" :SrcExpl                                   "打开浏览窗口
" :SrcExplClose                              "关闭浏览窗口
" :SrcExplToggle                             "打开/闭浏览窗口
" ]]]
"    Startify 起始页 [[[2
if neobundle#tap('vim-startify')
	" 打开文件同时转到当前目录
	let g:startify_change_to_dir = 1
	" 列表显示的文件数
	let g:startify_files_number = 15
	" 设置会话文件目录
	let g:startify_session_dir = s:get_cache_dir("sessions")
	let g:startify_show_sessions = 1
	" 设置忽略文件列表
	let g:startify_skiplist = [
				\ 'COMMIT_EDITMSG',
				\ $VIMRUNTIME .'/doc',
				\ 'bundle/.*/doc',
				\ '\.DS_Store',
				\ 'osc-commit.*\.diff',
				\ 'osc_metafile.*\.xml'
				\ ]
	call neobundle#untap()
endif
" ]]]
"    SudoEdit.vim 以 root 权限打开文件 [[[2
if neobundle#tap('SudoEdit.vim')
	" 不使用图形化的 askpass
	let g:sudo_no_gui=1
	" 显示调试信息
	" let g:sudoDebug=1
	call neobundle#untap()
endif
" ]]]
"    Syntastic 语法检查 [[[2
if neobundle#tap('syntastic')
	" 光标跳转到第一个错误处
	let g:syntastic_auto_jump = 2
	if !s:isWindows && !s:isMac
		" let g:syntastic_error_symbol         = '✗'
		" let g:syntastic_style_error_symbol   = '✠'
		" let g:syntastic_warning_symbol       = '⚠'
		" let g:syntastic_style_warning_symbol = '≈'
		let g:syntastic_error_symbol         = "\u2717"
		let g:syntastic_style_error_symbol   = "\u2720"
		let g:syntastic_warning_symbol       = "\u26a0"
		let g:syntastic_style_warning_symbol = "\u2248"
	endif
	let g:syntastic_mode_map = {
				\ 'mode' : 'passive',
				\ 'active_filetypes' : ['javascript', 'javascript.jsx',
				\ 'lua', 'php', 'sh'],
				\ 'passive_filetypes' : ['puppet']
				\ }
	"  Checkers for Syntastic [[[3
	" JavaScript [[[4
	if s:hasNode
		let g:syntastic_javascript_checkers=['eslint']
		let g:syntastic_javascript.jsx_checkers=['eslint']
	endif
	" ]]]
	" VimL [[[4
	let g:syntastic_vim_checkers=['vimlint']
	" ]]]
	" ]]]
	call neobundle#untap()
endif
" ]]]
"    syntax/haskell.vim [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
" ]]]
"    syntax/python.vim [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
let python_highlight_all = 1
" ]]]
"    syntax/sh.vim [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
" shell 脚本打开函数和 here 文档的折叠
let g:sh_fold_enabled = 3
" ]]]
"    syntax/vim.vim 默认会高亮 s:[a-z] 这样的函数名为错误 [[[2
let g:vimsyn_noerror = 1
" ]]]
"    Tagbar [[[2
if neobundle#tap('tagbar')
	" 使 Tagbar 在左边窗口打开 (与 NERDTree 的位置冲突)
	" let tagbar_left = 1
	let tagbar_width = 30
	let tagbar_singleclick = 1
	" let g:tagbar_type_dosini = {
	" 			\ 'ctagstype': 'ini',
	" 			\ 'kinds': ['s:sections', 'b:blocks'],
	" 			\ }
	let g:tagbar_type_pgsql = {
				\ 'ctagstype': 'pgsql',
				\ 'kinds': ['f:functions', 't:tables'],
				\ }
	augroup Filetype_Specific
		" autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx,*.ini call tagbar#autoopen()
		autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
		" 忽略 .user.js 和 JSON 格式文件
		autocmd BufReadPost *.user.js,*.json,*.jsonp let b:tagbar_ignore = 1
	augroup END
	call neobundle#untap()
endif
" ]]]
"    Tag Highlight -- CTags 语法高亮 [[[2
if neobundle#tap('taghighlight')
	if !exists('g:TagHighlightSettings')
		let g:TagHighlightSettings = {}
	endif
	if !s:hasPython
		let g:TagHighlightSettings['ForcedPythonVariant'] = 'compiled'
	endif
	let g:TagHighlightSettings['LanguageDetectionMethods'] =
				\ ['Extension', 'FileType']
	let g:TagHighlightSettings['FileTypeLanguageOverrides'] =
				\ {'tagbar':'cpp', 'javascript':'', 'json':''}
	call neobundle#untap()
endif
" ]]]
"    UndoTree 撤销树视图 [[[2
if neobundle#tap('undotree')
	let g:undotree_WindowLayout = 2
	" If undotree is opened, it is likely one wants to interact with it.
	let g:undotree_SetFocusWhenToggle = 1
	call neobundle#untap()
endif
" ]]]
"    Unite [[[2
if neobundle#tap('unite.vim')
	function! neobundle#hooks.on_source(bundle)
		"  定义配置变量 [[[3
		" Set up some custom ignores
		let s:unite_ignores = [
					\ '__pycache__/',
					\ '\.bzr/',
					\ '\.git/',
					\ '\.hg/',
					\ '\.idea/',
					\ '\.rvm/',
					\ '\.sass-cache/',
					\ '\.svn/',
					\ 'node_modules/',
					\ ]
		" Default configuration.
		let s:default_context = {
					\ 'cursor_line_highlight' : 'TabLineSel',
					\ 'direction': 'botright',
					\ 'short_source_names' : 1,
					\ 'start_insert': 1,
					\ 'vertical' : 0,
					\ }
		if !s:isWindows && !s:isMac
			" let s:default_context.prompt =  '▸'
			let s:default_context.prompt =  "\u25b8"
			" let s:default_context.marked_icon = '✗'
			let s:default_context.marked_icon = "\u2717"
		endif
		" ]]]

		"  Custom filters. [[[3
		call unite#filters#matcher_default#use(['matcher_fuzzy'])
		call unite#filters#sorter_default#use(['sorter_rank'])
		" Start in insert mode
		call unite#custom#profile('action', 'context', {
					\ 'start_insert' : 1
					\ })
		call unite#custom#profile('default', 'context', s:default_context)
		call unite#custom#profile('files', 'context', {
					\ 'smartcase': 1,
					\ })
		call unite#custom#source('line,outline','matchers','matcher_fuzzy')
		call unite#custom#source('buffer,file_rec,file_rec/async,file_rec/git',
					\ 'matchers',['converter_relative_word', 'matcher_fuzzy',
					\ 'matcher_project_ignore_files'])
		call unite#custom#source('file_mru', 'matchers',
					\ ['matcher_project_files', 'matcher_fuzzy',
					\ 'matcher_hide_hidden_files', 'matcher_hide_current_file'])
		call unite#custom#source('file_rec/async,file_mru,file_rec,buffer',
					\ 'matchers',['converter_tail', 'matcher_fuzzy'])
		call unite#custom#source('file_rec/async,file_rec/git,file_mru',
					\ 'converters',['converter_file_directory'])
		call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep',
					\ 'ignore_pattern',
					\ escape(
					\	substitute(join(split(&wildignore, ","), '\|'),
					\   '**/\?', '', 'g'), '.') . '\|' .
					\ join(s:unite_ignores, '\|'))
		unlet s:unite_ignores
		unlet s:default_context
		" ]]]

		"  设置选项 [[[3
		" 设置缓存目录
		let g:unite_data_directory = s:get_cache_dir("unite")
		" Enable history yank source
		let g:unite_source_history_yank_enable = 1
		" Open in bottom right
		let g:unite_split_rule = "botright"
		let g:unite_source_rec_max_cache_files = 5000
		" For ack.
		if s:hasAg
			let g:unite_source_grep_command = 'ag'
			let g:unite_source_grep_default_opts =
						\ '--line-numbers --nocolor --nogroup --hidden --smart-case -C4 --ignore ' .
						\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
			let g:unite_source_grep_recursive_opt = ''
		elseif s:hasAck
			let g:unite_source_grep_command = 'ack'
			let g:unite_source_grep_default_opts = '--no-heading --no-color -C4'
			let g:unite_source_grep_recursive_opt = ''
		endif

		let g:unite_source_file_mru_limit = 1000
		let g:unite_cursor_line_highlight = 'TabLineSel'
		" let g:unite_abbr_highlight = 'TabLine'

		let g:unite_source_file_mru_filename_format = ':~:.'
		let g:unite_source_file_mru_time_format = ''
		" ]]]

		"  Unite 内部键映射 [[[3
		function! s:unite_settings()
			" Overwrite settings.
			nmap <buffer> <Esc> <plug>(unite_exit)
			imap <buffer> <Esc><Esc> <plug>(unite_exit)
			imap <buffer> <BS> <Plug>(unite_delete_backward_path)
			imap <buffer> <Tab> <Plug>(unite_complete)
			imap <buffer><expr> j unite#smart_map('j', '')
			nmap <buffer><expr><silent> <2-leftmouse>
						\ unite#smart_map('l', unite#do_action(unite#get_current_unite().context.default_action))
			nmap <buffer> <c-j> <Plug>(unite_loop_cursor_down)
			nmap <buffer> <c-k> <Plug>(unite_loop_cursor_up)
			imap <buffer> jk <Plug>(unite_insert_leave)
		endfunction
		autocmd Filetype_Specific FileType unite call s:unite_settings()
		" ]]]
	endfunction

	"  全局键映射 [[[3
	" The prefix key
	nmap ; [unite]
	xmap ; [unite]
	nnoremap [unite] <Nop>
	xnoremap [unite] <Nop>

	if s:isWindows
		nnoremap <silent> [unite]<Space>
					\ :<C-u>Unite -buffer-name=mixed -no-split -multi-line
					\ jump_point file_point file_rec:! file file/new buffer
					\ neomru/file bookmark<cr><c-u>
		nnoremap <silent> [unite]f :<C-u>Unite -toggle -buffer-name=files
					\ file_rec:!<cr><c-u>
	else
		nnoremap <silent> [unite]<Space>
					\ :<C-u>Unite -buffer-name=mixed -no-split -multi-line
					\ jump_point file_point file_rec/async:! file file/new
					\ buffer neomru/file bookmark<cr><c-u>
		nnoremap <silent> [unite]f
					\ :<C-u>Unite -toggle -buffer-name=files file_rec/async:!<cr><c-u>
	endif
	nnoremap <silent> [unite]n :<C-u>Unite -buffer-name=bundle neobundle<cr>
	nnoremap <silent> [unite]*
				\ :<C-u>UniteWithCursorWord -no-split -buffer-name=line line<cr>
	" Quick buffer and mru
	nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer neomru/file<cr>
	" Quick grep from current directory(prompt for word)
	nnoremap <silent> [unite]/
				\ :<C-u>Unite -auto-preview -no-empty -no-split -resume
				\ -buffer-name=search grep:.<cr>
	nnoremap <silent> [unite]m
				\ :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
	" Quickly switch lcd
	nnoremap <silent> [unite]d
				\ :<C-u>Unite -buffer-name=change-cwd -default-action=lcd
				\ neomru/directory directory_rec/async<CR>
	" Quickly most recently used
	nnoremap <silent> [unite]e
				\ :<C-u>Unite -buffer-name=recent neomru/file<CR>
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

	call neobundle#untap()
endif
" ]]]
"    Vim-AirLine  [[[2
" (以下取自 https://github.com/bling/vim-airline )
if neobundle#tap('vim-airline')
	if (s:isWindows || s:isGUI || s:isColor)
		let g:airline_powerline_fonts = 1
		let g:airline_theme = 'light'
		let g:airline#extensions#tabline#enabled = 1
		let g:airline#extensions#tabline#tab_nr_type = 1
		" let g:airline#extensions#tabline#buffer_nr_show = 1
		" 在 tabline 上显示序号
		let g:airline#extensions#tabline#buffer_idx_mode = 1
		if !exists('g:airline_symbols')
			let g:airline_symbols = {}
		endif
	endif
	"  显示 Mode 的简称 [[[3
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
	" ]]]
	"  定义符号 [[[3
	if s:isWindows
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
		" elseif s:isGUI
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
	call neobundle#untap()
endif
" ]]]
"    Vim Indent Guide 以灰色显示缩进块 [[[2
if neobundle#tap('vim-indent-guides')
	let g:indent_guides_start_level = 1
	let g:indent_guides_guide_size = 1
	let g:indent_guides_enable_on_vim_startup = 1
	" let g:indent_guides_color_change_percent = 3
	if s:isGUI==0
		let g:indent_guides_auto_colors = 0
		function! s:indent_set_console_colors()
			highlight IndentGuidesOdd ctermbg = 235
			highlight IndentGuidesEven ctermbg = 236
		endfunction
		autocmd MyAutoCmd VimEnter,Colorscheme * call s:indent_set_console_colors()
	endif
	call neobundle#untap()
endif
" ]]]
"    Vim-JSX React JSX 语法插件 [[[2
" (以下取自 http://foocoder.com/2016/04/08/vim环境搭建 )
if neobundle#tap('vim-jsx')
	" 使该插件在 .js 扩展名的文件中生效
	let g:jsx_ext_required = 0
	call neobundle#untap()
endif
" ]]]
"    Vim-Lastmod 自动更新最后修改时间 [[[2
" The format of the time stamp
"
" Syntax - Format   - Example
" %a     - Day      - Sat
" %Y     - YYYY     - 2005
" %b     - Mon      - Sep (3 digit month)
" %m     - mm       - 09 (2 digit month)
" %d     - dd       - 10
" %H     - HH       - 15 (hour upto 24)
" %I     - HH       - 12 (hour upto 12)
" %M     - MM       - 50 (minute)
" %X     - HH:MM:SS - (12:29:34)
" %p     - AM/PM
" %z %Z  - TimeZone - UTC
if neobundle#tap('vim-lastmod')
	if s:isWindows
		language time english
	else
		language time en_US.UTF-8
	endif
	let g:lastmod_format="%d %b %Y %H:%M"
	let g:lastmod_lines=7
	let g:lastmod_suffix=" +0800"
	call neobundle#untap()
endif
" ]]]
"    VimLint VimL 语法检查工具 [[[2
if neobundle#tap('vim-vimlint')
	let g:vimlint#config = {
				\ 'quiet' : 1,
				\ 'EVL103': 1,
				\ 'EVL105': 1}
	call neobundle#untap()
endif
" ]]]
"    Vim-Monokai 配色 [[[2
if neobundle#tap('vim-monokai')
	" A less bright NERDTree
	let g:monokai_zentree = 1
	call neobundle#untap()
endif
" ]]]
"    Vim Vimperator [[[2
if neobundle#tap('vim-vimperator')
	augroup Filetype_Specific
		autocmd SwapExists vimperator*.tmp
					\ :runtime plugin/vimperator.vim | call VimperatorEditorRecover(1)
	augroup END
	call neobundle#untap()
endif
" ]]]
"    VimShell Vim 下的原生终端 [[[2
if neobundle#tap('vimshell.vim')
	function! neobundle#hooks.on_source(bundle)
		if s:isWindows || s:isMac
			let g:vimshell_prompt =  '$'
		else
			" let g:vimshell_prompt =  '▸'
			let g:vimshell_prompt =  "\u25b8"
		endif
		let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
		" 设置缓存目录
		let g:vimshell_data_directory = s:get_cache_dir("vimshell")
		let g:vimshell_editor_command = 'vim'
		let g:vimshell_vimshrc_path = $VIMFILES.'/vimshrc'
	endfunction
	call neobundle#untap()
endif
" ]]]
"    Vim-Scratch 临时缓冲区 [[[2
if neobundle#tap('vim-scratch')
	function! neobundle#hooks.on_source(bundle)
		let g:scratch_buffer_name="[Scratch]"
	endfunction
	call neobundle#untap()
endif
" ]]]
"    [Disabled]Vim-Sneak [[[2
" let g:sneak#streak = 1
" ]]]
"    xml.vim 使所有的标签都关闭[[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
if neobundle#tap('xml.vim')
	function! neobundle#hooks.on_source(bundle)
		let xml_use_xhtml = 1
	endfunction
	call neobundle#untap()
endif
" ]]]
" ]]]
"  自动命令 [[[1
"    特定文件类型自动命令组 [[[2
augroup Filetype_Specific
	"  Arch Linux [[[3
	autocmd FileType PKGBUILD setlocal tabstop=2 shiftwidth=2 expandtab
	autocmd BufNewFile,BufRead *.install,install setlocal tabstop=2 shiftwidth=2 expandtab
	" ]]]
	"  C/C++ [[[3
	"  Don't autofold anything (but I can still fold manually)
	autocmd FileType c setlocal smartindent foldmethod=syntax foldlevel=100
	autocmd FileType cpp setlocal smartindent foldmethod=syntax foldlevel=100
	" ]]]
	"  CSS [[[3
	autocmd FileType css setlocal smartindent noexpandtab foldmethod=indent "tabstop=2 shiftwidth=2
	autocmd BufNewFile,BufRead *.scss setlocal ft=scss
	" 删除一条CSS中无用空格 <Leader>co
	autocmd FileType css vnoremap <Leader>co J:s/\s*\([{:;,]\)\s*/\1/g<CR>:let @/=''<cr>
	autocmd FileType css nnoremap <Leader>co :s/\s*\([{:;,]\)\s*/\1/g<CR>:let @/=''<cr>
	" ]]]
	"  Markdown [[[3
	autocmd FileType markdown setlocal nolist
	" ]]]
	"  Javascript [[[3
	autocmd FileType javascript setlocal dictionary+=$VIMFILES/dict/node.txt
	" Javascript Code Modules(Mozilla)
	autocmd BufNewFile,BufRead *.jsm setlocal filetype=javascript
	" jQuery syntax
	autocmd BufNewFile,BufRead jquery.*.js setlocal filetype=javascript syntax=jquery
	" ]]]
	"  PHP [[[3
	" PHP 生成的SQL/HTML代码高亮
	autocmd FileType php let php_sql_query=1
	autocmd FileType php let php_htmlInStrings=1
	" PHP Twig 模板引擎语法
	" autocmd BufNewFile,BufRead *.twig set syntax=twig
	" ]]]
	"  PO [[[3
	" 避免跟 po.vim 冲突
	autocmd FileType po let maplocalleader="`" | let g:maplocalleader="`"
	" ]]]
	"  Python [[[3
	" Python 文件的一般设置，比如不要 tab 等
	autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab foldmethod=indent
	" ]]]
	"  Shell [[[3
	autocmd FileType sh setlocal tabstop=8 shiftwidth=8 expandtab
	" ]]]
	"  VimFiles [[[3
	autocmd FileType vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
	autocmd FileType vim setlocal foldmethod=indent keywordprg=:help
	" ]]]
	"  文本文件 [[[3
	" autocmd BufWritePre *.text,*.txt call PanGuSpacing()
	" ]]]
	"  文件编码 [[[3
	" (以下取自 http://wyw.dcweb.cn/vim/_vimrc.html )
	autocmd BufReadPre *.gb call s:SetFileEncodings('cp936')
	autocmd BufReadPre *.big5 call s:SetFileEncodings('cp950')
	" 能够漂亮地显示 .NFO 文件
	autocmd BufReadPre *.nfo call s:SetFileEncodings('cp437')
	autocmd BufReadPost *.nfo call s:RestoreFileEncodings()
	" ]]]
	"  其它 [[[3
	"    自己原创修改 [[[4
	"      特定文件，非扩展名 [[[5
	"        MySQL 慢查询日志 [[[6
	autocmd BufRead *mysql-slow*.log* setlocal filetype=mysql
	" ]]]
	"        openSUSE Build Service [[[6
	autocmd BufNewFile,BufRead _files,_meta,_packages,_service setlocal filetype=xml
	" ]]]
	"        Zoom [[[6
	autocmd BufNewFile,BufRead .zoominfo,.zoomrc setlocal filetype=json
	" ]]]
	"        Underscore.js syntax [[[6
	autocmd BufNewFile,BufRead */modules/**/tpl/*.html setlocal filetype=html syntax=underscore_template
	" ]]]
	" ]]]
	" ]]]
	"    (以下取自 https://github.com/lilydjwg/dotvim ) [[[4
	"      More ignored extensions [[[5
	" (modified from the standard one)
	if exists("*fnameescape")
		autocmd BufNewFile,BufRead ?\+.pacsave,?\+.pacnew
					\ exe "doau filetypedetect BufRead " . fnameescape(expand("<afile>:r"))
	elseif &verbose > 0
		echomsg "Warning: some filetypes will not be recognized because this version of vim does not have fnameescape()"
	endif

	autocmd BufNewFile,BufRead *.lrc setlocal filetype=lrc
	autocmd BufNewFile,BufRead *.asm,*.asm setlocal filetype=masm
	autocmd BufRead *access[._]log* setlocal filetype=httplog
	autocmd BufNewFile,BufRead .htaccess.* setlocal filetype=apache
	autocmd BufRead pacman.log setlocal filetype=pacmanlog
	autocmd BufRead /var/log/*.log* setlocal filetype=messages
	autocmd BufNewFile,BufRead *.aspx,*.ascx setlocal filetype=html
	autocmd BufRead grub.cfg,burg.cfg setlocal filetype=sh
	autocmd BufNewFile,BufRead $VIMFILES/dict/*.txt setlocal filetype=dict
	autocmd BufNewFile,BufRead fcitx_skin.conf,*/fcitx*.{conf,desc}*,*/fcitx/profile setlocal filetype=dosini
	autocmd BufNewFile,BufRead /etc/goagent setlocal filetype=dosini
	autocmd BufNewFile,BufRead mimeapps.list setlocal filetype=desktop
	autocmd BufRead *tmux.conf setlocal filetype=tmux
	autocmd BufRead rc.conf setlocal filetype=sh
	autocmd BufRead *.grf,*.url setlocal filetype=dosini
	autocmd BufNewFile,BufRead ejabberd.cfg* setlocal filetype=erlang
	autocmd BufNewFile,BufRead */xorg.conf.d/* setlocal filetype=xf86conf
	autocmd BufNewFile,BufRead hg-editor-*.txt setlocal filetype=hgcommit
	autocmd BufNewFile,BufRead *openvpn*/*.conf,*.ovpn setlocal filetype=openvpn
	autocmd BufNewFile,BufRead *eslintrc setlocal filetype=json
	" ]]]
	"      Websites [[[5
	autocmd BufRead forum.ubuntu.org.cn_*,bbs.archlinuxcn.org_post.php*.txt setlocal ft=bbcode
	autocmd BufRead *fck_source.html* setlocal ft=html
	autocmd BufRead *docs.google.com_Doc* setlocal ft=html
	autocmd BufNewFile,BufRead *postmore/wiki/*.wiki setlocal ft=googlecodewiki
	autocmd BufNewFile,BufRead *.mw,*wpTextbox*.txt,*wiki__text*.txt setlocal ft=wiki
	" ]]]
	" ]]]
	"    (以下取自 https://github.com/terryma/dotfiles ) [[[4
	"      Quickfix [[[5
	autocmd FileType qf call AdjustWindowHeight(3, 50)
	" ]]]
	" ]]]
	" ]]]
augroup END " Filetype_Specific
" ]]]
"    默认自动命令组 [[[2
augroup MyAutoCmd
	"  当打开一个新缓冲区时，自动切换目录为当前编辑文件所在目录 [[[3
	autocmd BufEnter,BufNewFile,BufRead *
				\ if bufname("") !~ "^\[A-Za-z0-9\]*://" && expand("%:p") !~ "^sudo:"
				\|    silent! lcd %:p:h
				\|endif
	" ]]]
	"  保存 Vim 配置文件后加载 [[[3
	" 加载完之后需要执行 AirlineRefresh 来刷新，否则 tabline 排版会乱
	" 参见 https://github.com/bling/vim-airline/issues/312
	"
	" FIXME 似乎要 AirlineRefresh 两次才能完全刷新
	" 参见 https://github.com/bling/vim-airline/issues/539
	autocmd BufWritePost $MYVIMRC
				\ NeoBundleClearCache | silent source $MYVIMRC | AirlineRefresh
	" ]]]
	"  自动更新 diff [[[3
	" (以下取自 https://github.com/Shougo/shougo-s-github )
	autocmd InsertLeave *
				\ if &l:diff
				\|    diffupdate
				\|endif
	" ]]]
	"  禁止 NERDTree 在 Startify 页面打开一个分割窗口 [[[3
	" (以下取自 :help startify-faq-06 )
	autocmd User Startified setlocal buftype=
	" ]]]
augroup END
" ]]]
" ]]]
"  自定义命令 [[[1
if has('user_commands')
	"    :BufClean 删除所有未显示且无修改的缓冲区以减少内存占用 [[[2
	" (以下取自 https://github.com/lilydjwg/dotvim )
	command! BufClean call cleanbufs()
	" ]]]
	"    :Delete 删除当前文件 [[[2
	" (以下取自 https://github.com/lilydjwg/dotvim )
	command! -nargs=0 Delete
				\ if delete(expand('%'))
				\|    echohl WarningMsg
				\|    echo "删除当前文件失败!"
				\|    echohl None
				\|endif
	" ]]]
	"    :NBU NeoBundle 更新所有插件 [[[2
	command! -nargs=0 NBU Unite neobundle/update -vertical -no-start-insert
	" ]]]
	"    :SQuote 将中文引号替换为英文引号 [[[2
	" (以下取自 https://github.com/lilydjwg/dotvim )
	command! -range=% -bar SQuote <line1>,<line2>s/“\|”\|″/"/ge|<line1>,<line2>s/‘\|’\|′/'/ge
	" ]]]
	"    :SudoUpDate SudoEdit.vim 以 root 权限保存文件 [[[2
	" If the current buffer has never been saved, it will have no name,
	" call the file browser to save it, otherwise just save it.
	command! -nargs=0 -bar SudoUpDate
				\ if &modified
				\|    if !empty(bufname('%'))
				\|        exe 'SudoWrite'
				\|    endif
				\|endif
	" ]]]
	"    :UpDate 保存文件 [[[2
	" If the current buffer has never been saved, it will have no name,
	" call the file browser to save it, otherwise just save it.
	command! -nargs=0 -bar UpDate
				\ if &modified
				\|    if empty(bufname('%'))
				\|        browse confirm write
				\|    else
				\|        confirm write
				\|    endif
				\|endif
	" ]]]
	"    修复部分错按大写按键 [[[2
	command! -bang -nargs=* -complete=file E e<bang> <args>
	command! -bang Q q<bang>
	command! -bang QA qa<bang>
	command! -bang Qa qa<bang>
	command! -bang -nargs=* -complete=file Tabe tabe<bang> <args>
	command! -bang -nargs=* -complete=file W w<bang> <args>
	command! -bang Wa wa<bang>
	command! -bang WA wa<bang>
	command! -bang -nargs=* -complete=file Wq wq<bang> <args>
	command! -bang -nargs=* -complete=file WQ wq<bang> <args>
	" ]]]
endif
" ]]]
"  Vim 辅助工具设置 [[[1
"    Cscope 设置 [[[2
" (以下取自 https://github.com/lilydjwg/dotvim )
if s:hasCscope
	"  support GNU Global [[[3
	let s:tags_files = []
	if s:hasGtagsCscopeExe
		call add(s:tags_files, ['GTAGS', 'gtags-cscope'])
	endif
	if s:hasCscopeExe
		call add(s:tags_files, ['cscope.out', 'cscope'])
	endif
	" ]]]
	if !empty(s:tags_files)
		"  settings and autocmd [[[3
		set cscopetagorder=1
		set cscopetag
		set cscopequickfix=s-,c-,d-,i-,t-,e-

		" add any database in current directory
		function! Cscope_Add()
			try
				cd %:h
			catch /.*/
				return
			endtry

			try
				for [filename, prgname] in s:tags_files
					let db = findfile(filename, '.;')
					if !empty(db)
						let &cscopeprg = prgname
						set nocscopeverbose
						exec "cs add" db expand('%:p:h')
						set cscopeverbose
						break
					endif
				endfor
			finally
				silent cd -
			endtry
		endfunction

		autocmd MyAutoCmd BufRead *.c,*.cpp,*.h,*.cc,*.java,*.cs call Cscope_Add()

		"  调用这个函数就可以用 Cscope 生成数据库，并添加到 Vim 中
		function! Cscope_DoTag()
			try
				lcd %:p:h
			catch /.*/
				return
			endtry

			if s:isWindows
				silent! execute "Dispatch! dir /b *.c,*.cpp,*.h,*.cc,*.java,*.cs >> cscope.files"
			else
				silent! execute "Dispatch! find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.java' -o -name '*.cs' >> cscope.files"
			endif
			silent! execute "Dispatch! cscope -bkq"
			call Cscope_Add()
			if s:hasCCglueExe
				silent! execute "Dispatch! ccglue -S cscope.out -o cctree.out"
			endif
		endfunction
		" ]]]
		"  映射 [[[3
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
		" ]]]
	endif
endif
" ]]]
"    Windows 平台下窗口全屏组件 gvimfullscreen.dll [[[2
" (以下取自 https://github.com/asins/vim )
" 用于 Windows gVim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
"
" 映射          描述
" <Leader>ta    增加窗口透明度（[T]ransparency [A]dd）
" <Leader>tx    降低窗口透明度（与 Ctrl-A 及 Ctrl-X 相呼应）
" Alt-R         切换Vim是否总在最前面显示
" Vim 启动的时候自动使用当前颜色的背景色以去除 Vim 的白色边框
if s:hasVFS
	let g:MyVimLib = 'gvimfullscreen.dll'
	"  切换全屏函数 [[[3
	function! ToggleFullScreen()
		call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
	endfunction
	" ]]]
	"  设置透明度函数 (Alpha值 默认:245 范围:180~255) [[[3
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
	" ]]]
	"  切换总在最前面显示函数 (默认禁用) [[[3
	let g:VimTopMost = 0
	function! SwitchVimTopMostMode()
		if g:VimTopMost == 0
			let g:VimTopMost = 1
		else
			let g:VimTopMost = 0
		endif
		call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
	endfunction
	" ]]]
	"  默认设置透明 [[[3
	autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
	" ]]]
endif
" ]]]
" ]]]
"  快捷键映射 [[[1
"    准备工作 [[[2
"      设置 <Leader> 为逗号 [[[3
let mapleader=","
let g:mapleader = ","
" ]]]
"      Alt 组合键不映射到菜单上 [[[3
set winaltkeys=no
" ]]]
" ]]]
"    命令行模式映射 cmap [[[2
"      Ctrl-N/P 取代上下箭头键 [[[3
" (以下取自 https://github.com/lilydjwg/dotvim )
"     FIXME 但这样在 wildmenu 补全时会有点奇怪
cmap <C-P> <Up>
cmap <C-N> <Down>
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>
" ]]]
" ]]]
"    插入模式映射 imap [[[2
"      插入模式下按 jk 代替 Esc [[[3
inoremap <silent> jk <Esc>
" ]]]
"      回车时前字符为{时自动换行补全  [[[3
inoremap <silent> <CR> <C-R>=<SID>OpenSpecial('{','}')<CR>
" ]]]
"      插入模式下光标移动 <Alt-{h,j,k,l}> [[[3
inoremap <silent> <M-h> <Left>
inoremap <silent> <M-j> <Down>
inoremap <silent> <M-k> <Up>
inoremap <silent> <M-l> <Right>
" ]]]
" ]]]
"    普通模式映射 nmap [[[2
"      Fx 相关 [[[3
"        开关 NERDTree F2 [[[4
if neobundle#tap('nerdtree')
	nnoremap <silent> <F2> :call NERDTreeOpen()<CR>
	call neobundle#untap()
endif
" ]]]
"        开关 Tagbar F3 [[[4
if neobundle#tap('tagbar')
	nnoremap <silent> <F3> :TagbarToggle<CR>
	call neobundle#untap()
endif
" ]]]
"        开关 SrcExpl F4 [[[4
if neobundle#tap('SrcExpl')
	nmap <silent> <F4> :SrcExplToggle<CR>
	call neobundle#untap()
endif
" ]]]
"        [Disabled]以下是刷题用的 F4 [[[4
"let s:isopen=0
"function IO()
"	echo s:isopen
"	if s:isopen==0
"		let s:isopen=1
"		rightbelow split a.in
"		rightbelow vsplit a.out	í
"		wincmd h
"	else
"		let s:isopen=0
"		wincmd t
"		only
"	endif
"endfunction
"nmap <F4> :execute IO()<CR>
" ]]]
"        一键编译单个源文件 F5 [[[4
nmap <silent> <F5> :<C-U>UpDate <CR>:call Do_OneFileMake()<CR>
" ]]]
"        一键执行 make 或 make clean 命令 F6/<Ctrl-F6> [[[4
nmap <silent> <F6> :<C-U>call Do_make()<CR>
nmap <silent> <C-F6> :Make clean<CR>
" ]]]
"        开关撤销树 Undotree F8 [[[4
if neobundle#tap('undotree')
	nmap <silent> <F8> :UndotreeToggle<CR>
	call neobundle#untap()
endif
" ]]]
"  a.vim 切换同名 .c/.h 文件 F9 [[[4
" :A  ---切换头文件并独占整个窗口
" :AV ---切换头文件并垂直分割窗口
" :AS ---切换头文件并水平分割窗口
if neobundle#tap('a.vim')
	nnoremap <silent> <F9> :A<CR>
	call neobundle#untap()
endif
" ]]]
"        切换全屏 Vim F11 [[[4
noremap <silent> <F11> :<C-U>call ToggleFullScreen()<cr>
" ]]]
"        Ack 查找光标下词语 <Ctrl-F4> [[[4
if neobundle#tap('ack.vim')
	nnoremap <silent> <C-F4> :Ack<CR>
	call neobundle#untap()
endif
" ]]]
"        脚本运行快捷键 <Ctrl-F5> [[[4
" nmap <F9> :w <CR>:!python %<CR>
nmap <silent> <C-F5> :!./%<<CR>
" ]]]
"        开关 CCTree <Ctrl-F12> [[[4
if neobundle#tap('CCTree')
	function! LoadCCTree()
		if filereadable('cctree.out')
			execute "CCTreeLoadXRefDBFromDisk cctree.out"
		elseif filereadable('cscope.out')
			execute "CCTreeLoadDB cscope.out"
		endif
	endfunction
	nmap <silent> <C-F12> :<C-U>call LoadCCTree()<CR>
	call neobundle#untap()
endif
" ]]]
"        切换 Quickfix <Shift-F12> [[[4
if s:hasCTags
	nmap <silent> <S-F12> :Dispatch ctags -R --c++-kinds=+p --fields=+iaS
				\ --extra=+q .<CR>:UpdateTypesFile<CR>
endif
" ]]]
" ]]]
"      <Leader> 开头 [[[3
"        打开 BufExplorer <Leader>b{e,s,t,v} [[[4
" 快速轻松的在缓存中切换（相当于另一种多个文件间的切换方式）
" 映射          描述
" <Leader>be    在当前窗口显示缓存列表并打开选定文件
" <Leader>bs    水平分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
" <Leader>bt    在当前窗口启用/禁用 BufExplorer
" <Leader>bv    垂直分割窗口显示缓存列表，并在缓存列表窗口中打开选定文件
" ]]]
"        关闭窗口或卸载缓冲区 <Leader>c [[[4
nmap <silent> <Leader>c :<C-U>call CloseWindowOrKillBuffer()<CR>
" ]]]
"        Syntastic 打开错误及警告窗口 <Leader>er [[[4
nmap <silent> <Leader>er :Errors<CR>
" ]]]
"        Vim-JSBeautify 格式化 CSS,HTML,JavaScript <Leader>ff [[[4
if neobundle#tap('vim-jsbeautify')
	augroup Filetype_Specific
		" for css or scss
		autocmd FileType css nnoremap <buffer> <Leader>ff :call CSSBeautify()<CR>
		autocmd FileType css vnoremap <buffer> <Leader>ff :call RangeCSSBeautify()<CR>
		autocmd FileType html nnoremap <buffer> <Leader>ff :call HtmlBeautify()<CR>
		autocmd FileType html vnoremap <buffer> <Leader>ff :call RangeHtmlBeautify()<CR>
		autocmd FileType javascript nnoremap <buffer> <Leader>ff
					\ :call JsBeautify()<CR>
		autocmd FileType javascript vnoremap <buffer> <Leader>ff
					\ :call RangeJsBeautify()<CR>
		autocmd FileType json nnoremap <buffer> <Leader>ff
					\ :call JsonBeautify()<CR>
		autocmd FileType json vnoremap <buffer> <Leader>ff
					\ :call RangeJsonBeautify()<CR>
		autocmd FileType javascript.jsx,jsx nnoremap <buffer> <Leader>ff
					\ :call JsxBeautify()<CR>
		autocmd FileType javascript.jsx,jsx vnoremap <buffer> <Leader>ff
					\ :call RangeJsxBeautify()<CR>
	augroup END
	call neobundle#untap()
endif
" ]]]
"        格式化全文 <Leader>ff [[[4
nmap <silent> <Leader>ff :<C-U>call FullFormat()<CR>
" ]]]
"        开关Fugitive <Leader>g{c,d,r,w} [[[4
if neobundle#tap('vim-fugitive')
	nnoremap <silent> <Leader>gc :Gcommit<CR>
	nnoremap <silent> <Leader>gd :Gdiff<CR>
	nnoremap <silent> <Leader>gr :Gread<CR>:GitGutter<CR>
	nnoremap <silent> <Leader>gw :Gwrite<CR>:GitGutter<CR>
	call neobundle#untap()
endif
" ]]]
"        开关GitGutter <Leader>g{g,l} [[[4
if neobundle#tap('vim-gitgutter')
	nnoremap <silent> <Leader>gg :GitGutterToggle<CR>
	nnoremap <silent> <Leader>gl :GitGutterLineHighlightsToggle<CR>
	call neobundle#untap()
endif
" ]]]
"        开关Gitv <Leader>g{v,V} [[[4
if neobundle#tap('gitv')
	nnoremap <silent> <Leader>gv :Gitv<CR>
	nnoremap <silent> <Leader>gV :Gitv!<CR>
	call neobundle#untap()
endif
" ]]]
"        GitGutter 操作改动块 <Leader>h{p,r,s} [[[4
" 映射          命令                         描述
" <Leader>hp    <Plug>GitGutterPreviewHunk   Preview a hunk's changes
" <Leader>hr    <Plug>GitGutterRevertHunk    Revert the hunk
" <Leader>hs    <Plug>GitGutterStageHunk     Stage the hunk
" ]]]
"        删除打开在 Windows 下的文件里的 ^M <Leader>m [[[4
" use it when the encodings gets messed up
" (以下取自 https://github.com/amix/vimrc )
nnoremap <silent> <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm
" ]]]
"        取消高亮搜索关键字 <Leader>nh [[[4
" 同时取消 vim-mark 插件的高亮关键字
nmap <silent> <Leader>nh :<C-U>nohlsearch<CR>:Mark<CR>
" ]]]
"        切换绝对/相对行号 <Leader>nu [[[4
nnoremap <Leader>nu :<C-U>call <SID>toggle_number()<CR>
" ]]]
"        打开 Vim 配置文件 <Leader>rc [[[4
nmap <silent> <Leader>rc :<C-U>edit $MYVIMRC<CR>
" ]]]
"        Vim-Scratch <Leader>sc [[[4
if neobundle#tap('vim-scratch')
	nnoremap <silent> <Leader>sc :ScratchOpen<CR>
	call neobundle#untap()
endif
" ]]]
"        VimShell <Leader>sh [[[4
if neobundle#tap('vimshell.vim')
	nnoremap <silent> <Leader>sh :VimShell -split<CR>
	call neobundle#untap()
endif
" ]]]
"        [Disabled]Conque-Shell 调出命令行界面 <Leader>sh [[[4
" if s:isWindows
" 	nmap <Leader>sh :ConqueTermVSplit cmd.exe<CR>
" elseif executable('zsh')
" 	nmap <Leader>sh :ConqueTermVSplit zsh<CR>
" elseif executable('bash')
" 	nmap <Leader>sh :ConqueTermVSplit bash<CR>
" else
" 	echo "Fail to invoke shell!"
" endif
" ]]]
"        Splitjoin 打散合并单行语句 <Leader>s{j,s} [[[4
if neobundle#tap('splitjoin.vim')
	"  不使用默认的键映射
	let g:splitjoin_split_mapping = ''
	let g:splitjoin_join_mapping = ''
	nnoremap <silent> <Leader>sj :SplitjoinJoin<CR>
	nnoremap <silent> <Leader>ss :SplitjoinSplit<CR>
	call neobundle#untap()
endif
" ]]]
"        增加 gVim 窗体的透明度 <Leader>ta [[[4
if s:hasVFS
	nmap <silent> <Leader>ta :<C-U>call SetAlpha(-10)<cr>
" ]]]
"        降低 gVim 窗体的透明度 <Leader>tx [[[4
	nmap <silent> <Leader>tx :<C-U>call SetAlpha(10)<cr>
endif
" ]]]
"        ShowTrailingWhitespace 开关显示尾部多余空格 <Leader>tr [[[4
if neobundle#tap('ShowTrailingWhitespace')
	nnoremap <silent> <Leader>tr
				\ :<C-U>call ShowTrailingWhitespace#Toggle(0)<Bar>echo
				\ (ShowTrailingWhitespace#IsSet() ? 'Show trailing whitespace'
				\ : 'Not showing trailing whitespace')<CR>
	call neobundle#untap()
endif
" ]]]
"        切换高亮光标所在的屏幕列 <Leader>uc [[[4
nnoremap <silent> <Leader>uc :<C-U>call ToggleOption('cursorcolumn')<CR>
" ]]]
"        打开光标下的链接 <Leader>ur [[[4
" (以下取自 https://github.com/lilydjwg/dotvim )
nmap <silent> <Leader>ur :call OpenURL()<CR>
" ]]]
"        水平或垂直分割窗口 <Leader>{vs,sp} [[[4
nnoremap <silent> <Leader>vs <C-w>v<C-w>l
nnoremap <silent> <Leader>sp <C-w>s
" ]]]
"        切换自动换行 <Leader>wr [[[4
nnoremap <silent> <Leader>wr :<C-U>call ToggleOption('wrap')<CR>
" ]]]
"        切换到 tabline 上该序号的缓冲区 <Leader>{1~9} [[[4
" (以下取自 https://github.com/bling/dotvim )
nmap <Leader>1 <Plug>AirlineSelectTab1
nmap <Leader>2 <Plug>AirlineSelectTab2
nmap <Leader>3 <Plug>AirlineSelectTab3
nmap <Leader>4 <Plug>AirlineSelectTab4
nmap <Leader>5 <Plug>AirlineSelectTab5
nmap <Leader>6 <Plug>AirlineSelectTab6
nmap <Leader>7 <Plug>AirlineSelectTab7
nmap <Leader>8 <Plug>AirlineSelectTab8
nmap <Leader>9 <Plug>AirlineSelectTab9
" ]]]
"        %xx -> 对应的字符(到消息) <Leader>% [[[4
" (以下取自 https://github.com/lilydjwg/dotvim )
nmap <silent> <Leader>% :call GetHexChar()<CR>
" ]]]
" ]]]
"      Ctrl/Alt 组合键 [[[3
"        [Disabled]开关CtrlP <Alt-{m,n}> [[[4
" nmap <M-m> :CtrlPMRU<CR>
" nmap <M-n> :CtrlPBuffer<CR>
" ]]]
"        切换 gVim 是否在最前面显示 <Alt-R> [[[4
if s:hasVFS
	nmap <silent> <M-r> :<C-U>call SwitchVimTopMostMode()<cr>
endif
" ]]]
"        切换左右缓冲区 <Alt-左右方向键> [[[4
nnoremap <silent> <M-left> :<C-U>call SwitchBuffer(0)<CR>
nnoremap <silent> <M-right> :<C-U>call SwitchBuffer(1)<CR>
" ]]]
"        窗口分割时重映射为 <Ctrl-{h,j,k,l}>，切换的时候会变得非常方便 [[[4
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
" ]]]
" ]]]
"      其它开头的 [[[3
"        Surround 快捷键 cS/ds/gS/vs/ys [[[4
"          示例 [[[5
"   Old text                  Command     New text
"
"   "Hello *world!"           ds"         Hello world!
"   (123+4*56)/2              ds)         123+456/2
"   <div>Yo!*</div>           dst         Yo!
"
"   "Hello *world!"           cS"'        'Hello world!'
"   "Hello *world!"           cS"<q>      <q>Hello world!</q>
"   (123+4*56)/2              cS)]        [123+456]/2
"   (123+4*56)/2              cS)[        [ 123+456 ]/2
"   <div>Yo!*</div>           cSt<p>      <p>Yo!</p>
"   [123+4*56]/2              cS])        (123+456)/2
"   "Look ma, I'm *HTML!"     cS"<q>      <q>Look ma, I'm HTML!</q>
"
"   if *x>3 {                 ysW(        if ( x>3 ) {
"   Hello w*orld!             ysiw)       Hello (world)!
"
" As a special case, *yss* operates on the current line, ignoring leading
" whitespace.
"       Hello w*orld!         yssB            {Hello world!}
"
"   my $str = *whee!;         vlllls'     my $str = 'whee!';
"
" 注：原 cs 和 cscope 的冲突了，更改为 cS
" ]]]
"          键映射 [[[5
" (以下取自 https://github.com/lilydjwg/dotvim )
if neobundle#tap('vim-surround')
	let g:surround_no_mappings = 1
	" original
	nmap ds  <Plug>Dsurround
	nmap ys  <Plug>Ysurround
	nmap yS  <Plug>YSurround
	nmap yss <Plug>Yssurround
	nmap ySs <Plug>YSsurround
	nmap ySS <Plug>YSsurround
	xmap S   <Plug>VSurround
	xmap gS  <Plug>VgSurround
	imap <C-G>s <Plug>Isurround
	imap <C-G>S <Plug>ISurround
	" mine
	" 比起 c，我更喜欢用 s
	xmap c <Plug>Vsurround
	xmap C <Plug>VSurround
	" cs is for cscope
	nmap cS <Plug>Csurround
	call neobundle#untap()
endif
" ]]]
" ]]]
"        accelerated-jk 连续按 j/k 时加速移动光标 [[[4
if neobundle#tap('accelerated-jk')
	nmap <silent> j <Plug>(accelerated_jk_gj)
	nmap gj j
	nmap <silent> k <Plug>(accelerated_jk_gk)
	nmap gk k
	call neobundle#untap()
endif
" ]]]
"        使用 n/N/g*/g#/Ctrl-o/Ctrl-i 时自动居中 [[[4
nnoremap <silent> n nzvzz
nnoremap <silent> N Nzvzz
nnoremap <silent> g* g*zvzz
nnoremap <silent> g# g#zvzz
nnoremap <silent> <C-o> <C-o>zvzz
nnoremap <silent> <C-i> <C-i>zvzz
" ]]]
"        将 Y 映射为复制到行尾 [[[4
nnoremap <silent> Y y$
" ]]]
"        折叠 [[[4
" 折叠相关的快捷键
" zR 打开所有的折叠
" za Open/Close (toggle) a folded group of lines.
" zA Open a Closed fold or close and open fold recursively.
" zi 全部 展开/关闭 折叠
" zo 打开 (open) 在光标下的折叠
" zc 关闭 (close) 在光标下的折叠
" zC 循环关闭 (Close) 在光标下的所有折叠
" zM 关闭所有可折叠区域
" ]]]
"        用空格键来开关折叠  [[[4
nnoremap <silent> <Space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
" ]]]
"        GitGutter 跳转到改动块 ]c [c [[[4
" 映射       命令                           描述
" ]c         <Plug>GitGutterNextHunk        jump to next hunk (change)
" [c         <Plug>GitGutterPreviewHunk     jump to previous hunk (change)
" ]]]
"        ConflictMotions 快捷键 ]{x,X} [{x,X} [[[4
" 映射                    描述
" ]x                      Go to [count] next start of a conflict.
" ]X                      Go to [count] next end of a conflict.
" [x                      Go to [count] previous start of a conflict.
" [X                      Go to [count] previous end of a conflict.
"
" ]=                      Go to [count] next conflict marker.
" [=                      Go to [count] previous conflict marker.
"                         Mnemonic: = is in the separator between our and their
"                         changes.
"
" ax                      "a conflict" text object, select [count] conflicts,
"                         including the conflict markers.
"
" a=                      "a conflict section" text object, select [count]
"                         sections (i.e. either ours, theirs, or base) including
"                         the conflict marker above, and in the case of "theirs"
"                         changes, also the ending conflict marker below.
"
" i=                      "inner conflict section" text object, select current
"                         section (i.e. either ours, theirs, or base) without
"                         the surrounding conflict markers.
"
" :ConflictTake           From the conflict the cursor is in, remove the markers
"                         and keep the section the cursor is inside.
" :ConflictTake [none this ours base theirs both all query] [...]
" :ConflictTake [-.<|>+*?][...]
"                         From the conflict the cursor is in, remove the markers
"                         and keep the passed section(s) (in the order they are
"                         specified).
"                             none, - = delete the entire conflict
"                             both    = ours theirs               (+ = <>)
"                             all     = ours [base] theirs        (* = <|>)
"                             query   = ask which sections to take
" :[range]ConflictTake [none this ours base theirs both all range query] [...]
" :[range]ConflictTake [-.<|>+*:?][...]
"                         When the cursor is inside a conflict, and the [range]
"                         covers part of that conflict:
"                         From the conflict the cursor is in, remove the markers
"                         and keep the passed range (without contained markers)
"                         (and any passed sections in addition; include the
"                         "range" argument to put the range somewhere other than
"                         the end).
"                         Otherwise, when a large range (like %) is passed:
"                         For each conflict that starts in [range], remove the
"                         markers and keep the passed section(s) / ask which
"                         section(s) should be kept. You can answer the question
"                         with either the symbol or the choice's starting
"                         letter. An uppercase letter will apply the choice to
"                         all following conflicts.
"
" <Leader>xd              Delete the entire current conflict.
" <Leader>x.              Keep the current conflict section, delete the rest.
" <Leader>x<              Keep our changes, delete the rest.
" <Leader>x|              Keep the change base, delete the rest.
" <Leader>x>              Keep their changes, delete the rest."
" ]]]
"        切换当前缓冲区修改选项 -= [[[4
nnoremap <silent> -= :<C-U>call ToggleOption('modified')<CR>
" ]]]
" ]]]
" ]]]
"    可视模式映射 vmap [[[2
"      使用 < 或 > 缩进后继续选定 [[[3
vnoremap <silent> < <gv
vnoremap <silent> > >gv
" ]]]
"      允许在选择模式下按 . 重复执行操作 [[[3
snoremap <silent> . :normal .<CR>
" ]]]
" ]]]
"    多种映射 map [[[2
"      SudoEdit.vim 保存文件 <Alt-S> [[[3
if neobundle#tap('SudoEdit.vim')
	nnoremap <silent> <M-s> :<C-U>SudoUpDate<CR>
	inoremap <silent> <M-s> <C-O>:SudoUpDate<CR><CR>
	vnoremap <silent> <M-s> <C-C>:SudoUpDate<CR>
	call neobundle#untap()
endif
" ]]]
"      [Disabled]上下移动一行文字 <Ctrl-{h,j,k,l}> [[[3
"nmap <C-j> mz:m+<cr>`z
"nmap <C-k> mz:m-2<cr>`z
"vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
" ]]]
"      保存文件 <Ctrl-S> [[[3
nnoremap <silent> <C-S> :<C-U>UpDate<CR>
inoremap <silent> <C-S> <C-O>:UpDate<CR><CR>
vnoremap <silent> <C-S> <C-C>:UpDate<CR>
" ]]]
"      水平方向滚动 <Shift+鼠标滚动> [[[3
" (以下取自 https://github.com/lilydjwg/dotvim )
if v:version < 703
	nmap <silent> <S-MouseDown> zhzhzh
	nmap <silent> <S-MouseUp> zlzlzl
	vmap <silent> <S-MouseDown> zhzhzh
	vmap <silent> <S-MouseUp> zlzlzl
else
	map <silent> <S-ScrollWheelDown> <ScrollWheelRight>
	map <silent> <S-ScrollWheelUp> <ScrollWheelLeft>
	imap <silent> <S-ScrollWheelDown> <ScrollWheelRight>
	imap <silent> <S-ScrollWheelUp> <ScrollWheelLeft>
endif
" ]]]
"      Tabularize 代码对齐工具 <Leader>a{&,=,:,,} [[[3
if neobundle#tap('tabular')
	nmap <silent> <Leader>a& :Tabularize /&<CR>
	vmap <silent> <Leader>a& :Tabularize /&<CR>
	nmap <silent> <Leader>a= :Tabularize /=<CR>
	vmap <silent> <Leader>a= :Tabularize /=<CR>
	nmap <silent> <Leader>a: :Tabularize /:<CR>
	vmap <silent> <Leader>a: :Tabularize /:<CR>
	nmap <silent> <Leader>a:: :Tabularize /:\zs<CR>
	vmap <silent> <Leader>a:: :Tabularize /:\zs<CR>
	nmap <silent> <Leader>a, :Tabularize /,<CR>
	vmap <silent> <Leader>a, :Tabularize /,<CR>
	nmap <silent> <Leader>a,, :Tabularize /,\zs<CR>
	vmap <silent> <Leader>a,, :Tabularize /,\zs<CR>
	nmap <silent> <Leader>a<Bar> :Tabularize /<Bar><CR>
	vmap <silent> <Leader>a<Bar> :Tabularize /<Bar><CR>
	" 只对齐第一个 , 或 :
	nmap <silent> <Leader>af, :Tabularize /^[^,]*\zs,/<CR>
	vmap <silent> <Leader>af, :Tabularize /^[^,]*\zs,/<CR>
	nmap <silent> <Leader>af: :Tabularize /^[^:]*\zs:/<CR>
	vmap <silent> <Leader>af: :Tabularize /^[^:]*\zs:/<CR>
	call neobundle#untap()
endif
" ]]]
"      mark.vim 给各种 tags 标记不同的颜色 <Leader>h{h,l,x} [[[3
" (以下取自 http://easwy.com/blog/archives/advanced-vim-skills-syntax-on-colorscheme/ )
" 当我输入“,hl”时，就会把光标下的单词高亮，在此单词上按“,hh”会清除该单词的高亮。
" 如果在高亮单词外输入“,hh”，会清除所有的高亮。
" 你也可以使用virsual模式选中一段文本，然后按“,hl”，会高亮你所选中的文本；或者
" 你可以用“,hx”来输入一个正则表达式，这会高亮所有符合这个正则表达式的文本。
"
" 你可以在高亮文本上使用“,#”或“,*”来上下搜索高亮文本。在使用了“,#”或“,*”后，就
" 可以直接输入“#”或“*”来继续查找该高亮文本，直到你又用“#”或“*”查找了其它文本。
" <Leader>* 当前MarkWord的下一个     <Leader># 当前MarkWord的上一个
" <Leader>/ 所有MarkWords的下一个    <Leader>? 所有MarkWords的上一个
if neobundle#tap('vim-mark')
	"    */# 时自动居中 [[[4
	" MarkSearchNext/MarkSearchPrev 映射内部已经包含了 zv，所以无须在后面
	" 再执行一次 zv
	augroup MyAutoCmd
		autocmd VimEnter * nmap <silent> * <Plug>MarkSearchNext<Esc>zz
		autocmd VimEnter * nmap <silent> # <Plug>MarkSearchPrev<Esc>zz
	augroup END
	" ]]]
	nmap <silent> <Leader>hl <Plug>MarkSet
	vmap <silent> <Leader>hl <Plug>MarkSet
	nmap <silent> <Leader>hh <Plug>MarkClear
	vmap <silent> <Leader>hh <Plug>MarkClear
	nmap <silent> <Leader>hx <Plug>MarkRegex
	vmap <silent> <Leader>hx <Plug>MarkRegex
	nmap <silent> <Leader>* <Plug>MarkSearchCurrentNext<Esc>zz
	nmap <silent> <Leader># <Plug>MarkSearchCurrentPrev<Esc>zz
	nmap <silent> <Leader>/ <Plug>MarkSearchAnyNext<Esc>zz
	nmap <silent> <Leader>? <Plug>MarkSearchAnyPrev<Esc>zz
	call neobundle#untap()
endif
" ]]]
"      粘贴系统剪贴板内容(即+、*寄存器) <Leader>{P,p} <鼠标中键> [[[3
if has('clipboard')
	if has ('unnamedplus')
		nnoremap <silent> <Leader>P "+P
		nnoremap <silent> <Leader>p "+p
		nnoremap <silent> <MiddleMouse> "+P
		inoremap <silent> <MiddleMouse> <C-R>+
	else
		nnoremap <silent> <Leader>P "*P
		nnoremap <silent> <Leader>p "*p
		nnoremap <silent> <MiddleMouse> "*P
		inoremap <silent> <MiddleMouse> <C-R>*
	endif
endif
" ]]]
"      去掉行末空格 <Leader><Space> [[[3
if neobundle#tap('DeleteTrailingWhitespace')
	nnoremap <silent> <Leader><Space> :<C-U>%DeleteTrailingWhitespace<CR>
	vnoremap <silent> <Leader><Space> :DeleteTrailingWhitespace<CR>
	call neobundle#untap()
endif
" ]]]
"      MatchIt 对%命令进行扩展使得能在嵌套标签和语句之间跳转 % g% [% ]% [[[3
" 映射     描述
" %        正向匹配
" g%       反向匹配
" [%       定位块首
" ]%       定位块尾
" ]]]
" ]]]
" ]]]
"  加载 Vim 配置文件时让一些设置不再执行 [[[1
"  并记录加载 Vim 配置文件的次数
if !exists("g:VimrcIsLoad")
	let g:VimrcIsLoad = 1
else
	let g:VimrcIsLoad = g:VimrcIsLoad + 1
endif
" ]]]
"  Vim Modeline: [[[1
" vim:fdm=marker:fmr=[[[,]]]
" ]]]
