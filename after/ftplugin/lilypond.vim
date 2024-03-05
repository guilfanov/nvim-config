let maplocalleader = ','
let b:path = expand('<sfile>:p')
compiler lilypond

let b:continuous = 0

"let s:AScode = printf('osascript
"            \
"            \ -e "tell application \"Skim\""
"            \ -e "repeat with d in documents"
"            \ -e "if name of d is \"%s.pdf\" then"
"            \ -e "set index of first window whose name contains \"%s.pdf\" to 1"
"            \ -e "return"
"            \ -e "end if"
"            \ -e "end repeat"
"            \ -e "activate"
"            \ -e "open ((POSIX file \"%s.pdf\") as string)"
"            \ -e "end tell"
"            \ -e "tell application \"iTerm\" to activate"',
"            \ expand('%:r'), expand('%:r'), expand('%:p:r'))

"let s:AScode = printf('osascript
"            \
"            \ -e "tell application \"Skim\""
"            \ -e "open ((POSIX file \"%s.pdf\") as string)"
"            \ -e "end tell"
"            \ -e "tell application \"iTerm\" to activate"',
"            \ expand('%:p:r'))

let s:AScode = 'osascript -e "tell application \"iTerm\" to activate"'

function! s:ViewPDF() abort
    call system(printf('open -a Skim %s.pdf', expand('%:p:r')))
    call system(s:AScode)
endfunction

function! s:LyMsg(msg, err=0, filename=0)
    if a:err
        echohl WarningMsg
    else
        echohl Question
    endif
    redraw | echo 'Lilypond: '
    echohl ModeMsg
    if a:filename
        echon printf("%s (%s)", a:msg, expand('%:t'))
    else
        echon a:msg
    endif
    echohl None
endfunction

function! s:LyCompile() abort
    if b:continuous
        call <SID>LyMsg('Compiling', 0, 1)
        silent make!
        botright cwindow
        if getqflist({'winid' : win_getid()}).winid != 0
            wincmd p
            call <SID>LyMsg('Compilation failed!', 1)
        else
            call <SID>LyMsg('Compililation completed')
            " call <SID>ViewPDF()
        endif
    endif
endfunction

function! s:Toggle()
    let b:continuous = !b:continuous
    if b:continuous == 0
        call <SID>LyMsg('Compiler stopped', 0, 1)
    endif
    call <SID>LyCompile()
endfunction

augroup ly_compile
    autocmd!
    autocmd BufWritePost *.ly call <SID>LyCompile()
augroup END

" Mappings
nmap <buffer> <LocalLeader>c <Plug>Toggle
nnoremap <buffer> <script> <Plug>Toggle <SID>Toggle
nnoremap <SID>Toggle <Cmd>call <SID>Toggle()<CR>

nmap <buffer> <LocalLeader>v <Plug>ViewPDF
nnoremap <buffer> <script> <Plug>ViewPDF <SID>ViewPDF
nnoremap <SID>ViewPDF <Cmd>call <SID>ViewPDF()<CR>
