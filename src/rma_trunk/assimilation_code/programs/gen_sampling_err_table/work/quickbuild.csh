#!/bin/csh 
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: quickbuild.csh 11439 2017-04-06 16:37:59Z nancy@ucar.edu $

#----------------------------------------------------------------------
# compile all programs in the current directory that have a mkmf_xxx file.
#----------------------------------------------------------------------

# this item's name:
set ITEM = "Generate Sampling Error Correction Table"


# ---------------
# shouldn't have to modify this script below here.

\rm -f *.o *.mod 

@ n = 0

foreach TARGET ( mkmf_* )

   set PROG = `echo $TARGET | sed -e 's/mkmf_//'`

   @ n = $n + 1
   echo
   echo "---------------------------------------------------"
   echo "$ITEM build number $n is $PROG" 
   \rm -f $PROG
   csh $TARGET || exit $n
   make        || exit $n

end

echo "Success: All programs compiled."  

\rm -f *.o *.mod  input.nml.*_default

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/gen_sampling_err_table/work/quickbuild.csh $
# $Revision: 11439 $
# $Date: 2017-04-06 10:37:59 -0600 (Thu, 06 Apr 2017) $

