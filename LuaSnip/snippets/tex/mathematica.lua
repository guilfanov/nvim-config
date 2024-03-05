local ls = require( "luasnip" )
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local ex = require("luasnip.extras")
local fmt = require( "luasnip.extras.fmt" ).fmt
local fmta = require( "luasnip.extras.fmt" ).fmta
local rep = require( "luasnip.extras" ).rep

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local tex_utils = {}

tex_utils.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1 and not tex_utils.in_mathematica()
end
tex_utils.in_mathematica = function()
    local idx_ldelim = vim.fn.searchpairpos([[<math>]], "", [[<@math>]], "bnW", '', 0, 100)
    return (idx_ldelim[1] > 0 and idx_ldelim[2] > 0)
end
tex_utils.in_mathematica_in_f = function(_, parent)
    if parent and parent.snippet then
        vim.cmd(string.format("normal! %dha", #parent.snippet.trigger))
    end
    return tex_utils.in_mathematica()
end

function get_visual(_, parent, _, user_args)
    if user_args then
        ret = user_args
    else
        ret = ""
    end

    if ( #parent.snippet.env.LS_SELECT_RAW > 0 ) then
        return sn( nil, i( 1, parent.snippet.env.LS_SELECT_RAW ) )
    else
        return sn( nil, i( 1, ret ) )
    end
end

local mathematica = function(_, snip)
    local code = string.format(
        "wolframscript -code 'ToString@TeXForm[%s]'",
        snip.captures[1]
    )
    return vim.fn.systemlist(code)
end

mathematica_snippets =
{

s(
    {
        trig = "math",
        dscr = "mathematica block"
    },
    fmt(
        [[
            <math> {} <@math>
        ]],
        { d( 1, get_visual ) }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "<math>%s*(.*)%s*<@math>",
        dscr = "evaluate mathematica",
        wordTrig = false,
        trigEngine = "pattern"
    },
    {
        f(mathematica)
    }
),

s(
    {
        trig = "ff",
        dscr = "mathematica fraction",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            (<>)/(<>)<>
        ]],
        {
            i(1, "1"),
            i(2, "x"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "infty",
        dscr = "infinity in mathematica",
        snippetType = "autosnippet"
    },
    t("Infinity"),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "lim",
        dscr = "limit in mathematica",
        snippetType = "autosnippet"
    },
    fmt(
        [[
            Limit[{}, {} -> {}]{}
        ]],
        {
            i(1, "f(x)"),
            i(2, "x"),
            i(3, "Infinity"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "D",
        dscr = "derivative"
    },
    fmta(
        [[
            D[<>, <>]<>
        ]],
        {
            i(1, "x^n"),
            i(2, "x"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "dint",
        dscr = "definite integral in mathematica",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Integrate[<>, {<>, <>, <>}]<>
        ]],
        {
            i(1, "f(x)"),
            i(2, "x"),
            i(3, "-Infinity"),
            i(4, "Infinity"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "uint",
        dscr = "indefinite integral in mathematica",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Integrate[<>, <>]<>
        ]],
        {
            i(1, "f(x)"),
            i(2, "x"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "dint",
        dscr = "definite integral in mathematica",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Integrate[<>, {<>, <>, <>}]<>
        ]],
        {
            i(1, "f(x)"),
            i(2, "x"),
            i(3, "-Infinity"),
            i(4, "Infinity"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = [[\\\@<!\(sin\|cos\|tan\|cot\|csc\|sec\|log\|exp\|det\)]],
        dscr = "std functions in mathematica",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[<>[<>]<>]],
        {
            f(
                function(_, snip)
                    return snip.captures[1]:gsub("^.", string.upper)
                end
            ),
            i(1, "x"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "rd",
        dscr = "power",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    fmta(
        [[^(<>)]],
        { i(1, "n") }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "sk",
        dscr = "square root in mathematica",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Sqrt[<>]<>
        ]],
        {
            i(1, "x"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "sum",
        dscr = "sum in mathematica",
    },
    fmta(
        [[
            Sum[<>, {<>, <>, <>}]<>
        ]],
        {
            i(1, "a_n"),
            i(2, "n"),
            i(3, "1"),
            i(4, "Infinity"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "prod",
        dscr = "product in mathematica",
    },
    fmta(
        [[
            Product[<>, {<>, <>, <>}]<>
        ]],
        {
            i(1, "a_n"),
            i(2, "n"),
            i(3, "1"),
            i(4, "Infinity"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "xpd",
        dscr = "expand expression",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Expand[<>]<>
        ]],
        {
            d(1, get_visual, _, { user_args = { "(x+y)^2" } }),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "apx",
        dscr = "approximation",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            N[<>]<>
        ]],
        {
            c(
                1,
                {
                    d(1, get_visual, _, { user_args = { "Pi" } }),
                    fmta(
                        [[
                            <>, <>
                        ]],
                        {
                            d(1, get_visual, _, { user_args = { "Pi" } }),
                            i(2, "10")
                        }
                    )
                }
            ),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "fi",
        dscr = "factor integer",
    },
    fmt(
        [[
            CenterDot @@ Superscript @@@ (FactorInteger[`'] /. {a_, 1} :> a)`'
        ]],
        {
            i(1, "60"),
            i(0)
        },
        { delimiters = "`'" }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "fe",
        dscr = "factor",
    },
    fmta(
        [[
            Factor[<>]<>
        ]],
        {
            i(1),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "si",
        dscr = "semantic interpretation"
    },
    fmta(
        [[
            SemanticInterpretation["<>"]<>
        ]],
        {
            i(1, "two plus two"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "tb",
        dscr = "table",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            Table[<>, {<>, <>, <>}]<>
        ]],
        {
            i(1, "n^2"),
            i(2, "n"),
            i(3, "0"),
            i(4, "6"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

s(
    {
        trig = "fsf",
        dscr = "find sequence function",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            FindSequenceFunction[{<>}, <>]<>
        ]],
        {
            i(1, "2, 4, 6, 8"),
            i(2, "n"),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathematica }
),

}

return mathematica_snippets
