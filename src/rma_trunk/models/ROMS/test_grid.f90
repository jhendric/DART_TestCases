! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: test_grid.f90 11612 2017-05-08 22:18:42Z nancy@ucar.edu $

program test_grid

!----------------------------------------------------------------------
! purpose: test routines.  this version for models with oned locations.
!----------------------------------------------------------------------

use             types_mod, only : r8, i8, missing_r8, metadatalength

use         utilities_mod, only : register_module, error_handler, E_MSG, E_ERR, &
                                  initialize_utilities, finalize_utilities,     &
                                  find_namelist_in_file, check_namelist_read,   &
                                  nc_check, E_MSG, open_file, close_file, do_output

use     mpi_utilities_mod, only : initialize_mpi_utilities, finalize_mpi_utilities

use          location_mod, only : location_type, set_location, write_location,  &
                                  get_dist, get_location

use          obs_kind_mod, only : get_index_for_quantity, get_name_for_quantity
                                  

use      obs_sequence_mod, only : static_init_obs_sequence

use       assim_model_mod, only : static_init_assim_model

use      time_manager_mod, only : time_type, set_calendar_type, GREGORIAN,      &
                                  set_time, print_time, print_date, operator(-)

use  ensemble_manager_mod, only : init_ensemble_manager, ensemble_type

use   state_vector_io_mod, only : state_vector_io_init,    &
                                  read_state, write_state

use            filter_mod, only : filter_set_initial_time

use      io_filenames_mod, only : io_filenames_init, file_info_type, get_restart_filename, &
                                  stage_metadata_type, get_stage_metadata

use             model_mod, only : static_init_model, get_model_size, &
                                  get_state_meta_data,       &
                                  model_interpolate

use  distributed_state_mod, only : create_state_window, free_state_window, &
                                   create_mean_window, free_mean_window

use  test_roms_interpolate_mod, only : test_interpolate_single, test_interpolate_range

use netcdf

implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/ROMS/test_grid.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 11612 $"
character(len=128), parameter :: revdate  = "$Date: 2017-05-08 16:18:42 -0600 (Mon, 08 May 2017) $"

!------------------------------------------------------------------
! The namelist variables
!------------------------------------------------------------------

integer(i8)                   :: x_ind   = -1
real(r8), dimension(3)        :: loc_of_interest = -1.0_r8
character(len=metadatalength) :: kind_of_interest = 'ANY'
character(len=metadatalength) :: interp_test_vertcoord = 'VERTISHEIGHT'
logical                       :: verbose = .FALSE.
integer                       :: test1thru = 1
real(r8)               :: interp_test_di = 10.0
real(r8)               :: interp_test_dj = 10.0
real(r8)               :: interp_test_dk = 10.0
real(r8), dimension(2) :: interp_test_jrange = (/   0.0,  120.0 /)
real(r8), dimension(2) :: interp_test_irange = (/   0.0,  120.0 /)
real(r8), dimension(2) :: interp_test_krange = (/   0.0,  100.0 /)
character(len = 129)   :: restart_in_file_name  = 'input'
character(len = 129)   :: restart_out_file_name = 'output'

namelist /test_grid_nml/ x_ind,                                    &
                               loc_of_interest, kind_of_interest,  &
                               interp_test_di, interp_test_irange, &
                               interp_test_dj, interp_test_jrange, &
                               interp_test_dk, interp_test_krange, &
                               interp_test_vertcoord,              &
                               verbose, test1thru,                     &
                               restart_in_file_name, restart_out_file_name

! io variables
integer :: iunit, io
integer :: ios_out
type(file_info_type) :: input_file_info, output_file_info
type(stage_metadata_type) :: stage_info
logical              :: read_time_from_file = .true.


! model state variables
type(ensemble_type) :: ens_handle

type(time_type) :: time1, model_time
integer         :: mykindindex
integer(i8)     :: model_size
real(r8)        :: interp_vals

! misc. variables
integer :: dom, mem, num_ens, num_failed

! error handler strings
character(len=512) :: string1

!----------------------------------------------------------------------
! This portion checks the geometry information.
!----------------------------------------------------------------------

call initialize_modules_used()

call find_namelist_in_file("input.nml", "test_grid_nml", iunit)
read(iunit, nml = test_grid_nml, iostat = io)
call check_namelist_read(iunit, io, "test_grid_nml")

call print_test_message('RUNNING TEST 1', &
                        'Reading the namelist and running static_init_model', &
                        'calling get_model_size()')

! only running for single member and ROMS only has one domain
num_ens = 1
mem = 1
dom = 1

call static_init_assim_model()

model_size = get_model_size()

if ( do_output() ) then 
   write(*,*)
   write(*,'(''state vector has length'',i10)') model_size
   write(*,*)
endif

call print_test_message('FINISHED TEST 1')

if ( test1thru == 1 ) call exit(0)


call print_test_message('RUNNING TEST 2', &
                        'Read and write trivial restart file')

call set_calendar_type(GREGORIAN)

model_time  = set_time(21600, 149446)   ! 06Z 4 March 2010

! Set up the ensemble storage and read in the restart file
call init_ensemble_manager(ens_handle, num_ens, model_size)

! Reading netcdf restart file:
call io_filenames_init(input_file_info, num_ens, .false., .false., root_name='input')
call io_filenames_init(output_file_info, num_ens, .false.,.false.,  root_name='output')


