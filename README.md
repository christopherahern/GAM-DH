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

The data file contains the following columns:
* File - A code to uniquely identify individual speakers. The two digits after PH indicate the year of recording.
* code - The auditory code for pronunciation of DH, as assigned in [Tamminga (2014)](). Takes the following values:
  * 1 - fricative (them)
  * 2 - affricate (dthem)
  * 9 - absent ('em)
  * 0 - stop/flap (dem)
* PrevDH - The value of "code" for the previous token. Note that this does not always correspond to the previous row in the file; if there was an interruption PrevDH will be NA.
* Lag - The time elapsed in seconds between the current and previous token (i.e. between code and PrevDH).
* Seg_Start - The timestamp of the left edge of the DH segment in the FAVE-aligned Praat textgrid, in seconds.
* Seg_End - The timestamp of the right edge of the DH segment in the FAVE-aligned Praat textgrid, in seconds.
* Word - The word containing the current token.
* Word_Start - The timestamp of the left edge of the word containing the token in the FAVE-aligned Praat textgrid, in seconds.
* Word_End - The timestamp of the right edge of the word containing the token in the FAVE-aligned Praat textgrid, in seconds.
* PrevWord - The word containing the previous token.
* Pre_Seg - The segment preceding DH, in ARPAbet.
* Pre_Seg_Start - The timestamp for the start of the preceding segment, in seconds.
* Pre_Seg_End - The timestamp for the end of the preceding segment, in seconds.
* Post_Seg - The segment following DH, in ARPAbet.
* Post_Seg_Start - The timestamp for the start of the following segment, in seconds.
* Post_Seg_End - The timestamp for the end of the following segment, in seconds.
* Window - The duration in seconds of the window containing 7 words centered around the DH token.
* Vowels_per_Second - The vowels per second contained in the Window.


## Code

To obtain the code either download the files as a [ZIP](https://github.com/christopherahern/GAM-DH/archive/master.zip),
 or clone the repository:

    git clone https://github.com/christopherahern/GAM-DH.git

To run the code, execute the following in `src/`, figures can be found in `local/out`:

    Rscript code.R

To run the interactive notebook, we recommend installing the 
[Anaconda](https://www.continuum.io/downloads) python distribution, and then installing
the [R kernel](https://irkernel.github.io/) for [Jupyter](http://jupyter.org/) notebooks.
Once you've done so, execute the following in `src/`:

    ipython notebook


The output of the notebook can also be viewed
 [here](http://nbviewer.jupyter.org/github/christopherahern/GAM-DH/blob/master/src/code.ipynb)
without installing any additional software. 


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

If you have comments or questions about anything, feel free to email tamminga@ling.upenn.edu 
or [create an issue](https://github.com/christopherahern/GAM-DH/issues) on github.
