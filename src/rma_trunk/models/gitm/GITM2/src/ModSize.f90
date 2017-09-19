! This code may (or may not) be part of the GITM distribution,
! So it is not protected by the DART copyright agreement.
!
! DART $Id: ModSize.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $

module ModSizeGitm

  integer, parameter :: nLons = 9
  integer, parameter :: nLats = 9
  integer, parameter :: nAlts = 50

  integer, parameter :: nBlocksMax = 4

  integer :: nBlocks

end module ModSizeGitm

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/gitm/GITM2/src/ModSize.f90 $
! $Id: ModSize.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $
