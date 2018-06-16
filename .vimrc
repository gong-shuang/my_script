" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" 这条命令的意思是让vim不要和vi一个德行。vim本身是vi的增强版，默认情况下vim行
" 为和vi保持一致，这意味着很多vim的强大特性是无效的，这条命令将释放出一个真正
" 强大的vim出来
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" vim默认情况下的回删行为相当不人性，遇到缩进或者在行
" 首无效。这样设定的结果令vim中回删的行为和一般的编辑
" 器没有区别, 使退格键（backspace）正常处理indent, 
" eol, start等
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

"这两条加起来是要求vim不生成备份文件和临时文件。我的文档有其他的
"备份途径，不太操心丢失的问题，这里觉得烦就一关了事
set nobackup
set noswapfile

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

"可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=v
endif


" 语法高亮,实际上调用的是 ~/.vim/syntax/c.vim 脚本
" ":syntax on"会覆盖已有的颜色，而 ":syntax enable" 只会设置没有设置过的组
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  "作用是打开vim时光标回到上次退出时的位置。这是个非常有用的特性，
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


"autoload _vimrc
autocmd! bufwritepost $HOME/.vimrc source %

"=========================================================================
"                   <<<<<<<<<<< 帮助文档 >>>>>>>>>>>>>>
" ctags的帮助文档 :help usr_29
" 语法高亮,即syntax的帮助文档 :help syntax.txt
" taglist插件  :help taglist.txt
" cscope插件   :help if_cscop.txt
" quickfix插件  :help quickfix
" MiniBufExplorer插件  :help buffer
" grep插件  :help grep
" 全能补全插件 :help new-omni-completion
" SuperTab插件 :help supertab, 或命令 ':SuperTabHelp'
"
"=========================================================================




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   syntax 语法高亮
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 选择配置方案,会调用.vim/colors/里面的文件
" colorscheme mine
" colorscheme solarized
            
" 设置背景颜色
" set background=light
" set background=dark


    hi Normal guibg=#99ccff guifg=Black  ctermbg=darkblue ctermfg=grey 
    hi LineNr guibg=#003366 guifg=#99ccff ctermbg=7777 ctermfg=blue  
    set cursorline  
    hi CursorLine cterm=bold ctermbg=Black ctermfg=white guibg=#66cc99 guifg=black 

":set syntax=c



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Tab键 和 缩进
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"将tab替换为空格
nmap tt :%s/\t/    /g<CR

" 使用空格代替制表符
set expandtab

" 统一缩进为4
set softtabstop=4
set shiftwidth=4    "缩进使用4个空格的宽度
set tabstop=4       "TAB的宽度被设置为4个空格。


"在行首时插入shiftwidth规定的空格数，其他地方则插入tabstop规定的空格数
set smarttab

" 自动缩进
set autoindent
"set noautoindent  "不自动缩进 

"smartindent 在这种缩进模式中，每一行都和前一行有相同的缩进量
set smartindent 

"可以在Normal Mode和Visual/Select Mode下，利用Tab键和Shift-Tab键来缩进文本
nmap <tab> V>
nmap <s-tab> V<
vmap <tab> >gv
vmap <s-tab> <gv




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Ctrl 快捷键
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"共享剪贴板(后面复制/粘贴操作的前提)
set clipboard+=unnamed

"复制全文
"ggVG 选中全部的文本， 其中gg为跳到行首，V选中整行，G末尾, +y 复制到系统剪贴板(也就是vim的+寄存器)
map <C-A> ggVG$"+y    

"选中状态下 Ctrl+c 复制 / Ctrl-v 粘贴
map <C-v>  *pa
imap <C-v> <Esc>*pa
vmap <C-c> "+y

"无论是 normal模式 / insert模式，按 Crtl+s 保存文件
map <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>


"在插入模式下快速进行行首/行尾跳转
imap <C-a> <Esc>^
imap <C-e> <Esc>$


"这一套映射简化了在分屏的不同窗口中移动光标的动作。分屏的所有
"操作都需要同时按下Ctrl和w键再配合其他按键，对我来说难度太大了
nmap <C-k> <C-w>j
nmap <C-j> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""   显示
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" 光标 十字架 
"set cursorline      " 高亮光标所在的屏幕行
"set cursorcolumn    " 高亮光标所在的屏幕列

" 状态行显示的内容
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} 
" 总是显示状态行
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  
" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2


