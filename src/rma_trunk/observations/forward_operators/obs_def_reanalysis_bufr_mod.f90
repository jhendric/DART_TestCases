! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: obs_def_reanalysis_bufr_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

! BEGIN DART PREPROCESS KIND LIST
!RADIOSONDE_U_WIND_COMPONENT,  QTY_U_WIND_COMPONENT,     COMMON_CODE
!RADIOSONDE_V_WIND_COMPONENT,  QTY_V_WIND_COMPONENT,     COMMON_CODE
!RADIOSONDE_GEOPOTENTIAL_HGT,  QTY_GEOPOTENTIAL_HEIGHT,  COMMON_CODE
!RADIOSONDE_SURFACE_PRESSURE,  QTY_SURFACE_PRESSURE,     COMMON_CODE
!RADIOSONDE_TEMPERATURE,       QTY_TEMPERATURE,          COMMON_CODE
!RADIOSONDE_SPECIFIC_HUMIDITY, QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!DROPSONDE_U_WIND_COMPONENT,   QTY_U_WIND_COMPONENT,     COMMON_CODE
!DROPSONDE_V_WIND_COMPONENT,   QTY_V_WIND_COMPONENT,     COMMON_CODE
!DROPSONDE_SURFACE_PRESSURE,   QTY_SURFACE_PRESSURE,     COMMON_CODE
!DROPSONDE_TEMPERATURE,        QTY_TEMPERATURE,          COMMON_CODE
!DROPSONDE_SPECIFIC_HUMIDITY,  QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!AIRCRAFT_U_WIND_COMPONENT,    QTY_U_WIND_COMPONENT,     COMMON_CODE
!AIRCRAFT_V_WIND_COMPONENT,    QTY_V_WIND_COMPONENT,     COMMON_CODE
!AIRCRAFT_TEMPERATURE,         QTY_TEMPERATURE,          COMMON_CODE
!AIRCRAFT_SPECIFIC_HUMIDITY,   QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!ACARS_U_WIND_COMPONENT,       QTY_U_WIND_COMPONENT,     COMMON_CODE
!ACARS_V_WIND_COMPONENT,       QTY_V_WIND_COMPONENT,     COMMON_CODE
!ACARS_TEMPERATURE,            QTY_TEMPERATURE,          COMMON_CODE
!ACARS_SPECIFIC_HUMIDITY,      QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!MARINE_SFC_U_WIND_COMPONENT,  QTY_U_WIND_COMPONENT,     COMMON_CODE
!MARINE_SFC_V_WIND_COMPONENT,  QTY_V_WIND_COMPONENT,     COMMON_CODE
!MARINE_SFC_TEMPERATURE,       QTY_TEMPERATURE,          COMMON_CODE
!MARINE_SFC_SPECIFIC_HUMIDITY, QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!MARINE_SFC_PRESSURE,          QTY_SURFACE_PRESSURE,     COMMON_CODE
!LAND_SFC_U_WIND_COMPONENT,    QTY_U_WIND_COMPONENT,     COMMON_CODE
!LAND_SFC_V_WIND_COMPONENT,    QTY_V_WIND_COMPONENT,     COMMON_CODE
!LAND_SFC_TEMPERATURE,         QTY_TEMPERATURE,          COMMON_CODE
!LAND_SFC_SPECIFIC_HUMIDITY,   QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!LAND_SFC_PRESSURE,            QTY_SURFACE_PRESSURE,     COMMON_CODE
!SAT_U_WIND_COMPONENT,         QTY_U_WIND_COMPONENT,     COMMON_CODE
!SAT_V_WIND_COMPONENT,         QTY_V_WIND_COMPONENT,     COMMON_CODE
!ATOV_TEMPERATURE,             QTY_TEMPERATURE,          COMMON_CODE
!AIRS_TEMPERATURE,             QTY_TEMPERATURE,          COMMON_CODE
!AIRS_SPECIFIC_HUMIDITY,       QTY_SPECIFIC_HUMIDITY,    COMMON_CODE
!GPS_PRECIPITABLE_WATER,       QTY_PRECIPITABLE_WATER,   COMMON_CODE
! END DART PREPROCESS KIND LIST

! !!! Note about Specific Humidity observations:
! !!! UNITS in original BUFR are g/kg; This is converted to kg/kg by
! !!! the BUFR to obs_sequence conversion programs making it unnecessary
! !!! to multiply by 1000 at assimilation time.
! !!! PLEASE pay attention to units for specific humidity in models.

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/observations/forward_operators/obs_def_reanalysis_bufr_mod.f90 $
! $Id: obs_def_reanalysis_bufr_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
