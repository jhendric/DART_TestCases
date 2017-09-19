! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: obs_def_cloud_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

! BEGIN DART PREPROCESS KIND LIST
!CLOUD_LIQUID_WATER, QTY_CLOUD_LIQUID_WATER,  COMMON_CODE
!CLOUD_ICE,          QTY_CLOUD_ICE,           COMMON_CODE
!CLOUD_FRACTION,     QTY_CLOUD_FRACTION,      COMMON_CODE
! END DART PREPROCESS KIND LIST

! eventually these should become the following to be consistent
! with other types of mixing ratios.  this is just a proposed
! rename of the KIND; any code using it would remain the same.
! but multiple models and forward operators could be using the old
! names; the change must be coordinated across the entire project.
!!QTY_CLOUD_LIQUID_WATER -> QTY_CLOUDWATER_MIXING_RATIO
!!QTY_CLOUD_ICE -> QTY_ICE_MIXING_RATIO

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/forward_operators/obs_def_cloud_mod.f90 $
! $Id: obs_def_cloud_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
