#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: perfect_model.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

# This block is an attempt to localize all the machine-specific
# changes to this script such that the same script can be used
# on multiple platforms. This will help us maintain the script.

echo "`date` -- BEGIN CESM PERFECT MODEL"

${CASEROOT}/cam_perfect_model.csh
if ( $status != 0 ) exit $status
${CASEROOT}/pop_perfect_model.csh
if ( $status != 0 ) exit $status
${CASEROOT}/clm_perfect_model.csh
if ( $status != 0 ) exit $status

echo "`date` -- END CESM PERFECT MODEL"

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/CESM/shell_scripts/perfect_model.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

