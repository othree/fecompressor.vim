" yuicompressor and closure-compiler and less and scss: 
" http://blog.othree.net/log/2009/12/26/javascript-on-vim/
function! Fe_compress ()
    let cwd = expand('%:p:h')
    let nam = expand('%:t:r')
    let ext = expand('%:e')
    let cssnam = nam.'.css'
    if ext == 'less'
        if filewritable(cwd.'/'.cssnam)
            cal system( 'lessc '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.cssnam.' &')
            cal Css_compress()
        endif
    elseif ext == 'scss'
        if filewritable(cwd.'/'.cssnam)
            cal system( 'sass '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.cssnam.' &')
            cal Css_compress()
        endif
    elseif ext == 'css'
        cal Css_compress()
    elseif ext == 'js'
        if -1 == match(nam, "[\._]src$")
            let minfname = nam.".min.".ext
        else
            let minfname = substitute(nam, "[\._]src$", "", "g").".".ext
        endif
        if filewritable(cwd.'/'.minfname)
		cal system( s:jscompressor.' '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.minfname.' &')
        endif
    endif
endfunction

function! Css_compress ()
    let cwd = expand('%:p:h')
    let nam = expand('%:t:r')
    let ext = "css"
    if -1 == match(nam, "[\._]src$")
        let minfname = nam.".min.".ext
    else
        let minfname = substitute(nam, "[\._]src$", "", "g").".".ext
    endif
    if filewritable(cwd.'/'.minfname)
	if executable('yuicompressor')
		cal system( 'yuicompressor '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.minfname.' &')
	elseif executable('yui-compressor')
		cal system( 'yui-compressor '.cwd.'/'.nam.'.'.ext.' > '.cwd.'/'.minfname.' &')
	endif
    endif
endfunction

if executable('uglifyjs') || executable('closure-compiler') || executable('closure') || executable('yuicompressor') || executable('yui-compressor')
    autocmd FileWritePost,BufWritePost *.js :call Fe_compress()
    if executable('uglifyjs')
        let s:jscompressor = 'uglifyjs'
    elseif executable('closure-compiler')
        let s:jscompressor = 'closure-compiler --js'
    elseif executable('closure')
        let s:jscompressor = 'closure --js'
    elseif executable('yuicompressor')
        let s:jscompressor = 'yuicompressor'
    elseif executable('yui-compressor')
        let s:jscompressor = 'yui-compressor'
    endif
endif
if executable('lessc')
    autocmd FileWritePost,BufWritePost *.less :call Fe_compress()
endif
if executable('sass')
    autocmd FileWritePost,BufWritePost *.scss :call Fe_compress()
endif
if executable('yuicompressor') || executable('yui-compressor')
    autocmd FileWritePost,BufWritePost *.css :call Css_compress()
endif
