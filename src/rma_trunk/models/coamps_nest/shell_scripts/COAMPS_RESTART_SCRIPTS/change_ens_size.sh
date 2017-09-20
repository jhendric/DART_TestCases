#!/bin/bash
#
# This code may (or may not) be part of the COAMPS distribution,
# So it is not protected by the DART copyright agreement.
#
# DART $Id: change_ens_size.sh 6256 2013-06-12 16:19:10Z thoar $
#
########################################################################
#
# SCRIPT:   change_ens_size.sh
# AUTHOR:   T. R. Whitcomb
#           Naval Research Laboratory
#
# Script to change the ensemble size for an ensemble that has already been
# created and initialized.  If the ensemble size is lower than the original
# no further actions are necessary.  If the ensemble size is higher than
# the original, then initialize_ensemble.sh should be called again.
#
# The command line argument specifies the new ensemble size.
######

export new_ens_size=$1

echo "New ensemble size is $new_ens_size"
echo "Updating ensemble size count to ${new_ens_size}..."
echo "  initialize_ensemble.sh - NUM_MEMS"
perl -i.bak -p -e "s/(NUM_MEMS)=\d+/\1=${new_ens_size}/" initialize_ensemble.sh
echo "  run_filter.csh - num_ens"
perl -i.bak -p -e "s/(num_ens)\s*=\s*\d+/\1 = ${new_ens_size}/" run_filter.csh
echo "  input.nml - ens_size"
perl -i.bak -p -e "s/(ens_size\s*)=\s*\d+/\1= ${new_ens_size}/" input.nml 
echo "  input.nml - num_output_state_members"
perl -i.bak -p -e "s/(num_output_state_members\s*)=\s*\d+/\1= ${new_ens_size}/" input.nml 
echo "  input.nml - num_output_obs_members"
perl -i.bak -p -e "s/(num_output_obs_members\s*)=\s*\d+/\1= ${new_ens_size}/" input.nml 

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/shell_scripts/COAMPS_RESTART_SCRIPTS/change_ens_size.sh $
# $Revision: 6256 $
# $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $
