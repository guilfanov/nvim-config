-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(
function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    use
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('nvim-treesitter/playground')

    -- LSP
    use('neovim/nvim-lspconfig')

    use
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
    }

    use('williamboman/mason.nvim')

    use('williamboman/mason-lspconfig.nvim')

    use('hrsh7th/nvim-cmp')

    use('hrsh7th/cmp-nvim-lsp')

    use('hrsh7th/cmp-buffer')

    use('hrsh7th/cmp-path')

    use('saadparwaiz1/cmp_luasnip')

    use('hrsh7th/cmp-nvim-lua')

    use('mbbill/undotree')

    use('lervag/vimtex')

    use
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    }

    use('vimwiki/vimwiki')

    -- Colorschemes
    use{ "catppuccin/nvim", as = "catppuccin" }

    use
    {
        "mcchrish/zenbones.nvim",
        -- Optionally install Lush. Allows for more configuration or extending the colorscheme
        -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
        -- In Vim, compat mode is turned on as Lush only works in Neovim.
        requires = "rktjmp/lush.nvim"
    }

    use
    {
        'projekt0n/github-nvim-theme',
        config = function() require('github-theme').setup({}) end
    }

    use 'MetriC-DT/balance-theme.nvim'

    use({ 'rose-pine/neovim', as = 'rose-pine' })

    use 'mhartington/oceanic-next'
end)
