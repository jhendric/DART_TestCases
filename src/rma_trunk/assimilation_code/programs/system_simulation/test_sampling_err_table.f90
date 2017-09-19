! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: test_sampling_err_table.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

!> Correct covariances for fixed ensemble sizes.
!> Ref: Anderson, J., 2012: 
!> Localization and Sampling Error Correction in Ensemble Kalman Filter Data Assimilation.
!> Mon. Wea. Rev., 140, 2359-2371, doi: 10.1175/MWR-D-11-00013.1. 

!> read the entry for a single ensemble_size and print out the
!> two values, true_correl_mean and alpha.   mostly as a test for
!> accuracy, but also example code for assim_tools to use.

program test_sampling_err_table

use types_mod,      only : r8
use utilities_mod,  only : error_handler, E_ERR, nc_check,      &
                           initialize_utilities, finalize_utilities

use sampling_error_correction_mod, only : get_sampling_error_table_size, &
                                          read_sampling_error_correction

use netcdf

implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/system_simulation/test_sampling_err_table.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 11289 $"
character(len=128), parameter :: revdate  = "$Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $"


real(r8), allocatable :: true_correl_mean(:), alpha(:)

integer :: i, requested_ens_size, table_size

!
! start of executable code
!

call initialize_utilities('test_sampling_err_table')

print *, 'Enter ensemble size: '
read *, requested_ens_size

table_size = get_sampling_error_table_size()

allocate(true_correl_mean(table_size), alpha(table_size))

print *, 'Reading sampling error correction factors for ensemble size of ',requested_ens_size
call read_sampling_error_correction(requested_ens_size, true_correl_mean, alpha)

print *, 'bin, true correlation, and alphas read from database: '
do i=1, table_size
   print *, i, true_correl_mean(i), alpha(i)
enddo

deallocate(true_correl_mean, alpha)

call finalize_utilities()

end program test_sampling_err_table

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/system_simulation/test_sampling_err_table.f90 $
! $Id: test_sampling_err_table.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
