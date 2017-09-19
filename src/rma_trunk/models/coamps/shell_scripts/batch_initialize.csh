#!/bin/tcsh 
#
# This code may (or may not) be part of the COAMPS distribution,
# So it is not protected by the DART copyright agreement.
#
# DART $Id: batch_initialize.csh 6256 2013-06-12 16:19:10Z thoar $
#
# AUTHOR:	T. R. Whitcomb
#           Naval Research Laboratory
#
# Runs perfect_model_obs as a PBS job
######
#PBS -N initialize_dart
#PBS -r n
#PBS -e initialize_dart.err
#PBS -o initialize_dart.out
#PBS -q one
#PBS -l nodes=1:ppn=1

set DART_SCRIPTS     = /net/ds-0b/export/DART/models/coamps/shell_scripts
set PATH_CONFIG_FILE = /path/to/paths.config/file

# Import the job-specific resource commands
source ${DART_SCRIPTS}/job_setup.csh

${DART_SCRIPTS}/initialize_dart.sh -c ${PATH_CONFIG_FILE}

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps/shell_scripts/batch_initialize.csh $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $

