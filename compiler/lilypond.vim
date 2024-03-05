if exists("current_compiler")
    finish
endif
let current_compiler = 'lilypond --loglevel=WARNING -o %:r %'
let &l:makeprg = current_compiler
