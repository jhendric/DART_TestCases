#!/bin/bash
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_all_dots.sh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

# run dot on all dot files
# The DOT language is a plain text graph language:
# http://www.graphviz.org/content/dot-language
# If you have doxygen installed you probably have 
# already installed dot.
# see forward_operator.gv for a simple example.

for f in *.gv

do

  dot $f -Tsvg -o $f'.svg'
  #dot $f -Tpdf -o $f'.pdf'

done

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/Graphs/run_all_dots.sh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

