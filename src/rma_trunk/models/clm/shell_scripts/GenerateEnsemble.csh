#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: GenerateEnsemble.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $
#
# This script may be used to insert the DART restart conditions into
# a set of CLM history and restart files. All it takes is a single
# CLM history and restart file and 'dart_to_clm' will update the
# netcdf files, one at a time.
#
# To generate all the filter_restart.nnnn files, you can run filter
# with a single 'no-impact' observation (huge error variance),
# filter_nml:start_from_restart = .false.
# ensemble_manager_nml:single_restart_file_in = .true.
#
# This will perturb a single input state with gaussian random noise.
#
# epilogue: this method generates values outside the allowable range -
# and causes CLM to fail. Negative snow cover fractions, for example.
# We will have to modify the clm:model_mod:pert_model_state() routine
# to intelligently perturb a single state if so desired.
#----------------------------------------------------------------------

mv input.nml input.nml.org

foreach FILE ( filter_restart.* )

   set memid = $FILE:e

   cp clm_history.nc clm_history_${memid}.nc
   cp clm_restart.nc clm_restart_${memid}.nc

   sed -e "s/clm_restart.nc/clm_restart_${memid}.nc/" input.nml.org >! input.nml

   ln -sf $FILE dart_restart

   ./dart_to_clm

end

mv input.nml.org input.nml

echo ""
echo "Finished at "`date`

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/clm/shell_scripts/GenerateEnsemble.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

