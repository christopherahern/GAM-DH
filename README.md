# Description

This repository contains the source code for the paper entitled 
"Disentangling sources of temporal clustering in intraspeaker variation using Generalized Additive Models"
by [Meredith Tamminga](https://www.meredithtamminga.com), [Christopher Ahern](http://christopherahern.github.io/)
 and [Aaron Ecay](http://www.aaronecay.com).


# Instructions

## Data

The data used in this paper come from the [Philadelphia Neighborhood Corpus](http://fave.ling.upenn.edu/pnc.html)
 and were coded as described in [Tamminga (2014)](). The data consist
of 14,323 tokens with word-initial DH (*this* vs. *dis*) from interviews with 42 white working-class 
Philadelphian English speakers.


## Code

To obtain the code either download the files as a [ZIP](https://github.com/christopherahern/GAM-DH/archive/master.zip),
 or clone the repository:

    git clone https://github.com/christopherahern/GAM-DH.git

To run the code, execute the following in `src`, figures can be found in `local/out`:

    Rscript code.R


In the future we plan to:
* [Convert script to interactive notebook]()
* ...


# Document

To compile the document, run the following in `tex/`:

    pdflatex *.tex

# Citation

If you want to cite this paper, please use the following:

> Tamminga, Meredith, Christopher Ahern and Aaron Ecay. Disentangling sources of temporal clustering in intraspeaker variation using Generalized Additive Models. 2016

If you reference the results of this paper, please also cite [the Philadelphia Neighborhood Corpus](http://fave.ling.upenn.edu/pnc.html)
 used:


    @article{labov-etal:2013,
      title={One hundred years of sound change in Philadelphia: Linear incrementation, reversal, and reanalysis},
      author={Labov, William and Rosenfelder, Ingrid and Fruehwald, Josef},
      journal={Language},
      volume={89},
      number={1},
      pages={30--65},
      year={2013}
    }


# Comments

If you have comments or questions about anything, feel free to email meredith.tamminga@gmail.com 
or [create an issue](https://github.com/christopherahern/GAM-DH/issues) on github.
