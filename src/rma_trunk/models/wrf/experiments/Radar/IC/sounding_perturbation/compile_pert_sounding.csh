#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: compile_pert_sounding.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $


# Compiles pert_sounding.f90 for ocotillo

#ifort -c pert_sounding_module.f90
#ifort pert_sounding.f90 -o pert_sounding pert_sounding_module.o
#\rm ./pert_sounding_mod.mod



# Compiles pert_sounding.f90 for bluefire

xlf -c pert_sounding_module.f90
xlf pert_sounding.f90 -o pert_sounding pert_sounding_module.o
rm ./pert_sounding_mod.mod

exit $status

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/experiments/Radar/IC/sounding_perturbation/compile_pert_sounding.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