" 显示行号
set number


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""   配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (1) 搜索 
"设定了hlsearch后,会高亮匹配到的结果
set hlsearch
"在nromal模式下键入/或?进入搜索模式，设定了incsearch后会实时匹配
set incsearch
"这条命令把normal模式下的回车键映射到nohlsearch上，具体的效果是你
"搜索完毕后按以下回车回到normal模式，再按以下回车高亮就没了
"nnoremap <CR> :nohlsearch<cr>
"搜索忽略大小写
set ignorecase
"输入大写字母时会严格匹配，输入小写时配合上一条也可以匹配大写
set smartcase


" (2) 允许backspace和光标键跨越行边界,即自动折断,另起一行显示
set whichwrap+=<,>,h,l   
set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  

" (3) 语法折叠
set foldenable          " 允许折叠  
set foldmethod=syntax
set foldcolumn=0        " 设置折叠区域的宽度
set foldlevel=100
" 用空格键来开关折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" (4) quickfix窗口
" 在窗口下面有一个显示查询结果的窗口,这个窗口中列出了查询命令的查询结果, 用户可以
" 从这个窗口中选择每个结果进行查看, 这个窗口叫"QuickFix"窗口, 已是vim标准组件
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>

" (5) 自动补全
filetype plugin indent on     "打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu  "关掉智能补全时的预览窗口
" 在插入模式下,将光标放在'->'符号后面, 按下"Ctrl+X Ctrl+O", 此时会弹出一个下列菜单, 显示所有匹配的标签,

