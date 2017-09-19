#!/bin/tcsh 
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: job_setup.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $
#
########################################################################
#
# SCRIPT:	job_setup.csh
# AUTHOR:	T. R. Whitcomb
#           Naval Research Laboratory
#
# Sets up the configuration (e.g. Linux modules) for a script run
# in a resource manager - this file is not executed, but is sourced
# by various run scripts.
######

# These are based on the ACESGrid setup at MIT
if ( -f /etc/profile.d/modules.csh ) then
    source /etc/profile.d/modules.csh
endif
module load mpich/pgi
module load mpiexec

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/shell_scripts/COAMPS_RESTART_SCRIPTS/job_setup.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

