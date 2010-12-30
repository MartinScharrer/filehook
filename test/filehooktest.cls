%&pdflatex
\ProvidesClass{filehooktest}
\LoadClass{minimal}

\usepackage{filehook}[2010/12/29]

\def\test#1{%
  \def\testmessages{}%
}

\def\endtest{%
  \ifx\testmessages\thereference
    \message{^^JRESULT: SUCCESS!^^J}%
  \else
    \message{^^JRESULT: FAILURE: test messages differ from reference^^J}%
    \show\testmessages
    \show\thereference
  \fi
}

\def\testmessage#1{%
    \g@addto@macro\testmessages{#1^^J}%
}

\def\reference{%
    \begingroup
    \endlinechar=\newlinechar
    \reference@
}

\def\reference@#1{%
    \endgroup
    \def\thereference{#1}%
}

\endinput