" (6) help doc 
" gs add 2016-1-4 set vim chinese, VIM中文帮助文档
set helplang=cn
" vim不要自动添加新的注释行
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" 设置当文件被改动时自动载入
set autoread



 """"""""""""""""""""""支持中文 gbk
set fileencodings=utf-8,gb2312,gbk,gb18030                                  
set termencoding=utf-8




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  新文件标题
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,Makefile,*.py,*.java exec ":call SetTitle()" 

func! SetComment()  
    call setline(1, "/*************************************************************************") 
    call append(line("."), "	> File Name: ".expand("%")) 
    call append(line(".")+1, "	> Author: gongshuang") 
    call append(line(".")+2, "	> Mail: baidng@163.com") 
    call append(line(".")+3, "	> Created Time: ".strftime("%Y-%m-%d %H:%M:%S")) 
    call append(line(".")+4, " ************************************************************************/") 
    call append(line(".")+5, "")
endfunc

func! SetComment_sh(line) 
    let ss = a:line  
    call setline(ss, "#########################################################################") 
    call setline(ss+1, "#  > File Name: ".expand("%")) 
    call setline(ss+2, "#  > Author: gongshuang") 
    call setline(ss+3, "#	> Mail: baidng@163.com") 
    call setline(ss+4, "#	> Created Time: ".strftime("%Y-%m-%d %H:%M:%S")) 
    call setline(ss+5, "#########################################################################") 
    call setline(ss+6, "")
endfunc


"定义函数SetTitle，自动插入文件头 
func! SetTitle() 
    if expand("%") == 'Makefile'   
        call SetComment_sh(1)  
    elseif expand("%:e") == 'sh'   
        call setline(1,"#!/bin/bash")   
        call setline(2,"")  
        call SetComment_sh(3)  
    elseif expand("%:e") == 'cpp'
        call SetComment()  
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    elseif expand("%:e") == 'c'
        call SetComment()  
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
    elseif expand("%:e") == 'h'
        call SetComment()  
        call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
        call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
        call append(line(".")+8, "#endif")
    elseif expand("%:e") == 'py'
        call SetComment_sh(1)  
    endif
    "新建文件后，自动定位到文件末尾
endfunc
autocmd BufNewFile * normal G


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C，C++ 按  F10 编译运行
"            Ctrl + F10 调试
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F10> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
"        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc
"C,C++的调试
map <C-F10> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码格式化 ---------> Ctrl + F9
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-F9> :call FormartSrc()<CR><CR>

"定义FormartSrc()
func! FormartSrc()
    exec "w"
    if &filetype == 'c'
        exec "!astyle --style=ansi -a --suffix=none %"
    elseif &filetype == 'cpp' || &filetype == 'hpp'
        exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
    elseif &filetype == 'perl'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'py'||&filetype == 'python'
        exec "r !autopep8 -i --aggressive %"
    elseif &filetype == 'java'
        exec "!astyle --style=java --suffix=none %"
    elseif &filetype == 'jsp'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'xml'
        exec "!astyle --style=gnu --suffix=none %"
    else
        exec "normal gg=G"
        return
    endif
    exec "e! %"
endfunc
"结束定义FormartSrc


"字典设置, 字典是用来补全的
au FileType php setlocal dict+=~/.vim/dict/php_funclist.dict
au FileType css setlocal dict+=~/.vim/dict/css.dicmZ
au FileType c setlocal dict+=~/.vim/dict/c.dict
au FileType cpp setlocal dict+=~/.vim/dict/cpp.dict
au FileType scale setlocal dict+=~/.vim/dict/scale.dict
au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
au FileType html setlocal dict+=~/.vim/dict/javascript.dmZ



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件管理 Vundle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
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

" 可以通过以下几种方式指定插件的来源 
" a) Github网站上非vim-scripts仓库的插件，使用“用户名/插件名称”的方式指定 
" plugin on GitHub repo  
"Plugin 'tpope/vim-fugitive'

" b) vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。
" plugin from http://vim-scripts.org/vim/scripts.html  
"Plugin 'L9'

" c) 指定非Github的Git仓库的插件，需要使用git地址 
" Git plugin not hosted on GitHub  
"Plugin 'git://git.wincent.com/command-t.git'

" d) 指定本地Git仓库中的插件 
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'

" e) 指定一个在目录内的仓库，用来存放vim插件
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" f) 重名的插件，用name重新命名
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

"我的插件
"Bundle 'Yggdroot/indentLine'
"let g:indentLine_char = '┊'

" 语法错误检查
Bundle 'scrooloose/syntastic'

" 文件列表
Bundle 'scrooloose/nerdtree' 

"使用模糊匹配搜索/打开文件，非常好用，强烈推荐
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky'

"智能补全
" Bundle 'Valloric/YouCompleteMe'

"查找, F7
Plugin 'vim-scripts/grep.vim'

"function list, F4 
Bundle 'taglist.vim'


" :A<CR>   .c -> .h
Bundle 'a.vim'

"高亮 /m /n
Bundle 'mbriggs/mark.vim'





" All of your Plugins must be added before the following line
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


"""""""""""""""""""""""""""""""""""""""
" (0) a.vim 
"""""""""""""""""""""""""""""""""""""""
" 在vim下输入 ：A 跳转到同名的 .h 头文件之中

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (1) ctags 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 打开文件时，自动 cd 到文件所在目录
set autochdir   
" 让vim在每次启动的时候自动找到这tags了
set tags+=tags;
" 将c语言的头文件加进去
" 需要在串口下执行这个命令：
" ctags -R --c++-kinds=+px --fields=+aiKzn --extra=+q --if0=yes -f ~/.vim/systags /usr/include/
set tags+=~/.vim/systags

"更新ctags，找寻父文件夹原有tags文件
function! UpdateCtags()
    let curdir=getcwd()
    while !filereadable("./tags")
        cd ..
        if getcwd() == "/"
            break
        endif
    endwhile
    echo getcwd()
    if filewritable("./tags")
        "!ctags -R --c++-types=+px --excmd=pattern --exclude=Makefile --exclude=.
        !ctags -R  --c++-kinds=+px --fields=+aiKzn --extra=+q --if0=yes
        TlistUpdate
    endif
    execute ":cd " . curdir
endfunction

"映射键盘上的F12对应更新tags
map <F12> :call UpdateCtags()<CR>

"也可以在vim保存文件时自动更新：
"silent autocmd BufWritePost *.c,*.h call UpdateCtags()

"""""""""""""""""""""""""""""""""""""""""""""
" (2) NERDTree  ----->F3
"""""""""""""""""""""""""""""""""""""""""""""
"NERDTree的作用就是列出当前路径的目录树，一般
"IDE都是有的。可以方便的浏览项目的总体的目录
"结构和创建删除重命名文件或文件名
"""""""""""""""""""""""""""""""""""""""""""""
"列出当前目录文件  
map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC> :NERDTreeToggle<CR>
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
" 只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (3) TagList  --->  F4 显示变量
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <F4> <ESC>:Tlist<RETURN>
"let Tlist_Sort_Type = "name"    " 按照名称排序,or先后顺序排序
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  "如果taglist窗口是最后一个窗口时,退出VIM
"let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags  
"let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_WinWidth=30        "设置taglist宽度
"let Tlist_Auto_Open=1        "启动VIM后，自动打开taglist窗口



