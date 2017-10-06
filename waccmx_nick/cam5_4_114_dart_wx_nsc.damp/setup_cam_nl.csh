#!/bin/csh
@ n = 1
set stop_n = 6
set cesm_datadir = /glade/p/cesmdata/inputdata
while ($n <= 40)
  if ( $n < 10 ) then
    set fname = user_nl_cam_000$n
  else
    set fname = user_nl_cam_00$n
  endif
  echo $fname
  set inst_string = `printf _%04d $n`

   echo " inithist      = 'ENDOFRUN'"                     >! ${fname}
   echo " ncdata        = 'cam_initial${inst_string}.nc'" >> ${fname}
   echo " empty_htapes  = .true. "                        >> ${fname}
   echo " fincl1        = 'PHIS:I' "                      >> ${fname}
   echo "  fincl2        = 'PS', 'Z3', 'T', 'U', 'V', 'OMEGA', 'DPIE_NE','WACCM_WI','WACCM_UI','WACCM_VI','ElecColDens' " >> ${fname}
   echo "  fincl3		= 'BR', 'BRCL', 'BRO', 'BRONO2', 'CCL4', 'CF2CLBR', 'CF3BR', 'CFC11', " >> ${fname}
   echo "      'CFC113', 'CFC12', 'CH2O', 'CH3BR', 'CH3CCL3', 'CH3CL', 'CH3O2', 'CH3OOH', 'CH4', 'CL'," >> ${fname}
   echo "      'CL2', 'CL2O2', 'CLDHGH', 'CLDLOW', 'CLDMED', 'CLDTOT', 'CLO', 'CLONO2', 'CLOUD', 'CO'," >> ${fname}
   echo "      'CO2', 'DTCOND', 'DTV', 'DUV', 'DVV', 'EKGW', 'FLNS', 'FLNSC', 'FLNT', 'FLNTC'," >> ${fname}
   echo "      'FSDS', 'FSNS', 'FSNSC', 'FSNT', 'FSNTC', 'H', 'H2', 'H2O', 'H2O2', 'HBR'," >> ${fname}
   echo "      'HCFC22', 'HCL', 'HNO3', 'HO2', 'HO2NO2', 'HOBR', 'HOCL', 'HORZ', 'LANDFRAC', 'LHFLX'," >> ${fname}
   echo "      'N', 'N2O', 'N2O5', 'NO', 'NO2', 'NO3', 'O', 'O1D', 'O2', 'O3'," >> ${fname}
   echo "      'OCLO', 'OCNFRAC', 'OH', 'OMEGA', 'PHIS', 'PRECC', 'PRECL', 'PS', 'Q', 'QFLX'," >> ${fname}
   echo "      'RELHUM', 'SHFLX', 'SOLIN', 'SWCF', " >> ${fname}
   echo "      'PSL', 'HNO3_STS', 'HNO3_NAT', 'HNO3_GAS', 'NO_Aircraft', 'NO_Lightning'," >> ${fname}
   echo "      'SAD_ICE', 'SAD_LNAT', 'SAD_SULFC', 'T', 'TREFHT', 'TTGW', 'U'," >> ${fname}
   echo "      'UTGWORO', 'UTGWSPEC', 'V', 'VERT', 'VTGWORO', 'VTGWSPEC', 'Z3', 'O2_1S', 'O2_1D', 'NOX'," >> ${fname}
   echo "      'NOY', 'CLOX', 'CLOY', 'BROX', 'BROY', 'TCLY', 'TOTH', 'UIONTEND', 'VIONTEND'," >> ${fname}
   echo "      'DTCORE', 'CLDLIQ', 'CLDICE', 'CONCLD', 'FRONTGF:I', 'BUTGWSPEC', 'BTAUE', 'BTAUW', 'BTAUN', 'BTAUS'," >> ${fname}
   echo "      'TAUE', 'TAUW', 'TAUN', 'TAUS', 'TAUGWX', 'TAUGWY', 'TAUX', 'TAUY', 'SNOWHLND', 'SNOWHICE'," >> ${fname}
   echo "      'ICEFRAC', 'FSDSC', 'SFNO', 'SFCO', 'SFCH2O', 'CFC11STAR', 'TROPP_FD', 'TElec', 'TIon', 'Op', 'Op2D'," >> ${fname}
   echo "      'O2p', 'Np', 'NOp', 'N2p', 'e', 'KVH', 'KVM', 'KVT', 'EKGW'," >> ${fname}
   echo "      'WACCM_UI', 'WACCM_VI', 'WACCM_WI', 'POTEN', 'SIGMAHAL','SIGMAPED' " >> ${fname}

   echo "  fincl4	= 'PHIS', 'PS', 'PSL', 'Z3', 'QSUM','QO3', 'QCO2', 'QNO', 'QO3P', 'QHC2S', 'QRL_TOT', 'QRS', 'QCP', 'QTHERMAL', 'QRS_TOT'," >> ${fname}
   echo "       'QJOULE', 'QRS_AUR', 'QRS_CO2NIR', 'QRS_EUV', 'SolIonRate_Tot','QPERT','QRL','QRLNLTE','Qbkgndtot'" >> ${fname}

   echo "  fincl5	= 'MSKtem', 'PS', 'PSL', 'VTHzm', 'UVzm', 'UWzm', 'Uzm', 'Vzm', 'THzm','Wzm', 'PHIS'" >> ${fname}
   echo "   solar_parms_file       = '/glade/p/cesm/wawg/marsh/inputdata/wasolar/waxsolar_3hr_c161205.nc' " >> ${fname}

   echo "  nhtfrq        = -$stop_n,-1,-6,-6,-6,-6 "                  >> ${fname}
   #echo "  nhtfrq        = -$stop_n,1,-6,-6,-6,-6 "                  >> ${fname}
   echo "  mfilt         = 1,6,1,1,1 "                           >> ${fname}
   echo "  avgflag_pertape = 'A',  'I',  'I', 'I', 'I' " >> ${fname}
   echo " qbo_cyclic = .false." >> ${fname}
   echo " qbo_use_forcing = .false." >> ${fname}
   echo " fv_div24del2flag = 42" >> ${fname}

  @ n = $n + 1
  rm tmp 



end
