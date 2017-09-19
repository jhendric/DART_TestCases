! This code is not protected by the DART copyright agreement.
! DART $Id: sqg.f90 6256 2013-06-12 16:19:10Z thoar $

!========================================================================
PROGRAM sqg

   USE sqg_mod, ONLY : sqg_main

   implicit none

   call sqg_main()

   stop

END PROGRAM sqg
!========================================================================

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/sqg/sqg.f90 $
! $Id: sqg.f90 6256 2013-06-12 16:19:10Z thoar $
! $Revision: 6256 $
! $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $
