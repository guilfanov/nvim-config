require("luasnip").config.set_config({ -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = "<C-K>",

  update_events = "TextChanged, TextChangedI"
})

vim.cmd[[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <C-K> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <C-K> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <C-J> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-F> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-F> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]

-- Load all snippets from the nvim/LuaSnip directory at startup
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/snippets"})

-- Lazy-load snippets, i.e. only load when required, e.g. for a given filetype
require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/snippets"})
