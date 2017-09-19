! DART software - Copyright UCAR. This open source software is provided
! by UCAR, "as is", without charge, subject to all terms of use at
! http://www.image.ucar.edu/DAReS/DART/DART_download
!
! $Id: x_plus_delta.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $

program x_plus_delta

! Just add deltax to x, to calculate d/dx (observation)

implicit none
integer, parameter   :: r8 = selected_real_kind(14,30)

integer,  parameter  :: model_size = 1
real(r8)             :: x(model_size)
real(r8)             :: deltax     = 1._r8
character (len = 128):: file_in    = 'model.in.bck'
character (len = 128):: file_out   = 'model.in'
integer :: ts, td, i


open(11,file=trim(file_in),status='old')
open(12,file=trim(file_out),status='unknown')
read(11,*)
read(11,*)ts, td
write(12,*)
write(12,*)ts, td
do i = 1, model_size
   read(11,*) x(i)
   x(i) = x(i) + deltax
   write(12,*) x(i)
enddo
close(11)
close(12)

end program x_plus_delta

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/dynamo/x_plus_delta.f90 $
! $Id: x_plus_delta.f90 10977 2017-02-01 18:15:42Z thoar@ucar.edu $
! $Revision: 10977 $
! $Date: 2017-02-01 11:15:42 -0700 (Wed, 01 Feb 2017) $
