CONTRIBUTION  = filehook
NAME          = Martin Scharrer
EMAIL         = martin@scharrer-online.de
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = lppl
CTAN_FILE     = ${CONTRIBUTION}.tar.gz
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION CTAN_FILE


MAINDTX       = ${CONTRIBUTION}.dtx
DTXFILES      = ${MAINDTX}
INSFILES      = ${CONTRIBUTION}.ins
LTXFILES      = ${CONTRIBUTION}.sty
LTXDOCFILES   = ${CONTRIBUTION}.pdf README
LTXSRCFILES   = ${DTXFILES} ${INSFILES}
ALLFILES      = ${DTXFILES} ${INSFILES} ${LTXFILES} ${LTXDOCFILES} ${LTXSRCFILES}
CTANFILES     = ${ALLFILES}

TDSZIP      = ${CONTRIBUTION}.tds.zip

TEXMF       = ${HOME}/texmf
LTXDIR      = ${TEXMF}/tex/latex/${CONTRIBUTION}/
LTXDOCDIR   = ${TEXMF}/doc/latex/${CONTRIBUTION}/
LTXSRCDIR   = ${TEXMF}/source/latex/${CONTRIBUTION}/

TDSDIR   = tds
TDSFILES = ${DTXFILES} ${INSFILES} ${LTXFILES} ${LTXDOCFILES} ${LTXSRCFILES}

BUILDDIR = build

LATEXMK  = latexmk -pdf -quiet
ZIP      = zip -r
AUXEXTS  = .aux .bbl .blg .cod .exa .fdb_latexmk .glo .gls .lof .log .lot .out .pdf .que .run.xml .sta .stp .svn .svt .toc
CLEANFILES = $(addprefix ${CONTRIBUTION}, ${AUXEXTS})


.PHONY: all upload doc clean install uninstall


all: doc

${CTAN_FILE}: ${CTANFILES}
	${MAKE} --no-print-directory build


upload: VERSION = $(strip $(shell grep '=\*VERSION' -A1 ${MAINDTX} | tail -n1))

upload: ${CTAN_FILE}
	ctanupload -p


doc: ${CONTRIBUTION}.pdf

${CONTRIBUTION}.pdf: ${DTXFILES} README ${INSFILES} ${LTXFILES}
	${MAKE} --no-print-directory build
	cp "${BUILDDIR}/$@" "$@"


build: ${DTXFILES} README ${INSFILES} ${LTXFILES}
	-mkdir ${BUILDDIR} 2>/dev/null || true
	cp ${INSFILES} README ${BUILDDIR}/
	$(foreach DTX,${MAINDTX}, tex '\input ydocincl\relax\includefiles{${DTX}}{${BUILDDIR}/${DTX}}' && ${RM} ydocincl.log;)
	cd ${BUILDDIR}; $(foreach INS, ${INSFILES}, tex ${INS};)
	cd ${BUILDDIR}; $(foreach DTX, ${MAINDTX}, ${LATEXMK} ${DTX};)


clean:
	latexmk -C ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r ${BUILDDIR} ${TDSDIR} ${CTAN_FILE}


distclean:
	latexmk -c ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r ${BUILDDIR} ${TDSDIR}

install: build $(addprefix ${BUILDDIR}/,${TDSFILES})
ifneq ($(strip $(LTXFILES)),)
	test -d "${LTXDIR}" || mkdir -p "${LTXDIR}"
	cd ${BUILDDIR} && cp ${LTXFILES} "$(abspath ${LTXDIR})"
endif
ifneq ($(strip $(LTXSRCFILES)),)
	test -d "${LTXSRCDIR}" || mkdir -p "${LTXSRCDIR}"
	cd ${BUILDDIR} && cp ${LTXSRCFILES} "$(abspath ${LTXSRCDIR})"
endif
ifneq ($(strip $(LTXDOCFILES)),)
	test -d "${LTXDOCDIR}" || mkdir -p "${LTXDOCDIR}"
	cd ${BUILDDIR} && cp ${LTXDOCFILES} "$(abspath ${LTXDOCDIR})"
endif
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


tdsdir: TEXMF=${TDSDIR}
tdsdir: install

tdszip: ${TDSZIP}

${TDSZIP}: tdsdir
	cd ${TDSDIR} && ${ZIP} $(abspath $@) *


installsymlinks:
	test -d "${LTXDIR}" || mkdir -p "${LTXDIR}"
	-cd ${LTXDIR} && ${RM} ${LTXFILES}
	ln -s $(abspath ${LTXFILES}) ${LTXDIR}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


uninstall:
	${RM} ${LTXDIR} ${LTXDOCDIR} ${LTXSRCDIR} \
		${GENERICDIR} ${GENDOCDIR} ${GENSRCDIR} \
		${PLAINDIR} ${PLAINDOCDIR} ${PLAINSRCDIR} \
		${SCRIPTDIR} ${SCRDOCDIR}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


