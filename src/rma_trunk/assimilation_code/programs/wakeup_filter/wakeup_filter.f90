! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: wakeup_filter.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $

program wakeup_filter

! spread out on the processors in the same order as the executable
! model and filter programs, and echo into the fifo (named pipe)
! a message to wake up the sleeping filter program.

use mpi_utilities_mod, only : initialize_mpi_utilities, &
                              finalize_mpi_utilities,   &
                              restart_task


call initialize_mpi_utilities("Wakeup_Filter")

call restart_task()

call finalize_mpi_utilities()


end program wakeup_filter

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/assimilation_code/programs/wakeup_filter/wakeup_filter.f90 $
! $Id: wakeup_filter.f90 11289 2017-03-10 21:56:06Z hendric@ucar.edu $
! $Revision: 11289 $
! $Date: 2017-03-10 14:56:06 -0700 (Fri, 10 Mar 2017) $