"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (4) cscope   ---> Ctrl+F5 : 查找本 C 符号
"                   Ctrl+F6 : 查找本定义
"                   Ctrl+F7 : 查找调用本函数的函数
"                   Ctrl+F8 : 查找本字符串
"""""""""""""""""""""""""""""""""""""""""""""""""""""""      
set cscopequickfix=s-,c-,d-,i-,t-,e-
if has("cscope")    
    set csprg=/usr/bin/cscope                  "指定用来执行 cscope 的命令。缺省值是 cscope
    set csto=0                                 "如果 'csto' 被设为 1，标签文件会在 cscope 数据库之前被搜索
    set cst                                    "设定 'cst' 选项意味着你总同时搜索 cscope 数据库和 标签文件
    set nocsverb    
    " add any database in current directory     
    if filereadable("cscope.out")   
        "加上路径,是为了对多级目录有效
        cs add $PWD/cscope.out $PWD
        "cs add cscope.out 
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif   
    set csverb    
endif


"	0 或 s: 查找本 C 符号
"	1 或 g: 查找本定义
"	2 或 d: 查找本函数调用的函数
"	3 或 c: 查找调用本函数的函数
"	4 或 t: 查找本字符串
"	6 或 e: 查找本 egrep 模式
"	7 或 f: 查找本文件
"	8 或 i: 查找包含本文件的文件

"这里不知道为什么,<C-_>g 不生效,但改成<C-_>,就生效了
nmap <C-F5> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-F6> :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-F7> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-F8> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (5) 插件:Grep  ---> F7
"""""""""""""""""""""""""""""""""""""""""""""""""""""""  
" 在工程中查找
"gs add 2016-1-5 set plug-in Grep
nnoremap <silent> <F7> :Grep<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (6) syntastic 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""  
"syntastic,是一个语法错误检查,是一个语法错误检查插件
" 是否在打开文件时检查
let g:syntastic_check_on_open=0
" 是否在保存文件后检查
let g:syntastic_check_on_wq=1
let g:syntastic_cpp_include_dirs = ['/usr/include/']
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
"set error or warning signs
let g:syntastic_error_symbol = 'X'
let g:syntastic_warning_symbol = '!'
"whether to show balloons
let g:syntastic_enable_balloons = 1
let g:syntastic_ignore_files=[".*\.py$"]  

if 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (7) SuperTab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""  
"  加速补全,按Tab键就可以补全
" gs add 2016-1-5 set plug-in SuperTab
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"
" 也是在插入模式下,按Tab键
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (8) ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""  
" 全局搜索是一个基于文件名的搜索功能，可以快速定位一个文件。
"模糊搜索最近打开的文件(MRU): \ p
let g:ctrlp_map = '<leader>p'  
let g:ctrlp_cmd = 'CtrlP'
"模糊搜索当前目录及其子目录下的所有文件: \ f
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {  'dir': '\v[\/]\.(git|hg|svn|rvm)$', 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$', }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (8.1) ctrlp-funky
""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"ctrlp的插件ctrlp-funky
"作用: 模糊搜索当前文件中所有函数
"<leader>fu 进入当前文件的函数列表搜索
"<leader>fU 搜索当前光标下单词对应的函数
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_extensions = ['funky']



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (9) YouCompleteMe 功能 
" YCM使用TAB键接受补全，一直按TAB则会循环所有的匹配补全项。shift+TAB则会反向循环。注意
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"为了更好的提高补全效率，我们可以保留原先使用的用Ctags生成的tags文件
let g:ycm_collect_identifiers_from_tags_files = 1
" 语法关键字补全              
let g:ycm_seed_identifiers_with_syntax=1  

" 补全功能在注释中同样有效, 1是有效
let g:ycm_complete_in_comments=0
"注释和字符串中的文字也会被收入补全, 0是会收入
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" 不显示开启vim时检查ycm_extra_conf文件的信息   
let g:ycm_confirm_extra_conf=0
 
" 补全内容不以分割子窗口形式出现，只显示补全列表  
set completeopt-=preview  

" 禁止缓存匹配项，每次都重新生成匹配项  
let g:ycm_cache_omnifunc=0

" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;  
"let g:ycm_key_invoke_completion = '<M-;>'  

" 设置转到定义处的快捷键为ALT + G，这个功能非常赞  
nmap <M-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR> 

" 设置在下面几种格式的文件补全
let g:ycm_filetype_whitelist = {'c' : 1, 'cpp' : 1, 'java' : 1, 'python' : 1}

" 输入第2个字符开始补全
let g:ycm_min_num_of_chars_for_completion=2








