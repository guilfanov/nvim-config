vim.g.mapleader = " "
vim.fn.setenv( "RTP", vim.api.nvim_list_runtime_paths()[1] )

local function Check_split(fname)
    if vim.fn.filereadable( fname ) == 1 then
        local bufnum = vim.fn.bufnr( vim.fn.expand( fname ) )
        local winnum = vim.fn.bufwinnr( bufnum )

        if winnum ~= -1 then
            vim.cmd( tostring( winnum ) .. 'wincmd w' )
        else
            vim.cmd( 'split ' .. fname )
        end
    end
end

vim.keymap.set( "n", "<Leader>pv", vim.cmd.Explore)
vim.keymap.set( "n", "<Leader>se", "<Cmd>execute 'split' getenv('RTP') | lcd $RTP<CR>" )
vim.keymap.set( "n", "<Leader>e", function() Check_split(string.format('%s/after/ftplugin/%s.vim', vim.fn.stdpath('config'), vim.bo.filetype)) end)
vim.keymap.set( "n", "<Leader>sn", function() Check_split(string.format('%s/LuaSnip/snippets/%s/%s.lua', vim.fn.stdpath('config'), vim.bo.filetype, vim.bo.filetype)) end)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<Leader>y", "\"+y")
vim.keymap.set("v", "<Leader>y", "\"+y")

vim.keymap.set( "n", "<Leader>l", vim.cmd.cnext )
vim.keymap.set( "n", "<Leader>h", vim.cmd.cprevious )

function grep()
    vim.cmd(string.format("silent grep! %s %%:h/*", vim.fn.input("Grep > ")))
    vim.cmd.cwindow()
end
vim.keymap.set("n", "<F5>", grep)
