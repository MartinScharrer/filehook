#!/bin/bash

TESTFILES="includetest InputIfFileExiststest inputtest packagetest classtest"

for FILE in $TESTFILES
do
    echo -en "$FILE: "
    pdflatex $FILE | grep ^RESULT:
done

