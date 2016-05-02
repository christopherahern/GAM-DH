# Description

This repository contains the source code for the paper entitled 
"Disentangling sources of temporal clustering in intraspeaker variation using Generalized Additive Models"
by [Meredith Tamminga](https://www.meredithtamminga.com), [Christopher Ahern](http://christopherahern.github.io/)
 and [Aaron Ecay](http://www.aaronecay.com).


# Instructions

## Data

The data used in this paper come from the [Philadelphia Neighborhood Corpus]()
(cite) and were coded as described in [Tamminga (2014)](). The data consist
of 14,323 tokens with word-initial DH (this vs. dis) from 42 speakers.


## Code

To obtain the code either download the files as a [ZIP](https://github.com/christopherahern/GAM-DH/archive/master.zip),
 or clone the repository:

    git clone https://github.com/christopherahern/GAM-DH.git

To run the code, execute the following in `src`, figures can be found in `local/out`::

    Rscript code.R


In the future we plan to:
* [Convert script to interactive notebook]()
* [Add make.sh script to automate analysis]() 
* ...


# Document

To compile the document, run the following in `tex/`:

    pdflatex *.tex

# Citation

If you want to cite this paper, please use the following:

> Tamminga, Meredith, Christopher Ahern and Aaron Ecay. Disentangling sources of temporal clustering in intraspeaker variation using Generalized Additive Models. 2016

If you reference the results of this paper, please also cite [the corpus](https://www.ling.upenn.edu/)
 used:

> Philadelphia Neighborhood Corpus

# Comments

If you have comments or questions about anything, feel free to email meredith.tamminga@gmail.com 
or [create an issue](https://github.com/christopherahern/GAM-DH/issues) on github.
