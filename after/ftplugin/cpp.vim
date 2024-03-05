let maplocalleader = ','
let b:path = expand('<sfile>:p')
compiler cpp

let b:continuous = 0

function! s:CppMsg(msg, err=0, filename=0)
    if a:err
        echohl WarningMsg
    else
        echohl Question
    endif
    redraw | echo 'Cpp: '
    echohl ModeMsg
    if a:filename
        echon printf("%s (%s)", a:msg, expand('%:t'))
    else
        echon a:msg
    endif
    echohl None
endfunction

function! s:CppCompile() abort
    if b:continuous
        call <SID>CppMsg('Compiling', 0, 1)
        silent make!
        botright cwindow
        if getqflist({'winid' : win_getid()}).winid != 0
            wincmd p
            call <SID>CppMsg('Compilation failed!', 1)
        else
            call <SID>CppMsg('Compililation completed')
        endif
    endif
endfunction

function! s:CppRun(qf=1) abort
    if a:qf
        !%:p:r
    else
        cclose
        execute printf('silent botright split term://%s', expand('%:p:r'))
    endif
endfunction

function! s:Toggle()
    let b:continuous = !b:continuous
    if b:continuous == 0
        call <SID>CppMsg('Compiler stopped', 0, 1)
    endif
    call <SID>CppCompile()
endfunction

augroup cpp_compile
    autocmd!
    autocmd BufWritePost *.cpp call <SID>CppCompile()
augroup END

" Mappings
nmap <buffer> <LocalLeader>c <Plug>Toggle
nnoremap <buffer> <script> <Plug>Toggle <SID>Toggle
nnoremap <SID>Toggle <Cmd>call <SID>Toggle()<CR>

nmap <buffer> <LocalLeader>r <Plug>Run
nnoremap <buffer> <script> <Plug>Run <SID>Run
nnoremap <SID>Run <Cmd>call <SID>CppRun()<CR>

nmap <buffer> <LocalLeader>t <Plug>CppRunTerminal
nnoremap <buffer> <script> <Plug>CppRunTerminal <SID>CppRunTerminal
nnoremap <SID>CppRunTerminal <Cmd>call <SID>CppRun(0)<CR>
