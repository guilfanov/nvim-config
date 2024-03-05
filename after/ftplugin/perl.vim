let maplocalleader = ','
let b:path = expand('<sfile>:p')
compiler perl

let b:continuous = 0

function! s:PerlMsg(msg, err=0, filename=0)
    if a:err
        echohl WarningMsg
    else
        echohl Question
    endif
    redraw | echo 'Perl: '
    echohl ModeMsg
    if a:filename
        echon printf("%s (%s)", a:msg, expand('%:t'))
    else
        echon a:msg
    endif
    echohl None
endfunction

function! s:PerlRun(qf=1) abort
    if b:continuous && a:qf
        make!
        botright cwindow
        if getqflist({'winid' : win_getid()}).winid != 0
            wincmd p
            call <SID>PerlMsg('Execution failed!', 1)
        endif
    elseif !a:qf
        cclose
        execute printf('silent botright split +resize%d term://%s', float2nr(&lines*0.25), &makeprg)
        normal! A
    endif
endfunction

function! s:Toggle()
    let b:continuous = !b:continuous
    if b:continuous
        call <SID>PerlMsg('Run on save on', 0, 1)
    else
        call <SID>PerlMsg('Run on save off', 0, 1)
    endif
    call <SID>PerlRun()
endfunction

augroup perl_run
    autocmd!
    autocmd BufWritePost *.pl call <SID>PerlRun()
augroup END

" Mappings
nmap <buffer> <LocalLeader>c <Plug>Toggle
nnoremap <buffer> <script> <Plug>Toggle <SID>Toggle
nnoremap <SID>Toggle <Cmd>call <SID>Toggle()<CR>

nmap <buffer> <LocalLeader>t <Plug>PerlRun
nnoremap <buffer> <script> <Plug>PerlRun <SID>PerlRun
nnoremap <SID>PerlRun <Cmd>call <SID>PerlRun(0)<CR>
