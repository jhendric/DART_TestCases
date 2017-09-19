#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: run_obs_seq_tool_gpspw.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

# Combine conus and globe gpspw data.

set ddir = /glade/p/nmmm0024/syha/OBS_SEQ/GPSPW
set rdir = /glade/p/nmmm0024/syha/OBS_SEQ/work

cd $ddir
set fs = ( obs_seq.gpspw.globe.201206* )

cd $rdir
foreach fg ( $fs )
 set  d = `echo $fg | cut -d . -f4`
 set  f = obs_seq.gpspw.$d
 set fc = obs_seq.gpspw.conus.$d
 echo Making $f...

cat >! seq_tool.sed << EOF

&obs_sequence_tool_nml
   filename_seq         = '$ddir/$fg','$ddir/$fc',
   filename_out         = '$ddir/$f',
   num_input_files      = 2,
   first_obs_days       = -1,
   first_obs_seconds    = -1,
   last_obs_days        = -1,
   last_obs_seconds     = -1,
   obs_types            = '',
   keep_types           = .false.,
   print_only           = .false.,
   gregorian_cal        = .true., /
EOF

  cat input.nml.no_obs_seq_tool seq_tool.sed > input.nml
 obs_sequence_tool > obs_seq_tool.gpspw.$d.log
 if(! -e $ddir/$f) then
    echo No $ddir/$f. Exit.
    exit
 endif
 ls -l $ddir/$f
end

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/obs_converters/GPSPW/shell_scripts/run_obs_seq_tool_gpspw.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

