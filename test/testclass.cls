%&latex
\ProvidesClass{testclass}

%%% Content of the minimal class:
\renewcommand\normalsize{\fontsize{10pt}{12pt}\selectfont}

\setlength{\textwidth}{6.5in}
\setlength{\textheight}{8in}

\pagenumbering{arabic}
\pagestyle{empty}
%%%

\testmessage{Content of test class}
\AtEndOfClass{\testmessage{AtEndOfClass hook of test class}}

