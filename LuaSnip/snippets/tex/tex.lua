local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local tex_utils = {}

tex_utils.in_math = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex_utils.in_mathzone = function()
  return tex_utils.in_math() and not tex_utils.in_mathematica()
end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
tex_utils.in_env = function(name)
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
tex_utils.in_equation = function()
    return tex_utils.in_env('equation')
end
tex_utils.in_itemize = function()
    return tex_utils.in_env('itemize')
end
tex_utils.in_tikz = function()
    return tex_utils.in_env('tikzpicture')
end
tex_utils.in_align = function()
    return tex_utils.in_env('align')
end
tex_utils.in_mathl_in_f = function(_, parent)
    if parent then
        vim.cmd(string.format("normal! %dha", #parent.snippet.trigger))
    end
    local idx_ldelim = vim.fn.searchpairpos([[<mathl>]], "", [[<@mathl>]], "bnW", '', 0, 100)
    return (idx_ldelim[1] > 0 and idx_ldelim[2] > 0)
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

local mathematica_latex = function(_, snip)
    local code = "wolframscript -code 'ToString@TeXForm[ToExpression[\""
        ..snip.captures[1]:gsub([[\]], [[\\]])
        .."\", TeXForm]]'"
    local eval = vim.fn.trim(vim.fn.system(code))
    local idx = eval:match(".*\n()")
    return string.sub(eval, idx, -1)
end

local function get_visual(_, parent, _, user_args)
    local ret = user_args or ""
    if (#parent.snippet.env.LS_SELECT_RAW > 0) then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else
        return sn(nil, i(1, ret))
    end
end

local subscript = function(_, snip)
    if (string.match( snip.captures[3], "[,;]")) then
        return snip.captures[3].." "
    else
        return snip.captures[3]
    end
end

-- local greek_letters = 
-- {
--     a = [[\alpha]],
--     b = [[\beta]],
--     G = [[\Gamma]],
--     g = [[\gamma]],
--     D = [[\Delta]],
--     d = [[\delta]],
--     e = [[\varepsilon]],
--     z = [[\zeta]],
--     h = [[\eta]],
--     T = [[\Theta]],
--     H = [[\theta]],
--     i = [[\iota]],
--     k = [[\kappa]],
--     L = [[\Lambda]],
--     l = [[\lambda]],
--     m = [[\mu]],
--     n = [[\nu]],
--     X = [[\Xi]],
--     x = [[\xi]],
--     P = [[\Pi]],
--     p = [[\pi]],
--     r = [[\rho]],
--     S = [[\Sigma]],
--     s = [[\sigma]],
--     t = [[\tau]],
--     u = [[\upsilon]],
--     F = [[\Phi]],
--     f = [[\phi]],
--     c = [[\chi]],
--     Y = [[\Psi]],
--     y = [[\psi]],
--     O = [[\Omega]],
--     o = [[\omega]]
-- }

local snippets =
{

s(
    {
        trig = "bgn",
        dscr = "Environment",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \begin{<>}
                <>
            \end{<>}
        ]],
        {
            i(1),
            d(2, get_visual),
            rep(1)
        }
    ),
    { condition = line_begin }
),

s(
    {
        trig = "...",
        dscr = "ldots",
        priority = 100,
        snippetType = "autosnippet"
    },
    { t([[\ldots]]) }
),

s(
    {
        trig = "enum",
        dscr = "Enumerate environment",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \begin{enumerate}
                \item <>
            \end{enumerate}
        ]],
        { i(1) }
    ),
    { condition = line_begin }
),

s(
    {
        trig = "item",
        dscr = "Itemize environment",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \begin{itemize}
                \item <>
            \end{itemize}
        ]],
        { i(1) }
    ),
    { condition = line_begin }
),

s(
    {
        trig = "pac",
        dscr = "package"
    },
    fmta(
        [[
            \usepackage<><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        "{<>}",
                        d(1, get_visual, {}, { user_args = { "package" } })
                    ),
                    fmta(
                        "[<>]{<>}",
                        {
                            i(1, "options"),
                            d(2, get_visual, {}, { user_args = { "package" } })
                        }
                    )
                }
            ),
            i(0)
        }
    ),
    { condition = line_begin }
),

