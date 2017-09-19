! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: filter.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

!> \dir filter  Main program contained here
!> \file filter.f90 Main program

program filter

!> \mainpage filter Main DART Ensemble Filtering Program
!> @{ \brief routine to perform ensemble filtering
!>

use mpi_utilities_mod, only : initialize_mpi_utilities, finalize_mpi_utilities
use        filter_mod, only : filter_main

implicit none

!----------------------------------------------------------------

call initialize_mpi_utilities('Filter')

call filter_main()

call finalize_mpi_utilities()

!> @}

end program filter

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/filter/filter.f90 $
! $Id: filter.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
