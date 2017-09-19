#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_sept.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

@ day = 244

#cp input.nml inputDOY244.nml

while ( $day <= 273 ) 

 sed s/244/${day}/ inputDOY244.nml >! input.nml
 convert_aura

 @ day = $day + 1

end

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/AURA/work/run_sept.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

