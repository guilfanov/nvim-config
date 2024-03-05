local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return
{

    s(
        {
            trig = "template",
            dscr = "Basic template"
        },
        fmta(
            [[
                \documentclass[12pt, a4paper]{article}

                \usepackage[a4paper, left=3cm, right=3cm, top=2.5cm, bottom=2.5cm]{geometry}
                \usepackage[utf8]{inputenc}
                \usepackage[T1]{fontenc}
                \usepackage{textcomp}
                \usepackage[english, french]{babel}

                \usepackage{amsmath, amssymb, amsthm}
                \usepackage{mathtools}
                \usepackage{enumitem}


                % figure support
                \usepackage{import}
                \usepackage{xifthen}
                \pdfminorversion=7
                \usepackage{pdfpages}
                \usepackage{transparent}
                \newcommand{\incfig}[1]{%
                    \def\svgwidth{\columnwidth}
                    \import{./figures/}{#1.pdf_tex}
                }

                \pdfsuppresswarningpagegroup=1

                \DeclarePairedDelimiter\abs{\lvert}{\rvert}

                \newtheoremstyle{exercice}% name of the style to be used
                    {\topsep}% measure of space to leave above the theorem. E.g.: 3pt
                    {\topsep}% measure of space to leave below the theorem. E.g.: 3pt
                    { }% name of font to use in the body of the theorem
                    {0pt}% measure of space to indent
                    {\bfseries}% name of head font
                    {.}% punctuation between head and body
                    { }% space after theorem head; " " = normal interword space
                    {\thmname{#1}\thmnumber{ #2}\textnormal{\thmnote{ (#3)}}}

                \theoremstyle{remark}
                \newtheorem*{solution}{Solution}
                \newenvironment{preuve}{\renewcommand{\proofname}{Preuve}\begin{proof}}{\end{proof}}

                \begin{document}
                    <>
                \end{document}
            ]],
            { i(0) }
        ),
        { condition = line_begin }
    ),

    s(
        {
            trig = "templatetitresf",
            dscr = "Template for preamble and title in french, sections in sans"
        },
        fmta(
            [[
                \documentclass[12pt, a4paper, titlepage]{scrartcl}

                \usepackage[a4paper, left=3cm, right=3cm, top=4.5cm, bottom=5.5cm]{geometry}
                \usepackage{lmodern}

                \usepackage[utf8]{inputenc}
                \usepackage[T1]{fontenc}
                \usepackage[english, french]{babel}

                \usepackage{amsmath, amssymb, amsthm}
                \usepackage{mathtools}
                \usepackage{enumitem}

                \usepackage{hyperref}

                \newcommand*{\diff}{\mathop{}\!\mathrm{d}}
                \newcommand*{\ct}[1]{\text{\rmfamily\upshape #1}}

                \DeclarePairedDelimiter\abs{\lvert}{\rvert}

                \newtheoremstyle{exercice}% name of the style to be used
                    {\topsep}% measure of space to leave above the theorem. E.g.: 3pt
                    {\topsep}% measure of space to leave below the theorem. E.g.: 3pt
                    { }% name of font to use in the body of the theorem
                    {0pt}% measure of space to indent
                    {\bfseries}% name of head font
                    {.}% punctuation between head and body
                    { }% space after theorem head; " " = normal interword space
                    {\thmname{#1}\thmnumber{#2}\textnormal{\thmnote{ (#3)}}}

                \theoremstyle{remark}
                \newtheorem*{solution}{Solution}
                \newenvironment{preuve}{\renewcommand{\proofname}{Preuve}\begin{proof}}{\end{proof}}

                \begin{document}

                    \begin{titlepage}

                        \center

                        {
                            <>\bigskip

                            <>
                        }
                        \bigskip

                        \rule{\linewidth}{0.5mm} \\[0.4cm]
                        {\LARGE\bfseries\sffamily <>} \\[0.4cm]
                        \rule{\linewidth}{0.5mm} \\[1.5cm]

                        \begin{minipage}{0.4\textwidth}
                            \begin{flushleft}
                                \emph{Enseigné par :} \\
                                <>
                            \end{flushleft}
                        \end{minipage}
                        ~
                        \begin{minipage}{0.4\textwidth}
                            \begin{flushright}
                                \emph{Notes par :} \\
                                <>
                            \end{flushright}
                        \end{minipage}

                        \vfill 

                        <>
                        <>

                    \end{titlepage}

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    \newgeometry{left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}
                    \tableofcontents
                    \thispagestyle{empty}

                    \newpage
                    \
                    \thispagestyle{empty}
                    \newpage

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    <>

                \end{document}
            ]],
            {
                i(1, "MAT1131"),
                i(2, "Q2 2024"),
                i(3, "Algèbre Linéaire"),
                i(4, [[Prof.~G.~\textsc{Marino}]]),
                i(5, [[Raphaël \textsc{Guilfanov}]]),
                i(6, [[Les commentaires et corrections sont à adresser à \\href{mailto:raphael.guilfanov@student.uclouvain.be}{\\texttt{raphael.guilfanov@student.uclouvain.be}}\par\bigskip]]),
                i(7, [[Imprimé le \today]]),
                i(0)
            }
        )
    ),

    s(
        {
            trig = "templatetitre",
            dscr = "Template for preamble and title in french"
        },
        fmta(
            [[
                \documentclass[12pt, a4paper, titlepage]{article}

                \usepackage[a4paper, left=3cm, right=3cm, top=4.5cm, bottom=5.5cm]{geometry}
                \usepackage{lmodern}
                \usepackage[utf8]{inputenc}
                \usepackage[T1]{fontenc}
                \usepackage[english, french]{babel}

                \usepackage{amsmath, amssymb, amsthm}
                \usepackage{mathtools}
                \usepackage{enumitem}

                \usepackage{hyperref}

                \newcommand*{\diff}{\mathop{}\!\mathrm{d}}
                \newcommand*{\ct}[1]{\text{\rmfamily\upshape #1}}
                
                \DeclarePairedDelimiter\abs{\lvert}{\rvert}

                \newtheoremstyle{exercice}% name of the style to be used
                    {\topsep}% measure of space to leave above the theorem. E.g.: 3pt
                    {\topsep}% measure of space to leave below the theorem. E.g.: 3pt
                    { }% name of font to use in the body of the theorem
                    {0pt}% measure of space to indent
                    {\bfseries}% name of head font
                    {.}% punctuation between head and body
                    { }% space after theorem head; " " = normal interword space
                    {\thmname{#1}\thmnumber{#2}\textnormal{\thmnote{ (#3)}}}

                \theoremstyle{remark}
                \newtheorem*{solution}{Solution}
                \newenvironment{preuve}{\renewcommand{\proofname}{Preuve}\begin{proof}}{\end{proof}}

                \begin{document}

                    \begin{titlepage}

                        \center

                        {
                            <>\bigskip

                            <>
                        }
                        \bigskip

                        \rule{\linewidth}{0.5mm} \\[0.4cm]
                        {\LARGE\bfseries\sffamily <>} \\[0.4cm]
                        \rule{\linewidth}{0.5mm} \\[1.5cm]

                        \begin{minipage}{0.4\textwidth}
                            \begin{flushleft}
                                \emph{Enseigné par :} \\
                                <>
                            \end{flushleft}
                        \end{minipage}
                        ~
                        \begin{minipage}{0.4\textwidth}
                            \begin{flushright}
                                \emph{Notes par :} \\
                                <>
                            \end{flushright}
                        \end{minipage}

                        \vfill 

                        <>
                        <>

                    \end{titlepage}

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    \newgeometry{left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}
                    \tableofcontents
                    \thispagestyle{empty}

                    \newpage
                    \
                    \thispagestyle{empty}
                    \newpage

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    <>

                \end{document}
            ]],
            {
                i(1, "MAT1131"),
                i(2, "Q2 2024"),
                i(3, "Algèbre Linéaire"),
                i(4, [[Prof.~G.~\textsc{Marino}]]),
                i(5, [[Raphaël \textsc{Guilfanov}]]),
                i(6, [[Les commentaires et corrections sont à adresser à \href{mailto:raphael.guilfanov@student.uclouvain.be}{\texttt{raphael.guilfanov@student.uclouvain.be}}\par\bigskip]]),
                i(7, [[Imprimé le \today]]),
                i(0)
            }
        ),
        { condition = line_begin }
    ),

    s(
        {
            trig = "instagram",
            dscr = "template for instagram post"
        },
        fmta(
            [[
                \documentclass[12pt]{article}

                \usepackage{mathtools}
                \usepackage{amssymb}

                \usepackage[paperwidth=540pt, paperheight=540pt]{geometry}
                \usepackage[dvipsnames]{xcolor}
                \usepackage{lmodern}

                \newcommand*{\ct}[1]{\text{\rmfamily\upshape #1}}
                \newcommand*{\diff}{\mathop{}\!\mathrm{d}}

                \DeclarePairedDelimiter\abs{\lvert}{\rvert}

                \pagestyle{empty}

                \begin{document}

                    \vspace*{\fill}
                    <>
                    \vfill
                    <>
                \end{document}
            ]],
            {
                i(1), i(0)
            }
        ),
        { condition = line_begin }
    ),
    
    s(
        {
            trig = "templateintro",
            dscr = "template pour intro à la démarche mathématique"
        },
        fmta(
            [[
                \input{/Users/raph/University/Bac1/Q2/Intro/tex/preamble}

                \begin{document}
                    <>
                \end{document}
            ]],
            { i(1) }
        ),
        { condition = line_begin }
    ),
}
