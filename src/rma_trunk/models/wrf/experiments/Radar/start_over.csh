#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: start_over.csh 11545 2017-04-27 18:00:20Z hendric@ucar.edu $

\rm -r advance_temp*
\rm assim_model_state*
\rm filter_control*
\rm dart_log*
\rm filter.*.log
\rm preassim.nc
\rm analysis.nc
\rm blown*.out
\rm obs_seq.final
\rm finished_grid*
\rm last_p*
\rm refl_obs*.txt
\rm finished.g*
\rm WRFOUT/*

exit $status

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/experiments/Radar/start_over.csh $
# $Revision: 11545 $
# $Date: 2017-04-27 12:00:20 -0600 (Thu, 27 Apr 2017) $

