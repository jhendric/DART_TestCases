#!/bin/sh 
#
# This file is not protected by the DART copyright agreement.
# DART $Id: install.sh 11915 2017-08-28 22:58:40Z nancy@ucar.edu $
#
#  ------------------------------------------------------------------------
#  This script will make executables which extract data
#  from ADP BUFR input files, and place the data into a basic text file.
#  prepbufr.x:  used to extract data from prepbufr files
#
#  If you get an error about 'ar' not being found, make sure the
#  directory containing the 'ar' command is part of your path.
#  'which ar' will print the location if this is done correctly.
# 
#  If you get a link or runtime error about 'bort' being undefined, go into
#  the lib directory and read the README_BUFRLIB file about how to fix it.
#  You can do something like:  cc='cc -DUNDERSCORE' to set the flag for all
#  compiles at once.
#
#  Note that some versions of gfortran give bogus warnings
#  about using goto to go to the end of a do loop when compiling
#  the prepbufr library routines.  This is a mistake in the 
#  gfortran warning logic (the lib code is ok), and can be ignored.
#
#  ------------------------------------------------------------------------

set -eua
 
#  ------------------------------------------------------------------------
#  CCOMP, FCOMP - select the compiler combination to use
#    either set in the environment before calling, or set here.
#  ------------------------------------------------------------------------
 
if [ "$CCOMP" == "" ]; then
 CCOMP=gnu
 #CCOMP=intel
 #CCOMP=pgi
 #CCOMP=default
fi

if [ "$FCOMP" == "" ]; then
 FCOMP=gnu
 #FCOMP=intel
 #FCOMP=pgi
 #FCOMP=f77
fi

#  ------------------------------------------------------------------------
#  UNDERSCORE - if needed to link the C and fortran subroutine names
#    either set in the environment before calling, or set here.
#  ------------------------------------------------------------------------

if [ "$UNDERSCORE" == "" ]; then
 #UNDERSCORE=none
 UNDERSCORE=add
fi

#  -----------------------------------------------------
 
if   [ $CCOMP = gnu ] ; then
   cc=gcc ;
elif [ $CCOMP = intel ] ; then
   cc=icc ;
elif [ $CCOMP = pgi ] ;  then
   cc=pgcc ;
else
   cc=cc ;
fi

if   [ $FCOMP = intel ] ; then
   ff=ifort 
elif [ $FCOMP = gnu ] ; then
   ff=gfortran 
elif [ $FCOMP = pgi ] ; then
   ff=pgf90 
elif [ $FCOMP = f77 ] ; then
   ff=f77 
else
   echo error: unrecognized FCOMP name
   exit 1
fi

if [ $UNDERSCORE = add ] ; then
   cc="$cc -DUNDERSCORE"
fi

# in any case, add -O for optimized code
cc="$cc -O"
ff="$ff -O"



#  Compile and archive the Bufr Library
#  ------------------------------------

echo 'Compiling the Bufr library'

cd lib
$ff -c *.f
$cc -c *.c
ar crv bufrlib.a *.o
rm *.o
 
#  Compile and link the decode programs
#  ---------------------------------------

echo 'Compiling the prepbufr programs'

cd ../src
$ff prepbufr.f     ../lib/bufrlib.a -o ../exe/prepbufr.x 
$ff prepbufr_03Z.f ../lib/bufrlib.a -o ../exe/prepbufr_03Z.x 

 
# If needed, compile the 2 auxiliary conversion programs.

#  Compile the binary format converter program
#  ---------------------------------------
 
echo 'Compiling the grabbufr converter program'
 
cd ../convert_bufr
$ff grabbufr.f ../lib/bufrlib.a -o ../exe/grabbufr.x
 
 
#  Compile the block/unblock converter program
#  ---------------------------------------
 
echo 'Compiling the blk/ublk converter program'
 
cd ../blk_ublk
$ff cwordsh.f ../lib/bufrlib.a -o ../exe/cword.x
 

#  clean up
#  --------

echo 'Finished making executables'
cd ..

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/NCEP/prep_bufr/install.sh $
# $Revision: 11915 $
# $Date: 2017-08-28 16:58:40 -0600 (Mon, 28 Aug 2017) $

