"Script_name: txt.vim
"Maintainer: Yongping Guo
"Mail: guoyoooping@163.com
"Description: syntax for plain/text.
"Where_to_patch: $HOME/.vim/syntax or $VIMRUNTIME/syntax/
"Date: 2009-12-27
"Language: plain/text :)
"Install_detail:
        "1. put this file in $HOME/.vim/syntax or $VIMRUNTIME/syntax/
        "2. Add the following line in your .vimrc:
        "au BufRead,BufNewFile *.txt setlocal ft=txt
"Version: 1.0.1
"ChangeLog:
        "v1.0: Initial upload
        "v1.0.1: delete the personal configuration in txt.vim, it might not be
        "fit for everyone.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pre set.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn clear
syn case ignore
"(2010年 04月 28日 星期三 16:40:42 CST)
"#=============================================================================
"hi clear Normal
"#============================================================================
"colo default "desert
"set bg&
"set guifont=Monospace\ 11"set the gui font. 新宋体:h8:cGB2312"
"set linespace=5"row space.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key words definition.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Keywords
syn keyword txtTodo todo fixme note debug comment notice analysis solution question 注意 分析 seealso Validate
syn keyword txtError error bug caution dropped

"txtTitle: Lines start with digit and '.'
"标题文本: 前面有任意个空格,数字.[数字.]打头, 并且该行里不含有,.。，等标点符号
syn match txtTitle "^\(\d\+\.\)\+\s*[^,。，]\+$"

"txtTitle: Lines start with Chinese digit and '.'
"标题文本: 汉字数字加'.、'打头，且该行不含,.。，标点符号
syn match txtTitle "^\([一二三四五六七八九十][、.]\)\+\s*[^,。，]\+$"

"txtTitle: Lines start with digit
"标题文本: 以数字打头, 中间有空格, 后跟任意文字. 且该行不含有,.。，标点符号
syn match txtTitle "^Chapter \d\.\s\+.\+\s*[^,。，]$"
syn match txtTitle "^\d\s\+.\+\s*[^,。，]$"

"txtList: Lines start with space and then '-+*.'
"列表文本: 任意空格打头, 后跟一个[-+*.]
syn match txtList    '^\s*[-+*.] \+'me=e
syn match txtList    '^\s*\* Chapter \d\.'me=e

"txtList: Lines start with space and then digit
"列表文本: 任意空格打头, 后跟一个(数字) 或 (字母) 打头的文本行
syn match txtList    '^\s*(\=\([0-9]\+\|[a-zA-Z]\))'

"txtList: Lines start with space and then digit and '.'
"列表文本: 至少一个空格打头, [数字.]打头, 但随后不能跟数字(排除把5.5这样的文
"本当成列表)
syn match txtList "^\s\+\d\+\.\d\@!"

"txtApostrophe: text in the apostrophe
"单引号内文字
syn match   txtApostrophe  '\'[^\']\+\''hs=s+1,he=e-1

"txtQuotes: text in the quotoes
"双引号内文字, 包括全角半角, 作用范围最多两行
syn match   txtQuotes     '["“][^"”]\+\(\n\)\=[^"”]*["”]'hs=s+1,he=e-1

"txtParentesis: text in the parentesis
"括号内文字, 不在行首(为了和txtList区别), 作用范围最多两行
syn match   txtParentesis "[(（][^)）]\+\(\n\)\=[^)）]*[)）]" contains=txtUrl

"txtBrackets: text in the brackets
"其它括号内文字, 作用范围最多两行, 大括号无行数限制
syn match txtBrackets     '<[^<]\+\(\n\)\=[^<]*>'hs=s+1,he=e-1 contains=txtUrl
syn match txtBrackets     '\[[^\[]\+\(\n\)\=[^\[]*\]'hs=s+1,he=e-1 contains=txtUrl
syn region txtBrackets    matchgroup=txtOperator start="{"        end="}" contains=txtUrl

