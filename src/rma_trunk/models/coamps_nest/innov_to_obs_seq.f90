! This code may (or may not) be part of the COAMPS distribution,
! So it is not protected by the DART copyright agreement.
!
! DART $Id: innov_to_obs_seq.f90 6256 2013-06-12 16:19:10Z thoar $

program innov_to_obs_seq

   use navdas_innov_mod, only : seq,                         &
                                num_copies,                  &
                                num_qc,                      &
                                read_ngt_file,               &
                                open_ngt_file,               &
                                open_innov_file,             &
                                read_innov_header,           &
                                read_innov_data,             &
                                get_max_obs,                 &
                                init_navdas_innov_mod,       &
                                terminate_navdas_innov_mod,  &
                                obs_seq_in_name

   use obs_sequence_mod, only : obs_sequence_type,           &
                                init_obs_sequence,           &
                                set_copy_meta_data,          &
                                set_qc_meta_data,            &
                                write_obs_seq

  implicit none

! version controlled file description for error handling, do not edit
character(len=256), parameter :: source   = &
   "$URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/innov_to_obs_seq.f90 $"
character(len=32 ), parameter :: revision = "$Revision: 6256 $"
character(len=128), parameter :: revdate  = "$Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $"

  character(len=*), parameter :: routine = 'innov_to_obs_seq'

  integer :: max_obs

  call init_navdas_innov_mod()

  call open_innov_file()
  call read_innov_header()

  call open_ngt_file()

  max_obs = get_max_obs()
  
  call init_obs_sequence(seq, num_copies, num_qc, max_obs)
  call set_copy_meta_data(seq, num_copies, 'observation')
  call set_qc_meta_data(seq, num_qc, 'navdas qc')

  call read_ngt_file()

  call read_innov_data()

  call write_obs_seq(seq, obs_seq_in_name)

  call terminate_navdas_innov_mod()

end program innov_to_obs_seq

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/innov_to_obs_seq.f90 $
! $Id: innov_to_obs_seq.f90 6256 2013-06-12 16:19:10Z thoar $
! $Revision: 6256 $
! $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $
