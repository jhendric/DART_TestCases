! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: ftest_f90.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $

program ftest

! very simple fortran program.  used to test compile and run
! of fortran.  if successful, will print a message and exit.

integer :: i, j

   print *, "program start"
   i = 2
   j = 3

   print *, "2 + 3 = ", i + j

   print *, "program end"

end program ftest

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/developer_tests/mpi_utilities/tests/ftest_f90.f90 $
! $Id: ftest_f90.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $
