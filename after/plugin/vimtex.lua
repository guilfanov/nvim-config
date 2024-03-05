vim.g.maplocalleader = ','
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_activate = 0
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_compiler_latexmk = 
{
    ["options"] = 
    {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape"
    }
}

vim.g.conceallevel = 2
