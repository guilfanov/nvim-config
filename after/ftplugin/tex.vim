let maplocalleader = ','

function! s:ToPNG(fname=0)
    if &filetype != 'tex'
        return -1
    endif
    if a:fname == ' '
        !convert -alpha deactivate -density 1000 %:p:r.pdf %:p:r.png
    else
        execute printf('!convert -alpha deactivate -density 1000 %s.pdf %s/%s.png', expand('%:p:r'), expand('%:p:h'), a:fname)
    endif
endfunction

function! s:ViewPNG(fname=0)
    if a:fname == ' '
        silent !open %:p:r.png
    else
        execute printf('!open %s/%s.png', expand('%:p:h'), a:fname)
    endif
endfunction

python << endpython

import wikipedia

def SumWiki(query):
    return wikipedia.summary(query)

def GetImages(query):
    return wikipedia.WikipediaPage(query).images

endpython

command! -nargs=? ToPNG call <SID>ToPNG(<f-args>)
command! -nargs=? ViewPNG call <SID>ViewPNG(<f-args>)
command! -nargs=1 SumWiki python print(SumWiki(<f-args>))
command! -nargs=1 GetImages python print(GetImages(<f-args>))
