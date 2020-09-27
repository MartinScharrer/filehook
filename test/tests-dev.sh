#!/bin/bash

#TESTFILES="includetest InputIfFileExiststest inputtest packagetest classtest"
TESTFILES=${@-*test.tex}


for FILE in $TESTFILES
do
    rm -f *.aux
    echo -en "${FILE//.tex}: "
    pdflatex-dev -interaction=nonstopmode $FILE | grep ^RESULT:
done

