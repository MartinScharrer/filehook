PACKAGE=filehook
CONTRIBUTION  = ${PACKAGE}
NAME          = Martin Scharrer
EMAIL         = martin@scharrer-online.de
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
DONOTANNOUNCE = 0
LICENSE       = free
FREEVERSION   = lppl
FILE          = /tmp/${CONTRIBUTION}.tar.gz
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE

upload: ctanify
	ctanupload -p

MV=mv
LATEX=pdflatex

all: package doc

package: ${PACKAGE}.sty

doc: ${PACKAGE}.pdf

${PACKAGE}.sty: ${PACKAGE}.ins ${PACKAGE}.dtx
	yes | pdflatex $<

%.pdf: %.dtx %.sty
	${LATEX} $*.dtx
	-makeindex -s gind.ist -o $*.ind $*.idx
	-makeindex -s gglo.ist -o $*.gls $*.glo
	${LATEX} $*.dtx
	${LATEX} $*.dtx

ctanify: ${PACKAGE}.dtx ${PACKAGE}.ins ${PACKAGE}.pdf README Makefile
	-pdfopt ${PACKAGE}.pdf temp.pdf && ${MV} temp.pdf ${PACKAGE}.pdf
	ctanify $^

clean:
	latexmk -C ${PACKAGE}.dtx

install: package doc
	-@mkdir -p ${HOME}/texmf/tex/latex/filehook/ 2>/dev/null || true
	-@mkdir -p ${HOME}/texmf/doc/latex/filehook/ 2>/dev/null || true
	@cp -v ${PACKAGE}*.sty ${HOME}/texmf/tex/latex/filehook/
	@cp -v ${PACKAGE}.pdf ${HOME}/texmf/doc/latex/filehook/
	texhash ${HOME}/texmf

