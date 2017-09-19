! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: trans_coamps_to_dart.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $

program trans_coamps_to_dart

! This program pulls pieces out of the large COAMPS restart file,
! then assembles them into a state vector that can be used by DART.
! This includes two pieces of information - the current time and
! the actual state
!
! DART $Id: trans_coamps_to_dart.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $

  use coamps_translate_mod, only : initialize_translator,         &
                                   generate_coamps_filenames,     &
                                   open_coamps_files,             &
                                   coamps_read_all_fields,        &
                                   convert_coamps_state_to_dart,  &
                                   set_dart_current_time,         &
                                   open_dart_file, dart_write,    &
                                   finalize_translator

  implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/trans_coamps_to_dart.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 10977 $"
character(len=128), parameter :: revdate  = "$Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $"
 
  ! The translation module uses internal flags for whether it's
  ! reading or writing - these are just aliases so it's clearer
  ! what the calls are saying
  logical, parameter :: READING_COAMPS = .false.
  logical, parameter :: WRITING_DART   = .true.

  call initialize_translator()

  call generate_coamps_filenames(READING_COAMPS)
  call open_coamps_files(READING_COAMPS)

  call coamps_read_all_fields()
  call convert_coamps_state_to_dart()

  call set_dart_current_time()

  call open_dart_file(WRITING_DART)
  call dart_write()

  call finalize_translator()
end program trans_coamps_to_dart

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/trans_coamps_to_dart.f90 $
! $Id: trans_coamps_to_dart.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $
