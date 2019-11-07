---
title       : Are your hands in proportion with your height?
subtitle    : A quick tour
author      : Hadrian84
job         : R-enthousiast
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : solarized_light 
widgets     : [bootstrap, quiz]        # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
logo        : Rlogo.png
github:
   user: Hadrian84
   repo: DatascienceAssignment
---

## Introduction

This application asks for four inputs:

- Your name
- Gender
- Height
- Hand length 

It also relies on a dataset containing many body statistics. This dataset is publicly available (ANSUR: [click here](http://mreed.umtri.umich.edu/mreed/downloads.html#ansur)).

For the purpose of this tour, we used randomized data.

---

## First graphs generated

<img src="figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto auto auto 0;" />

Based on your input, it compares your **height** and **hand length** with a representative population. 

It also shows what percentage of people have higher values than you.

--- 

## Summarizing graph

<img src="figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto auto auto 0;" />

This regression plot shows the overall **height** and **hand length** relationship (dotted blue line). As expected, taller people have bigger hands (and vice versa). 

Where you reside in this plot is indicated by the red dot.

--- 

## Concluding graph

<img src="figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto auto auto 0;" />

The final graph uses a segment of the regression plot and displays your **hand length** in the hand length distribution of people with your height. 

Again, it shows what percentage of people (with your height) have bigger hands than you.
