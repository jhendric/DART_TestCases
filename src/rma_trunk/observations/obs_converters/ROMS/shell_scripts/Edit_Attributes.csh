#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: Edit_Attributes.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

set BASE = /glade/p/work/thoar/roms/test/WC13/OldData/ 

foreach FILE ( obs_wc13_merged_2013+07d_pp1_depthinmeters_dt5400_nobio.nc \
               obs_wc13_merged_2013+07d_pp1_depthinmeters_dt5400_nobio.nc \
               obs_wc13_merged_2013+07d_pp1_depthinmeters_dt5400_nobio.nc )

cp -v ${BASE}/${FILE} .

ncatted -a    units,survey_time,m,c,'days since 1900-01-01 00:00:00 GMT' \
        -a calendar,survey_time,c,c,'gregorian' \
        -a    units,obs_time,m,c,'days since 1900-01-01 00:00:00 GMT' \
        -a calendar,obs_time,c,c,'gregorian' \
        ${FILE}

end

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/ROMS/shell_scripts/Edit_Attributes.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

