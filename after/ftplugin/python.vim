let maplocalleader = ','
let b:path = expand('<sfile>:p')
compiler python

let b:continuous = 0

function! s:PyMsg(msg, err=0, filename=0)
    if a:err
        echohl WarningMsg
    else
        echohl Question
    endif
    redraw | echo 'Python: '
    echohl ModeMsg
    if a:filename
        echon printf("%s (%s)", a:msg, expand('%:t'))
    else
        echon a:msg
    endif
    echohl None
endfunction

function! s:PyCompile(qf=1) abort
    if b:continuous && a:qf
        make!
        "execute printf('silent botright split +resize%d term://%s', float2nr(&lines*0.25), &makeprg) | cbuffer
        "copen
        botright cwindow
        if getqflist({'winid' : win_getid()}).winid != 0
            wincmd p
            call <SID>PyMsg('Execution failed!', 1)
        endif
    elseif !a:qf
        cclose
        execute printf('silent botright split term://%s', &makeprg)
        normal! A
    endif
endfunction

function! s:Toggle()
    let b:continuous = !b:continuous
    if b:continuous
        call <SID>PyMsg('Run on save on', 0, 1)
    else
        call <SID>PyMsg('Run on save off', 0, 1)
    endif
    call <SID>PyCompile()
endfunction

augroup python_run
    autocmd!
    autocmd BufWritePost *.py call <SID>PyCompile()
augroup END

" Mappings
" nnoremap <buffer> <Leader>e <Cmd>execute 'split' b:path<CR>
nmap <buffer> <LocalLeader>c <Plug>Toggle
nnoremap <buffer> <script> <Plug>Toggle <SID>Toggle
nnoremap <SID>Toggle <Cmd>call <SID>Toggle()<CR>

nmap <buffer> <LocalLeader>t <Plug>PyCompile
nnoremap <buffer> <script> <Plug>PyCompile <SID>PyCompile
nnoremap <SID>PyCompile <Cmd>call <SID>PyCompile(0)<CR>
