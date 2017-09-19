#!/bin/csh
#
# DART software - Copyright UCAR. This open source software is provided
# by UCAR, "as is", without charge, subject to all terms of use at
# http://www.image.ucar.edu/DAReS/DART/DART_download
#
# DART $Id: gen_pert_bank.csh 10982 2017-02-01 23:43:10Z thoar@ucar.edu $

###########################################################################
# utility to save a set of perturbations generated from WRFDA CV3 option
#
# provide the following:
# namelist.input
# wrfinput_d01
# ensemble size
# list of perturbed variables
# wrfda executable and be.dat
###########################################################################

  set datea = 2010061006 # need to start from a known valid date matching the wrfinput_d01 date

  set wrfda_dir = path/to/WRF and WRFDA/run
           # this has all wrf and wrfda executables and support files
  set work_dir = /where/scratch/is/pert_bank/work
  set save_dir = /where/bank/is/pert_bank/save
           # put the final perturbation files here for later use
  set DART_DIR = /where/dart/is/DART
  set template_dir = /where/template/is
           # where the template namelist is for wrfvar
  set IC_PERT_SCALE = 0.015
  set IC_PERT_UV = 0.004
  set num_ens = 1 # number of perturbations to generate, must be at least ensemble size
  set wrfin_dir = /where/wrfinput/file/is
  set ASSIM_INT_HOURS = 1

  module load nco

  mkdir ${work_dir}
  cd ${work_dir}
  cp ${template_dir}/input.nml.template input.nml
# get a wrfdate and parse
set gdate = (`echo $datea 0h -g | ${DART_DIR}/models/wrf/work/advance_time`)
set gdatef = (`echo $datea ${ASSIM_INT_HOURS}h -g | ${DART_DIR}/models/wrf/work/advance_time`)
set wdate = `echo $datea 0h -w | ${DART_DIR}/models/wrf/work/advance_time`
set yyyy = `echo $datea | cut -b1-4`
set mm = `echo $datea | cut -b5-6`
set dd = `echo $datea | cut -b7-8`
set hh = `echo $datea | cut -b9-10`

  set n = 1
  while ( $n <= $num_ens )
    mkdir ${work_dir}/mem_${n}
    cd ${work_dir}/mem_${n}
    cp ${wrfda_dir}/* ${work_dir}/mem_${n}/.
    ln -sf ${wrfin_dir}/wrfinput_d01 ${work_dir}/mem_${n}/fg
# prep the namelist to run wrfvar
     @ seed_array2 = $n * 10
     cat >! script.sed << EOF
   /run_hours/c\
   run_hours = 0,
   /run_minutes/c\
   run_minutes = 0,
   /run_seconds/c\
   run_seconds = 0,
   /start_year/c\
   start_year = 1*${yyyy},
   /start_month/c\
   start_month = 1*${mm},
   /start_day/c\
   start_day = 1*${dd},
   /start_hour/c\
   start_hour = 1*${hh},
   /start_minute/c\
   start_minute = 1*00,
   /start_second/c\
   start_second = 1*00,
   /end_year/c\
   end_year = 1*${yyyy},
   /end_month/c\
   end_month = 1*${mm},
   /end_day/c\
   end_day = 1*${dd},
   /end_hour/c\
   end_hour = 1*${hh},
   /end_minute/c\
   end_minute = 1*00,
   /end_second/c\
   end_second = 1*00,
   /analysis_date/c\
   analysis_date = \'${wdate}.0000\',
   s/PERT_SCALING/${IC_PERT_SCALE}/
   s/PERT_UV/${IC_PERT_UV}/
   /seed_array1/c\
   seed_array1 = ${datea},
   /seed_array2/c\
   seed_array2 = $seed_array2 /
EOF
   sed -f script.sed ${work_dir}/../namelist.input.3dvar >! ${work_dir}/mem_${n}/namelist.input
# make a run file for wrfvar
   cat >> ${work_dir}/mem_${n}/gen_pert_${n}.csh << EOF

#!/bin/csh
#==================================================================
#BSUB -P NMMM0001
#BSUB -n 32
#BSUB -R "span[ptile=16]"
#BSUB -J gen_pert_${n}
#BSUB -o gen_pert_${n}.%J.log
#BSUB -W 0:03
#BSUB -q regular
#BSUB -x
#==================================================================
   cd ${work_dir}/mem_${n}
   echo $work_dir
   mpirun.lsf ./da_wrfvar.exe >& output.wrfvar
   mv wrfvar_output wrfinput_d01
  
# extract only the fields that are updated by wrfvar, then diff to generate the pert file for this member
   ncks -h -F -A -a -v U,V,T,QVAPOR,MU fg orig_data.nc
   ncks -h -F -A -a -v U,V,T,QVAPOR,MU wrfinput_d01 pert_data.nc
   ncdiff pert_data.nc orig_data.nc pert_bank_mem_${n}.nc
   mv pert_bank_mem_${n}.nc ${save_dir}/pert_bank_mem_${n}.nc
EOF
#
    bsub < ${work_dir}/mem_${n}/gen_pert_${n}.csh
    @ n++
  end

exit 0

# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/wrf/shell_scripts/gen_pert_bank.csh $
# $Revision: 10982 $
# $Date: 2017-02-01 16:43:10 -0700 (Wed, 01 Feb 2017) $

