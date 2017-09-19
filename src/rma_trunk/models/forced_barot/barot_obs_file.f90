! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: barot_obs_file.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
 
program barot_obs_file

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/forced_barot/barot_obs_file.f90 $
! $Id: barot_obs_file.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $

! Generates a regular set, currently hardcoded to 40 by 30,
! of observation file locations for the forced barot model.

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/forced_barot/barot_obs_file.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 10977 $"
character(len=128), parameter :: revdate  = "$Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $"

write(*, *) 1200
do i = 1, 40
   do j = 1, 30
      lon = ((i - 0.5) / 40.0) * 360.0 
! Don't want to have to interpolate lats
      lat = -86.0 + (j / 30.0) * 170.0
      write(*, *) lon, lat, (1e6)**2
   end do
end do
end program barot_obs_file

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/forced_barot/barot_obs_file.f90 $
! $Id: barot_obs_file.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $
