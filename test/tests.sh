#!/bin/bash

#TESTFILES="includetest InputIfFileExiststest inputtest packagetest classtest"
TESTFILES=${@-*test.tex}

rm -f *.aux

for FILE in $TESTFILES
do
    echo -en "${FILE//.tex}: "
    pdflatex $FILE | grep ^RESULT:
done