s(
    {
        trig = "=>",
        dscr = [[\Rightarrow]],
        snippetType = "autosnippet"
    },
    { t([[\Rightarrow]]) },
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "=<",
        dscr = [[\Leftarrow]],
        snippetType = "autosnippet"
    },
    { t([[\Leftarrow]]) },
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!iff]],
        dscr = [[\Leftrightarrow]],
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    { t([[\Leftrightarrow]]) },
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "mm",
        dscr = "inline math",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \(<>\)
        ]],
        { d(1, get_visual) }
    ),
    { condition = tex_utils.in_text }
),

s(
    {
        trig = "dm",
        dscr = "display math",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \[
                <>
            \]
        ]],
        { d(1, get_visual) }
    ),
    { condition = tex_utils.in_text }
),

s(
    {
        trig = "ali",
        dscr = 'align',
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \begin{align*}
                <>
            \end{align*}
        ]],
        { d(1, get_visual) }
    ),
    { condition = line_begin }
),

s(
    {
        trig = "ff",
        dscr = "fraction",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \frac{<>}{<>}
        ]],
        {
            i(1, "1"),
            i(2, "n"),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "([%a%)])(%d+)([^%d])",
        dscr = "auto subscript",
        wordTrig = false,
        trigEngine = "pattern",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            <>_{<>}<><>
        ]],
        {
            f(function(_, snip) return snip.captures[1] end),
            f(function(_, snip) return snip.captures[2] end),
            f(subscript),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "mathl",
        dscr = "mathematica latex block"
    },
    fmt(
        [[
            <mathl> {} <@mathl>
        ]],
        { d(1, get_visual) }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "<mathl>%s*(.*)%s*<@mathl>",
        dscr = "evaluate mathematica",
        wordTrig = false,
        trigEngine = "pattern"
    },
    f(mathematica_latex)
),

