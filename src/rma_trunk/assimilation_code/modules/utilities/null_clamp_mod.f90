! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: null_clamp_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

module null_clamp_mod

! Aim: to provide interfaces to state_vector_ip
! for models that don't clamp or fail out of bounds
! variables

use types_mod, only : r8

implicit none


contains

!-------------------------------------------------------
!> Null version
!> Check whether you need to error out, clamp, or
!> do nothing depending on the variable bounds
function do_clamp_or_fail(var, dom)

integer, intent(in) :: var ! variable index
integer, intent(in) :: dom ! domain index
logical             :: do_clamp_or_fail

do_clamp_or_fail = .false.

end function do_clamp_or_fail

!-------------------------------------------------------
!> Null version
!> Check a variable for out of bounds and clamp or fail if
!> needed
subroutine clamp_or_fail_it(var_index, dom, variable)

integer,     intent(in) :: var_index ! variable index
integer,     intent(in) :: dom ! domain index
real(r8), intent(inout) :: variable(:) ! variable


end subroutine clamp_or_fail_it


end module null_clamp_mod

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/modules/utilities/null_clamp_mod.f90 $
! $Id: null_clamp_mod.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
