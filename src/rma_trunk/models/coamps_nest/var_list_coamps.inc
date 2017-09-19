! This code is not protected by the DART copyright agreement.
! DART $Id: var_list_coamps.inc 6256 2013-06-12 16:19:10Z thoar $

! rcs keywords: &RCSfile& 
!               &Revision: 2479 & &Date: 2006-08-21 00:41:09 +0000 (Mon, 21 Aug 2006) &
! SCCS IDENTIFICATION:  %W% %G% 
!                       %U% %P% 
!
!     master list for the variables identified by NAVDAS
!
      integer, parameter :: mx_nm_var=17  ! number of variable types
!
      integer     numb_var(mx_nm_var)          ! index for variable types
      integer     nvar
      character(len=8) c_label_var(mx_nm_var)       ! labels for variable types
!
      data (numb_var(nvar),c_label_var(nvar),nvar=1,mx_nm_var) &
      /      1,'Z'      &  ! height in geopotential
      ,      2,'T'      &  ! temperature in deg K
      ,      3,'u'      &  ! u in m sec^(-1)
      ,      4,'v'      &  ! v in m sec^(-1)
      ,      5,'prh'    &  ! pseudo-relative humidity (%)
      ,      6,'o3'     &  ! ozone mixing ratio (???)
      ,      7,'dd'     &  ! wind direction (deg)
      ,      8,'ff'     &  ! wind speed (m/s)
      ,      9,'thk'    &  ! thickness (gpm)
      ,     10,'P_msl'  &  ! MSL pressure (mb)
      ,     11,'P_stn'  &  ! Station pressure (mb)
      ,     12,'T_dpd'  &  ! dewpoint depression (deg K)
      ,     13,'bT'     &  ! brightness temperature (deg K)
      ,     14,'TPPW'   &  ! total precip water (gm/m^2)
      ,     15,'q'      &  ! specific humidity in kg/kg
      ,     22,'theta'  &  ! potential temperature (deg K)
      ,     23,'lnq'  /   ! ln(mixing ratio) or ln(specific humidity)

! <next few lines under version control, do not edit>
! $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/coamps_nest/var_list_coamps.inc $
! $Id: var_list_coamps.inc 6256 2013-06-12 16:19:10Z thoar $
! $Revision: 6256 $
! $Date: 2013-06-12 10:19:10 -0600 (Wed, 12 Jun 2013) $
