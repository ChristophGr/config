#!/bin/sh
gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$HOME/merged.pdf -dBATCH "$@"
