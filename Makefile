PACKAGE=filehook
CONTRIBUTION  = ${PACKAGE}
NAME          = Martin Scharrer
EMAIL         = martin@scharrer-online.de
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = lppl
FILE          = ${CONTRIBUTION}.tar.gz
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE

upload: ctanify
	ctanupload -p

MV=mv
LATEX=pdflatex
TEXMF=${HOME}/texmf

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

install: ctanify
	@-mkdir .install
	tar -xz -C .install -f ${FILE}
	cd .install && unzip ${CONTRIBUTION}.tds.zip -d ${TEXMF} 
	texhash ${HOME}/texmf
	${RM} .install