"link url
syn match txtUrl '\<[A-Za-z0-9_.-]\+@\([A-Za-z0-9_-]\+\.\)\+[A-Za-z]\{2,4}\>\(?[A-Za-z0-9%&=+.,@*_-]\+\)\='
syn match txtUrl   '\<\(\(https\=\|file\|ftp\|news\|telnet\|gopher\|wais\)://\([A-Za-z0-9._-]\+\(:[^ @]*\)\=@\)\=\|\(www[23]\=\.\|ftp\.\)\)[A-Za-z0-9%._/~:,=$@-]\+\>/*\(?[A-Za-z0-9/%&=+.,@*_-]\+\)\=\(#[A-Za-z0-9%._-]\+\)\='

"email text:
syn match txtEmailMsg '^\s*\(From\|De\|Sent\|To\|Para\|Date\|Data\|Assunto\|Subject\):.*'
syn match txtEmailQuote '^\(>\($\| \)\)\+'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"类html文本
"syn match   txtBold       '\*[^*[:blank:]].\{-}\*'hs=s+1,he=e-1
"syn match txtItalic "^\s\+.\+$" "斜体文本

"(2010年 05月 01日 星期六 11:28:29 CST) "(2010年 05月 03日 星期一 19:34:15 CST)
"#=============================================================================
" `...`
syn match  cmdLine "[`][^`]\+\(\n\)\=[^`]*[`]" contains=txtUrl
"命令行
syn match  cmdLine '^[	 ]*\[.*\][#\$] .*$'
syn match  cmdLine '^\$ .*$'
syn match  cmdLine '^[ 	]*sh[#\$] .*$'
"syn match  cmdLine2 '^[	 ]*:.*$'

syn match  tables '^[ \t]*表[ \t]*[0-9a-zA-Z]*[-.: ][ \t]*.*$'

"命令输出
"syn match cmdOut    "^[	 ]*\\\@<!|[^"*|]\+|" contains=cmdOutBar
"syn match cmdOutBar contained "|"
syn region cmdOut    matchgroup=txtOperator start="|&"        end="&|"        contains=txtUrl
syn region cmdOut2   matchgroup=txtOperator start="<code>"    end="</code>"   contains=txtUrl
syn region cmdOut3   matchgroup=txtOperator start="<cmdout>"  end="</cmdout>" contains=txtUrl

"书名号《》内文字, 不在行首(为了和txtList区别)
syn match   txtBookParentesis "《.*》" contains=txtUrl
syn match   txtBookParentesis2 "<<.*>>" contains=txtUrl

"在(^ ^)内的为注释文本
syn match  txtComment  "(\^.*\^)"
syn match  txtComment2 '^#.*$'   contains=txtTodo
syn match  txtComment3 '\/\/.*$' contains=txtTodo
syn region txtComment4 matchgroup=txtOperator start="[ 	][ 	]*\/\*" end="\*\/" contains=txtTodo
"#============================================================================

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color definitions (specific)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"hi txtUrl        term=bold        cterm=bold  ctermfg=blue    gui=underline     guifg=red
hi link txtUrl      Underlined"ModeMsg"Tabline"PmenuSbar
hi link txtTitle      Title"ModeMsg"Tabline"PmenuSbar
hi link txtList         SignColumn"Pmenu"DiffText"Statement
hi link txtQuotes       MoreMsg"String
hi link txtApostrophe    WarningMsg"Special
hi link txtParentesis   String"Special "Comment
hi link txtBrackets  Function"Special
hi link txtError  ErrorMsg
hi link txtTodo  Todo
hi link txtEmailMsg     PmenuSbar
hi link txtEmailQuote   Structure
hi link tables   MoreMsg"String
"(2010年 05月 01日 星期六 12:09:56 CST)
"#=============================================================================
hi link txtComment     comment
hi link txtComment2    Comment
hi link txtComment3    Comment
hi link txtComment4    Comment
hi link cmdLine  Keyword
"hi link cmdLine2  Keyword
hi def link cmdOut LineNr
hi def link cmdOut2 LineNr
hi def link cmdOut3 LineNr
hi def link cmdOutBar Ignore
hi def link txtBookParentesis Macro
hi def link txtBookParentesis2 Macro
"#============================================================================

"set background=dark
let b:current_syntax = 'txt'
" vim:tw=0:et
