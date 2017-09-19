! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: obs_def_cice_mod.f90 11700 2017-06-07 01:36:03Z thoar@ucar.edu $

! FIXME: check to see if obs are of volume or thickness - for now we
! will assume volume.

! FIXME: do we want to identify the satellite? (yes)
!  AMSRE is a passive microwave

! BEGIN DART PREPROCESS KIND LIST
!SAT_SEAICE_AGREG_CONCENTR,       QTY_SEAICE_AGREG_CONCENTR,     COMMON_CODE
!SYN_SEAICE_CONCENTR,             QTY_SEAICE_CONCENTR,           COMMON_CODE
!SAT_SEAICE_AGREG_VOLUME,         QTY_SEAICE_AGREG_VOLUME,       COMMON_CODE
!SAT_SEAICE_AGREG_SNOWVOLUME,     QTY_SEAICE_AGREG_SNOWVOLUME,   COMMON_CODE
!SAT_SEAICE_AGREG_THICKNESS,      QTY_SEAICE_AGREG_THICKNESS,    COMMON_CODE
!SAT_SEAICE_AGREG_SNOWDEPTH,      QTY_SEAICE_AGREG_SNOWDEPTH,    COMMON_CODE
!SAT_U_SEAICE_COMPONENT,          QTY_U_SEAICE_COMPONENT,        COMMON_CODE
!SAT_V_SEAICE_COMPONENT,          QTY_V_SEAICE_COMPONENT,        COMMON_CODE
!SAT_SEAICE_CONCENTR,             QTY_SEAICE_CONCENTR,           COMMON_CODE
!SAT_SEAICE_VOLUME,               QTY_SEAICE_VOLUME,             COMMON_CODE
!SAT_SEAICE_SNOWVOLUME,           QTY_SEAICE_SNOWVOLUME,         COMMON_CODE
!SAT_SEAICE_AGREG_FY,             QTY_SEAICE_AGREG_FY,           COMMON_CODE
!SAT_SEAICE_AGREG_SURFACETEMP,    QTY_SEAICE_AGREG_SURFACETEMP,  COMMON_CODE
! END DART PREPROCESS KIND LIST

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/forward_operators/obs_def_cice_mod.f90 $
! $Id: obs_def_cice_mod.f90 11700 2017-06-07 01:36:03Z thoar@ucar.edu $
! $Revision: 11700 $
! $Date: 2017-06-06 19:36:03 -0600 (Tue, 06 Jun 2017) $
