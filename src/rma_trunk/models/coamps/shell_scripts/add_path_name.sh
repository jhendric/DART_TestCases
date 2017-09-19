#!/bin/bash
#
# This code may (or may not) be part of the COAMPS distribution,
# So it is not protected by the DART copyright agreement.
#
# DART $Id: add_path_name.sh 6256 2013-06-12 16:19:10Z thoar $
#
# AUTHOR:   T. R. Whitcomb
#           Naval Research Laboratory
#
# Adds a file name to all entries with path_names at the beginning -
# use this for adding new files into the DART mkmf framework.

for pathfile in `ls -1 path_names*`
do
  echo "$1" >> $pathfile
done

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps/shell_scripts/add_path_name.sh $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $

