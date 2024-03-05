let maplocalleader = ','
let b:path = expand('<sfile>:p')
compiler c

let b:continuous = 0

function! s:CMsg(msg, err=0, filename=0)
    if a:err
        echohl WarningMsg
    else
        echohl Question
    endif
    redraw | echo 'C: '
    echohl ModeMsg
    if a:filename
        echon printf("%s (%s)", a:msg, expand('%:t'))
    else
        echon a:msg
    endif
    echohl None
endfunction

function! s:CCompile() abort
    if b:continuous
        call <SID>CMsg('Compiling', 0, 1)
        silent make!
        botright cwindow
        if getqflist({'winid' : win_getid()}).winid != 0
            wincmd p
            call <SID>CMsg('Compilation failed!', 1)
        else
            call <SID>CMsg('Compililation completed')
        endif
    endif
endfunction

function! s:CRun(qf=1) abort
    if a:qf
        !%:p:r.out
    else
        cclose
        execute printf('silent botright split +resize%d term://%s.out', float2nr(&lines*0.25), expand('%:p:r'))
        normal! A
    endif
endfunction

function! s:Toggle()
    let b:continuous = !b:continuous
    if b:continuous == 0
        call <SID>CMsg('Compiler stopped', 0, 1)
    endif
    call <SID>CCompile()
endfunction

augroup c_compile
    autocmd!
    autocmd BufWritePost *.c call <SID>CCompile()
augroup END

" Mappings
nmap <buffer> <LocalLeader>c <Plug>Toggle
nnoremap <buffer> <script> <Plug>Toggle <SID>Toggle
nnoremap <SID>Toggle <Cmd>call <SID>Toggle()<CR>

nmap <buffer> <LocalLeader>r <Plug>Run
nnoremap <buffer> <script> <Plug>Run <SID>Run
nnoremap <SID>Run <Cmd>call <SID>CRun()<CR>

nmap <buffer> <LocalLeader>t <Plug>CRunTerminal
nnoremap <buffer> <script> <Plug>CRunTerminal <SID>CRunTerminal
nnoremap <SID>CRunTerminal <Cmd>call <SID>CRun(0)<CR>