s(
    {
        trig = "!=",
        dscr = "not equal",
        snippetType = "autosnippet"
    },
    { t([[\neq]]) },
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "ceil",
        dscr = "ceiling",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[\lceil <> \rceil]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl\lceil <> \bigr\rceil]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl\lceil <> \Bigr\rceil]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl\lceil <> \biggr\rceil]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl\lceil <> \Biggr\rceil]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "floor",
        dscr = "floor",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[\lfloor <> \rfloor]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl\lfloor <> \bigr\rfloor]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl\lfloor <> \Bigr\rfloor]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl\lfloor <> \biggr\rfloor]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl\lfloor <> \Biggr\rfloor]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "lrp",
        dscr = "parentheses",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[( <> )]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl( <> \bigr)]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl( <> \Bigr)]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl( <> \biggr)]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl( <> \Biggr)]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "lrb",
        dscr = "brackets",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        "[ <> ]",
                        r(1, "user_text")
                    ),
                    fmta(
                        "\\bigl[ <> \\bigr]",
                        r(1, "user_text")
                    ),
                    fmta(
                        "\\Bigl[ <> \\Bigr]",
                        r(1, "user_text")
                    ),
                    fmta(
                        "\\biggl[ <> \\biggr]",
                        r(1, "user_text")
                    ),
                    fmta(
                        "\\Biggl[ <> \\Biggr]",
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "lra",
        dscr = "angles",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[\langle <> \rangle]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl\langle <> \bigr\rangle]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl\langle <> \Bigr\rangle]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl\langle <> \biggr\rangle]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl\langle <> \Biggr\rangle]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "lrV",
        dscr = "norm",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[\Vert <> \Vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl\Vert <> \bigr\Vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl\Vert <> \Bigr\Vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl\Vert <> \biggr\Vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl\Vert <> \Biggr\Vert]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "sum",
        dscr = "sum"
    },
    fmta(
        [[
            \sum_<><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[{<>=<>}^{<>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1"),
                            i(3, [[\infty]])
                        }
                    ),
                    fmta(
                        [[{<> \in <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "I")
                        }
                    ),
                    fmta(
                        [[{<> \geq <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1")
                        }
                    )
                }
            ),
            d(2, get_visual)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = i(1, "i")
        }
    }
),

s(
    {
        trig = "prod",
        dscr = "prod"
    },
    fmta(
        [[
            \prod<><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[{<>=<>}^{<>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1"),
                            i(3, [[\infty]])
                        }
                    ),
                    fmta(
                        [[{<> \in <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "I")
                        }
                    ),
                    fmta(
                        [[{<> \geq <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1")
                        }
                    )
                }
            ),
            d(2, get_visual)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = i(1, "i")
        }
    }
),

s(
    {
        trig = "UU",
        dscr = "bigcup",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \bigcup_<><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[{<>=<>}^{<>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1"),
                            i(3, [[\infty]])
                        }
                    ),
                    fmta(
                        [[{<> \in <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "I")
                        }
                    ),
                    fmta(
                        [[{<> \geq <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1")
                        }
                    )
                }
            ),
            d(2, get_visual)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = i(1, "i")
        }
    }
),

s(
    {
        trig = "Nn",
        dscr = "bigcap",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \bigcap_<><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[{<>=<>}^{<>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1"),
                            i(3, [[\infty]])
                        }
                    ),
                    fmta(
                        [[{<> \in <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "I")
                        }
                    ),
                    fmta(
                        [[{<> \geq <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "1")
                        }
                    )
                }
            ),
            d(2, get_visual)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = i(1, "i")
        }
    }
),

s(
    {
        trig = "lim",
        dscr = "limit",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \lim_{<> \to <>}
        ]],
        {
            i(1, "n"),
            i(2, [[\infty]])
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!\(abs\|norm\)]],
        dscr = "absolute/norm",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \<><><>
        ]],
        {
            f(function(_, snip) return snip.captures[1] end),
            c(
                1,
                {
                    fmta(
                        [[{<>}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\big]{<>}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Big]{<>}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\bigg]{<>}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Bigg]{<>}]],
                        r(1, "user_text")
                    )
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual, {}, { user_args = { "x" } })
        }
    }
),

