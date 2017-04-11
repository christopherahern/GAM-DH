# Description

This repository contains the source code for the paper entitled 
"Generalized Additive Mixed Models for intraspeaker variation"
by [Meredith Tamminga](https://www.meredithtamminga.com), [Christopher Ahern](http://christopherahern.github.io/)
 and [Aaron Ecay](http://www.aaronecay.com) published in a special issue of [Linguistics Vanguard](https://www.degruyter.com/view/j/lingvan.2016.2.issue-s1/issue-files/lingvan.2016.2.issue-s1.xml) on Psycholinguistics and Language Variation..


# Instructions

## Data

The data used in this paper come from the [Philadelphia Neighborhood Corpus](http://fave.ling.upenn.edu/pnc.html)
 and were coded as described in [Tamminga (2014) (PDF)](http://www.meredithtamminga.com/documents/Tamminga_dissertation.pdf). The data can be
found in `data/dh-PNC.csv` and consist of 14,323 tokens with word-initial DH (*this* vs. *dis*) from interviews with 42 white working-class 
Philadelphian English speakers.

The data file contains the following columns:
* speaker - A code to uniquely identify individual speakers. 
* code - The auditory code for pronunciation of DH, as assigned in Tamminga (2014). Takes the following values:
  * 1 - fricative (them)
  * 2 - affricate (dthem)
  * 0 - stop/flap (dem)
  * 9 - absent ('em) (has already been excluded from dataset)
* PrevDH - The value of "code" for the previous token. Note that this does not necessarily correspond to the previous row in the file.
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
* Gender - Speaker gender.
* birthyear - Speaker birthyear.
* age - Speaker age.
* obs - The variant used in the current token, recoded to be binary. Dependent variable used in the R code for the GAMs.
  * 1 - fricative or affricate
  * 0 - stop/flap
* prev - The variant used in the previous token, recoded to be binary. 
* PreSeg2 - The segment preceding DH by category
* post.pause - whether the observation follows a pause



## Code

To obtain the code either download the files as a [ZIP](https://github.com/christopherahern/GAM-DH/archive/master.zip),
 or clone the repository:

    git clone https://github.com/christopherahern/GAM-DH.git

To run the code and compile the document, just run `make.sh`:

    ./make.sh

To just run the code, which will output figures to `local/`:

    Rscript src/code.R

To run the interactive notebook, we recommend installing the 
[Anaconda](https://www.continuum.io/downloads) python distribution, and then installing
the [R kernel](https://irkernel.github.io/) for [Jupyter](http://jupyter.org/) notebooks.
Once you've done so, execute the following in `src/`:

    jupyter notebook


The output of the notebook can also be viewed
 [here](http://nbviewer.jupyter.org/github/christopherahern/GAM-DH/blob/master/src/code.ipynb)
without installing any additional software. 


# Document

To compile the document, run the following twice in `tex/`:

    pdflatex *.tex

# Citation

If you want to cite this paper, please use the following:

> Tamminga, Meredith, Christopher Ahern and Aaron Ecay. Generalized Additive Mixed Models for intraspeaker variation. Linguistics Vanguard, Volume 2, Issue S1, Pages 33-41, 2016.

If you reference the results of this paper, please also cite [the Philadelphia Neighborhood Corpus](http://fave.ling.upenn.edu/pnc.html).


# Comments

If you have comments or questions about anything, feel free to email tamminga@ling.upenn.edu 
or [create an issue](https://github.com/christopherahern/GAM-DH/issues) on github.
