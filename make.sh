#!/bin/bash

# (1) Run the Rscript
Rscript src/code.R
cd tex
pdflatex *.tex
pdflatex *.tex


