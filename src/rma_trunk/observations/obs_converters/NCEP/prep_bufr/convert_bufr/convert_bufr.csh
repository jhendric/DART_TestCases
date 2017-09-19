#!/bin/csh
#
# This file is not protected by the DART copyright agreement.
# DART $Id: convert_bufr.csh 6256 2013-06-12 16:19:10Z thoar $

 set FC = ifort
 # or pgf90, gfortran, xlf90, g95, etc
 set FCFLAGS = "-r8 -pc 64"

 \rm -f *.o

 ${FC} -o stat_test.x ${FCFLAGS} stat_test.f
 ${FC} -o arg_test.x ${FCFLAGS} arg_test.f
 ${FC} -o ../exe/grabbufr.x ${FCFLAGS} grabbufr.f ../lib/bufrlib.a

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/NCEP/prep_bufr/convert_bufr/convert_bufr.csh $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $

