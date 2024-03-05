local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return
{

s(
    {
        trig = "snip",
        dscr = "Snippet template"
    },
    fmta(
        [[
            s(
                {
                    trig = "<>",
                    dscr = <>
                },
                <>
            ),
        ]],
        {
            i( 1 ),
            i( 2 ),
            i( 3 )
        }
    )
),

s(
    {
        trig = "snipa",
        dscr = "Autosnippet template"
    },
    fmta(
        [[
            s(
                {
                    trig = "<>",
                    dscr = "<>",
                    snippetType = "autosnippet"
                },
                <>
            ),
        ]],
        {
            i( 1 ),
            i( 2 ),
            c(
                3,
                {
                    t( "" ),
                    sn(
                        3,
                        {
                            t( { "fmta(", "        " } ),
                            i( 1 ),
                            t( { "", "    )," } )
                        }
                    )
                }
            )
        }
    )
)

}