!----------------------------------------------------------------------
! Open a test netcdf initial conditions file.
!----------------------------------------------------------------------
stage_info = get_stage_metadata(input_file_info)
if ( do_output() ) write(*,*) 'Reading File : ', trim( get_restart_filename(stage_info, mem, domain=dom) )
call read_state(ens_handle, input_file_info,  read_time_from_file, time1)
model_time = time1

stage_info = get_stage_metadata(output_file_info)
if ( do_output() ) write(*,*) 'Writing File : ', trim( get_restart_filename(stage_info, mem, domain=dom) )
call write_state(ens_handle, output_file_info)

write(*,*) 
call print_date( model_time,' test_grid:model date')
call print_time( model_time,' test_grid:model time')

call print_test_message('FINISHED TEST 2')

if ( test1thru == 2 ) call exit(0)

!----------------------------------------------------------------------
! Check the meta data
!----------------------------------------------------------------------

call print_test_message('RUNNING TEST 3', &
                        'Testing get_state_meta_data')

if ( x_ind > 0 .and. x_ind <= model_size ) then
   call check_meta_data( x_ind )
else
   if ( do_output() ) write(*,*) "x_ind = ", x_ind, " not in valid range of model 0-", model_size
endif

call print_test_message('FINISHED TEST 3')

if ( test1thru == 3 ) call exit(0)

!----------------------------------------------------------------------
! Check the interpolation - print initially to STDOUT
!----------------------------------------------------------------------

call print_test_message('RUNNING TEST 4', &
                        'Testing loc_of_interest for model_interpolate')

call create_state_window(ens_handle)

mykindindex = get_index_for_quantity(kind_of_interest)

if ( do_output() ) write(*,*) "interpolating at di,dj,dk                   :", &
                                      loc_of_interest(1), &
                                      loc_of_interest(2), &
                                      loc_of_interest(3)

num_failed = test_interpolate_single( ens_handle,            &
                                      interp_test_vertcoord, &
                                      loc_of_interest(1),    &
                                      loc_of_interest(2),    &
                                      loc_of_interest(3),    &
                                      mykindindex,           &
                                      interp_vals,           &
                                      ios_out )
print*, ' ' 

call print_test_message('FINISHED TEST 4')

if ( test1thru == 4 ) call exit(0)

call print_test_message('RUNNING TEST 5', &
                        'Testing range of data for model_interpolate')

num_failed = test_interpolate_range( ens_handle,            &
                                     interp_test_dj,      &
                                     interp_test_di,      &
                                     interp_test_dk,     &
                                     interp_test_vertcoord, &
                                     interp_test_irange,  &
                                     interp_test_jrange,  &
                                     interp_test_krange, &
                                     mykindindex,           &
                                     verbose )

call print_test_message('FINISHED TEST 5')

! finalize test_grid
call error_handler(E_MSG,'full_test_grid','Finished successfully.',source,revision,revdate)
call finalize_mpi_utilities()

!----------------------------------------------------------------------

contains

!----------------------------------------------------------------------
subroutine check_meta_data( iloc )

integer(i8), intent(in) :: iloc
type(location_type) :: loc
integer             :: var_kind

if ( do_output() ) then
   write(*,*)
   write(*,*)'Checking metadata routines.'
   write(*,*)
endif

call get_state_meta_data(iloc, loc, var_kind)

call write_location(42, loc, fform='formatted', charstring=string1)

if ( do_output() ) then
   write(*,*)
   write(*,*)' indx ',iloc,' is type ',var_kind, 'name : ', get_name_for_quantity(var_kind)
   write(*,*)'   ', trim(string1)
endif 

end subroutine check_meta_data

!----------------------------------------------------------------------

subroutine initialize_modules_used()

! Standard initialization (mpi not needed to use ensemble manager
! since we are enforcing that this run as a single task).
call initialize_mpi_utilities('test_grid')

! Initialize modules used that require it
call register_module(source,revision,revdate)

! Initialize modules used that require it
call static_init_obs_sequence()

call state_vector_io_init()

end subroutine initialize_modules_used

!----------------------------------------------------------------------

subroutine print_test_message(test_msg, msg1, msg2, msg3)

character(len=*), intent(in) :: test_msg
character(len=*), intent(in), optional :: msg1
character(len=*), intent(in), optional :: msg2
character(len=*), intent(in), optional :: msg3

character(len=64) :: msg_string
character(len=64) :: msg_close

if ( do_output() ) then
   write(msg_string,*) '******************** ', trim(test_msg), ' *************************'
   write(msg_close ,*) '*************************************************************'

   write(*,*)
                        write(*,*) trim(msg_string)
   if ( present(msg1) ) write(*,*) ' ', trim(msg1)
   if ( present(msg2) ) write(*,*) ' --', trim(msg2)
   if ( present(msg3) ) write(*,*) ' --', trim(msg3)
   if ( present(msg1) ) write(*,*) trim(msg_close)

   write(*,*)
endif

end subroutine print_test_message


!----------------------------------------------------------------------


end program test_grid

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/ROMS/test_grid.f90 $
! $Id: test_grid.f90 11612 2017-05-08 22:18:42Z nancy@ucar.edu $
! $Revision: 11612 $
! $Date: 2017-05-08 16:18:42 -0600 (Mon, 08 May 2017) $
