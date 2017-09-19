! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: obs_def_QuikSCAT_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

! This module supports the observation types from the SeaWinds instrument
! on the QuiKSCAT satellite.
! http://winds.jpl.nasa.gov/missions/quikscat/index.cfm
! Since the data already have an NCEP BUFR 'code' of QKSWND,
! we will drag that along.

! While nothing specific needs to be done to use QuikSCAT winds, declaring
! a specific type for them allows for the ability to differentiate them
! from other wind observation types, allowing for impact assessment, for example.

! BEGIN DART PREPROCESS KIND LIST
! QKSWND_U_WIND_COMPONENT,  QTY_U_WIND_COMPONENT,  COMMON_CODE
! QKSWND_V_WIND_COMPONENT,  QTY_V_WIND_COMPONENT,  COMMON_CODE
! END DART PREPROCESS KIND LIST

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/forward_operators/obs_def_QuikSCAT_mod.f90 $
! $Id: obs_def_QuikSCAT_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