s(
    {
        trig = "lrv",
        dscr = "cardinal",
    },
    fmta(
        [[
            <><>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[\vert <> \vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\bigl\vert <> \bigr\vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Bigl\vert <> \Bigr\vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\biggl\vert <> \biggr\vert]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[\Biggl\vert <> \Biggr\vert]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "df(.)",
        dscr = "differential operator",
        trigEngine = "pattern",
        snippetType = "autosnippet"
    },
    f(
        function(_, snip)
            if snip.captures[1]:match("%w") then
                return [[\diff ]] .. snip.captures[1]
            else
                return [[\diff]] .. snip.captures[1]
            end
        end
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "dd",
        dscr = "derivative operator",
        snippetType = "autosnippet"
    },
    fmta(
        [[<><>]],
        {
            c(
                1,
                {
                    fmta(
                        [[\frac{\diff <>}{\diff <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "x")
                        }
                    ),
                    fmta(
                        [[\frac{\diff^{<>}<>}{\diff <>^{<>}}]],
                        {
                            i(1),
                            r(2, "user_text"),
                            i(3, "x"),
                            rep(1)
                        }
                    )
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "pp",
        dscr = "partial derivative operator",
        snippetType = "autosnippet"
    },
    fmta(
        [[<><>]],
        {
            c(
                1,
                {
                    fmta(
                        [[\frac{\partial <>}{\partial <>}]],
                        {
                            r(1, "user_text"),
                            i(2, "x")
                        }
                    ),
                    fmta(
                        [[\frac{\partial^{<>}<>}{\partial <>^{<>}}]],
                        {
                            i(1),
                            r(2, "user_text"),
                            i(3, "x"),
                            rep(1)
                        }
                    )
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "sk",
        dscr = "square root",
        snippetType = "autosnippet"
    },
    fmta(
        [[\sqrt{<>}]],
        { d(1, get_visual) }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "sr",
        dscr = "square",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    t("^2"),
    { condition = tex_utils.in_math }
),

s(
    {
        trig = "cb",
        dscr = "cube",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    t("^3"),
    { condition = tex_utils.in_math }
),

s(
    {
        trig = "rd",
        dscr = "power",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    fmta(
        [[^{<>}]],
        { i(1, "n") }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "__",
        dscr = "subscript",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    fmta(
        [[_{<>}]],
        { i(1, "i") }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "ooo",
        dscr = "infinity",
        snippetType = "autosnippet"
    },
    t([[\infty]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "<=",
        dscr = "leq",
        snippetType = "autosnippet"
    },
    t([[\leq]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = ">=",
        dscr = "geq",
        snippetType = "autosnippet"
    },
    t([[\geq]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "EE",
        dscr = "exists",
        snippetType = "autosnippet"
    },
    t([[\exists]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "AA",
        dscr = "forall",
        snippetType = "autosnippet"
    },
    t([[\forall]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "mcal",
        dscr = "mathcal",
        snippetType = "autosnippet"
    },
    fmta(
        [[\mathcal{<>}]],
        { i(1, "L") }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "lll",
        dscr = "ell",
        snippetType = "autosnippet"
    },
    t([[\ell]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "nabl",
        dscr = "nabla",
        snippetType = "autosnippet"
    },
    t([[\nabla]]),
    { condition = tex_utils.in_mathzone }
),

-- s(
--     {
--         trig = "\\(\\\\\\=\\)\\(sin\\|cos\\|tan\\|cot\\|csc\\|sec\\|ln\\|log\\|exp\\)",
--         dscr = "std functions",
--         trigEngine = "vim",
--         snippetType = "autosnippet"
--     },
--     fmta(
--         [[<>]],
--         {
--             f(
--                 function(_, snip)
--                     if snip.captures[1] then
--                         return snip.captures[1]..snip.captures[2]
--                     else
--                         return "\\"..snip.captures[2] 
--                     end
--                 end
--             )
--         }
--     ),
--     { condition = tex_utils.in_mathzone }
-- )

s(
    {
        trig = [[\\\@<!\(sin\|cos\|tan\|cot\|csc\|sec\|ln\|log\|exp\|det\)]],
        dscr = "std functions",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[\<>]],
        {
            f(function(_, snip) return snip.captures[1] end)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\=a\(sin\|cos\|tan\)]],
        dscr = "inverse trig functions",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    f(function(_, snip) return [[\arc]]..snip.captures[1] end),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "dint",
        dscr = "definite integral",
        snippetType = "autosnippet"
    },
    fmta(
        [[
            \int_<><>\diff <>
        ]],
        {
            c(
                1,
                {
                    fmta(
                        [[{<>}^{<>}]],
                        {
                            i(1, [[-\infty]]),
                            i(2, [[\infty]])
                        }
                    ),
                    fmta(
                        "{<>}",
                        i(1, [[\mathbf{R}]])
                    )
                }
            ),
            d(2, get_visual, {}, { user_args = { "f(x)" } }),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "->",
        dscr = "to",
        snippetType = "autosnippet"
    },
    t([[\to]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "<->",
        dscr = "leftrightarrow",
        snippetType = "autosnippet"
    },
    t([[\leftrightarrow]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "!>",
        dscr = "matpsto",
        snippetType = "autosnippet"
    },
    t([[\mapsto]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "invs",
        dscr = "inverse",
        snippetType = "autosnippet"
    },
    t("^{-1}"),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "compl",
        dscr = "complement",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    t("^{c}"),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!mid]],
        dscr = "mid",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    t([[\mid]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "cc",
        dscr = "subset",
        snippetType = "autosnippet"
    },
    t([[\subset]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "notin",
        dscr = "not in",
        snippetType = "autosnippet"
    },
    t([[\not\in]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "inn",
        dscr = "in",
        snippetType = "autosnippet"
    },
    t([[\in]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!cap]],
        dscr = "cap",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    t([[\cap]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!cup]],
        dscr = "cup",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    t([[\cup]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "tt",
        dscr = "text",
        snippetType = "autosnippet"
    },
    fmta(
        [[\text{<>}]],
        { d(1, get_visual) }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\(NN\|ZZ\|QQ\|RR\|CC\|FF\|KK\)]],
        dscr = "std sets",
        trigEngine = "vim",
        wordTrig = false,
        snippetType = "autosnippet"
    },
    f(
        function(_, snip)
            return [[\mathbf{]] .. snip.captures[1]:sub(1, 1) .. "}"
        end
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "OO",
        dscr = "empty set",
        snippetType = "autosnippet"
    },
    t([[\varnothing]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "sets",
        dscr = "builder set",
    },
    fmta(
        [[\Set<><>]],
        {
            c(
                1,
                {
                    fmta(
                        [[{ <> }]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\big]{ <> }]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Big]{ <> }]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\bigg]{ <> }]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Bigg]{ <> }]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "set",
        dscr = "builder set",
    },
    fmta(
        [[\Set<><>]],
        {
            c(
                1,
                {
                    fmta(
                        [[{\, <> \,}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\big]{\, <> \,}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Big]{\, <> \,}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\bigg]{\, <> \,}]],
                        r(1, "user_text")
                    ),
                    fmta(
                        [[[\Bigg]{\, <> \,}]],
                        r(1, "user_text")
                    ),
                }
            ),
            i(0)
        }
    ),
    {
        condition = tex_utils.in_mathzone,
        stored =
        {
            ["user_text"] = d(1, get_visual)
        }
    }
),

s(
    {
        trig = "tld",
        dscr = "tilde",
        snippetType = "autosnippet"
    },
    fmta(
        [[\tilde{<>}]],
        d(1, get_visual)
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "ct",
        dscr = "constant",
        snippetType = "autosnippet"
    },
    fmta(
        [[\ct{<>}]],
        i(1, "e")
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = "bin",
        dscr = "binomial",
        snippetType = "autosnippet"
    },
    fmta(
        [[\binom{<>}{<>}]],
        { i(1, "n"), i(2, "k") }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\=emph]],
        dscr = "emphasize",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[\emph{<>}<>]],
        {
            i(1),
            i(0)
        }
    ),
    { condition = tex_utils.in_text }
),

s(
    {
        trig = "Pwr",
        dscr = "power set"
    },
    fmta(
        [[\mathscr{P}(<>)<>]],
        {
            i(1, [[\mathbf{N}]]),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\=defq]],
        dscr = "est défini par",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    t([[\defeq ]]),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\=sprod]],
        dscr = "produit scalaire",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[\sprod<>{<>}{<>}<>]],
        {
            c(
                1,
                {
                    t(""),
                    t("[\\big]"),
                    t("[\\Big]"),
                    t("[\\bigg]"),
                    t("[\\Bigg]")
                }
            ),
            i(2),
            i(3),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\=math\(open\|close\)]],
        dscr = "math[open/close]",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[\math<>{<>}<>]],
        {
            f(function(_, snip) return snip.captures[1] end),
            d(1, get_visual),
            i(0)
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s(
    {
        trig = [[\\\@<!vec]],
        dscr = "vector",
        trigEngine = "vim",
        snippetType = "autosnippet"
    },
    fmta(
        [[\vec{<>}<>]],
        {
            d(1, get_visual, {}, { user_args = { [[\nabla]] } }),
            i(0)
        }
    ),
    { condtion = tex_utils.in_mathzone }
),

}

-- for k, v in pairs(greek_letters) do
--     table.insert(
--         snippets,
--         s(
--             {
--                 trig = ";"..k,
--                 dscr = v,
--                 wordTrig = false,
--                 snippetType = "autosnippet"
--             },
--             t(v),
--             { condition = tex_utils.in_mathzone }
--         )
--     )
-- end

return snippets
