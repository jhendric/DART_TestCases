! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: default_location_mod.f90 11410 2017-03-29 21:26:34Z nancy@ucar.edu $

module default_location_mod

! For location modules which do NOT have multiple choices for
! the vertical coordinate, this routine can be 'use'd by other
! location modules to pass through routines which aren't asking
! useful questions.  this code shouldn't be called directly by
! anything outside of the location modules.

use            types_mod, only : r8
use        utilities_mod, only : register_module
use ensemble_manager_mod, only : ensemble_type

implicit none
private

public :: has_vertical_choice, vertical_localization_on, &
          get_vertical_localization_coord, set_vertical_localization_coord

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/location/utilities/default_location_mod.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 11410 $"
character(len=128), parameter :: revdate  = "$Date: 2017-03-29 15:26:34 -0600 (Wed, 29 Mar 2017) $"

integer :: location_vertical_localization_coord = 0

logical, save :: module_initialized = .false.

character(len = 129) :: errstring

contains

!----------------------------------------------------------------------------

subroutine initialize_module
 
if (module_initialized) return

call register_module(source, revision, revdate)
module_initialized = .true.

end subroutine initialize_module

!----------------------------------------------------------------------------

function has_vertical_choice()

logical :: has_vertical_choice
 
if ( .not. module_initialized ) call initialize_module

has_vertical_choice = .false.

end function has_vertical_choice

!----------------------------------------------------------------------------

function get_vertical_localization_coord()

integer :: get_vertical_localization_coord

if ( .not. module_initialized ) call initialize_module

get_vertical_localization_coord = location_vertical_localization_coord

end function get_vertical_localization_coord

!----------------------------------------------------------------------------

subroutine set_vertical_localization_coord(which_vert)
 
integer, intent(in) :: which_vert

if ( .not. module_initialized ) call initialize_module

location_vertical_localization_coord = which_vert

end subroutine set_vertical_localization_coord

!---------------------------------------------------------------------------

function vertical_localization_on()
 
logical :: vertical_localization_on

if ( .not. module_initialized ) call initialize_module

vertical_localization_on = .false.

end function vertical_localization_on

!----------------------------------------------------------------------------

end module default_location_mod

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/location/utilities/default_location_mod.f90 $
! $Id: default_location_mod.f90 11410 2017-03-29 21:26:34Z nancy@ucar.edu $
! $Revision: 11410 $
! $Date: 2017-03-29 15:26:34 -0600 (Wed, 29 Mar 2017) $
