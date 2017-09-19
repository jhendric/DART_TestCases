#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_wrfreal.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

# Purpose: Run WRFV2 real.exe.

#-----------------------------------------------------------------------
# [1] Required environment variables:
#-----------------------------------------------------------------------

setenv NC                 $1
setenv WRF_DIR            $2

#-----------------------------------------------------------------------
# [2] Run real.exe:
#-----------------------------------------------------------------------

cd ${WRF_DIR}/test/em_real

echo "   Running real.exe"
real.exe >>& ./run_real_${NC}.out

mv namelist.input namelist.input_${NC}
mv rsl.out.0000 rsl.out.0000_${NC}
mv rsl.error.0000 rsl.error.0000_${NC}

echo ""

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/shell_scripts/run_wrfreal.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

