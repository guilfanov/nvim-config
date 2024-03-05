require'nvim-treesitter.configs'.setup
{
    ensure_installed = { "c", "cpp", "python", "lua", "vim", "vimdoc", "query" },

    auto_install = true,

    highlight =
    {
        enable = true,
        disable = { "latex" },
    },
}
