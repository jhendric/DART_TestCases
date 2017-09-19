! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: create_obs_sequence.f90 11667 2017-05-26 15:47:11Z jla@ucar.edu $

program create_obs_sequence

use    utilities_mod, only : register_module, initialize_utilities, finalize_utilities, &
                             error_handler, E_MSG
use obs_sequence_mod, only : obs_sequence_type, write_obs_seq, &
                             interactive_obs_sequence, static_init_obs_sequence
use  assim_model_mod, only : static_init_assim_model

implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/create_obs_sequence/create_obs_sequence.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 11667 $"
character(len=128), parameter :: revdate  = "$Date: 2017-05-26 09:47:11 -0600 (Fri, 26 May 2017) $"

type(obs_sequence_type) :: seq
character(len=256)      :: file_name

! Record the current time, date, etc. to the logfile
call initialize_utilities('create_obs_sequence')
call register_module(source,revision,revdate)

! Initialize the assim_model module, need this to get model
! state meta data for locations of identity observations
call static_init_assim_model()

! Initialize the obs_sequence module
call static_init_obs_sequence()

! Interactive creation of an observation sequence
seq = interactive_obs_sequence()

! Write the sequence to a file
write(*, *) 'Input filename for sequence (<return> for set_def.out )'
read(*, 11) file_name
11 format(a256)
if(file_name == '') file_name = 'set_def.out'

call write_obs_seq(seq, file_name)

call error_handler(E_MSG,'create_obs_sequence','Finished successfully.',source,revision,revdate)
call finalize_utilities()

end program create_obs_sequence

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/create_obs_sequence/create_obs_sequence.f90 $
! $Id: create_obs_sequence.f90 11667 2017-05-26 15:47:11Z jla@ucar.edu $
! $Revision: 11667 $
! $Date: 2017-05-26 09:47:11 -0600 (Fri, 26 May 2017) $
