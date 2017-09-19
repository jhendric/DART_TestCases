! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: null_restart_pnetcdf_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

module restart_pnetcdf_mod

use ensemble_manager_mod,  only : ensemble_type
use time_manager_mod,      only : time_type

implicit none
private

public :: read_ensemble_restart_parallel, write_ensemble_restart_parallel, query_pnetcdf

contains

!-----------------------------------------------------------
!> Tell ensemble manager whether or not the code has been compiled with pnetcdf.
function query_pnetcdf()

logical :: query_pnetcdf
query_pnetcdf = .false.

end function

!------------------------------------------------------
!> null version - does nothing
subroutine read_ensemble_restart_parallel(ens_handle, file_name, start_copy, end_copy, giant_restart, transpose_giant, init_time)

type(ensemble_type),  intent(inout) :: ens_handle
character(len = *),   intent(in)    :: file_name
integer,              intent(in)    :: start_copy, end_copy
logical,              intent(in)    :: giant_restart
logical,              intent(in)    :: transpose_giant
type(time_type),      intent(in),    optional :: init_time

end subroutine read_ensemble_restart_parallel

!------------------------------------------------------
!> null version - does nothing
subroutine write_ensemble_restart_parallel(ens_handle, file_name, start_copy, end_copy, giant_restart, transpose_giant, init_time)

type(ensemble_type),  intent(inout) :: ens_handle
character(len = *),   intent(in)    :: file_name
integer,              intent(in)    :: start_copy, end_copy
logical,              intent(in)    :: giant_restart
logical,              intent(in)    :: transpose_giant
type(time_type),      intent(in),    optional :: init_time


end subroutine write_ensemble_restart_parallel
!------------------------------------------------------

end module restart_pnetcdf_mod

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/modules/utilities/null_restart_pnetcdf_mod.f90 $
! $Id: null_restart_pnetcdf_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
